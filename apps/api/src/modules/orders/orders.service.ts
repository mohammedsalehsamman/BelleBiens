import { createHash } from 'node:crypto';
import { Injectable, Logger } from '@nestjs/common';
import { DateTime } from 'luxon';
import { OrderNotifier } from '../../adapters/messaging/order-notifier.js';
import { MediaStorage } from '../../adapters/storage/media-storage.js';
import { Clock } from '../../common/clock/clock.js';
import { AppError } from '../../common/errors/app-error.js';
import { normalizePhone } from '../../common/phone/phone.js';
import type {
  Order,
  OrderStatus,
  Prisma,
  Role,
} from '../../generated/prisma/client.js';
import { PrismaService } from '../../infra/prisma/prisma.service.js';
import type { AuthUser } from '../accounts/auth/auth.decorators.js';
import { AuditService } from '../audit/audit.service.js';
import { CartService, type Priced } from '../cart/cart.service.js';
import { text } from '../catalog/catalog.mapper.js';
import { shopDate } from '../catalog/domain/product-rules.js';
import {
  assertSlot,
  dateString,
  dateValue,
  DeliveryService,
  lockSlot,
} from '../delivery/delivery.service.js';
import { DAILY_TYPES } from '../designer/designer.service.js';
import { canonicalize } from '../designer/domain/spec.js';
import { SettingsService } from '../settings/settings.service.js';
import { OrderEvents } from './order-events.js';
import type { ItemNames, PrintOrder } from './print/order-print.js';
import { PaymentProviders } from './payments/payment-providers.js';
import {
  checkMove,
  customerCanCancel,
  nextStatuses,
  releasesStock,
} from './domain/order-status.js';
import type {
  AdminOrderDto,
  CreateOrderDto,
  OrderDto,
  OrderSummaryDto,
} from './dto/order.dto.js';

/** What is written on an order for its address (FR-ORD-06): the address and its zone then. */
interface AddressSnapshot {
  latitude: number;
  longitude: number;
  label: string;
  area: string;
  landmark: string;
  building: string;
  floor: string;
  details: string;
  zone: {
    slug: string;
    nameAr: string;
    nameEn: string;
    etaAr: string;
    etaEn: string;
  };
}

const ORDER_INCLUDE = {
  lines: { orderBy: { position: 'asc' } },
  history: { orderBy: { createdAt: 'asc' } },
  payments: { orderBy: { createdAt: 'asc' } },
} as const satisfies Prisma.OrderInclude;

export type OrderRow = Prisma.OrderGetPayload<{
  include: typeof ORDER_INCLUDE;
}>;

/** Who moves an order: the customer, staff, or the system (FR-PAY-10). */
export type MoveBy = 'customer' | 'staff' | 'system';

const IDEMPOTENCY_HOURS = 24;

@Injectable()
export class OrdersService {
  private readonly logger = new Logger(OrdersService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
    private readonly settings: SettingsService,
    private readonly cart: CartService,
    private readonly delivery: DeliveryService,
    private readonly audit: AuditService,
    private readonly notifier: OrderNotifier,
    private readonly media: MediaStorage,
    private readonly providers: PaymentProviders,
    private readonly events: OrderEvents,
  ) {}

  // ---------- placing an order ----------

  /**
   * FR-CRT-10: the same Idempotency-Key with the same order returns the first
   * answer, so a retry after a dropped connection never orders twice. The key
   * is claimed before any work; a failed attempt frees it for the next try.
   */
  async place(
    dto: CreateOrderDto,
    key: string,
    user: AuthUser | undefined,
    client: string,
  ): Promise<{ status: number; body: OrderDto }> {
    const hash = createHash('sha256')
      .update(canonicalize({ dto, user: user?.id ?? null }))
      .digest('hex');
    const now = this.clock.now();
    await this.prisma.idempotencyKey.deleteMany({
      where: {
        createdAt: {
          lt: DateTime.fromJSDate(now)
            .minus({ hours: IDEMPOTENCY_HOURS })
            .toJSDate(),
        },
      },
    });
    const claimed = await this.prisma.idempotencyKey.createMany({
      data: [
        { key, requestHash: hash, statusCode: 0, response: {}, createdAt: now },
      ],
      skipDuplicates: true,
    });
    if (claimed.count === 0) {
      const row = await this.prisma.idempotencyKey.findUnique({
        where: { key },
      });
      if (!row) throw new AppError('ORDER_IN_PROGRESS');
      if (row.requestHash !== hash)
        throw new AppError('IDEMPOTENCY_KEY_REUSED');
      if (row.statusCode === 0) throw new AppError('ORDER_IN_PROGRESS');
      return {
        status: row.statusCode,
        body: row.response as unknown as OrderDto,
      };
    }

    try {
      const body = await this.create(dto, user, client);
      await this.prisma.idempotencyKey.update({
        where: { key },
        data: {
          statusCode: 201,
          response: JSON.parse(JSON.stringify(body)) as Prisma.InputJsonValue,
        },
      });
      return { status: 201, body };
    } catch (error) {
      await this.prisma.idempotencyKey
        .delete({ where: { key } })
        .catch(() => undefined);
      throw error;
    }
  }

  private async create(
    dto: CreateOrderDto,
    user: AuthUser | undefined,
    client: string,
  ): Promise<OrderDto> {
    const [mode, payments, usdRate] = await Promise.all([
      this.settings.get('shop.mode'),
      this.settings.get('payments.enabled'),
      this.settings.get('currency.usdRate'),
    ]);
    // FR-ADM-12: closed pauses every new order; busy limits today's slots.
    if (mode === 'closed') throw new AppError('SHOP_CLOSED');
    const enabled = {
      CASH: payments.cash,
      SHAMCASH: payments.shamcash,
      STRIPE: payments.stripe,
    };
    if (
      !enabled[dto.paymentMethod] ||
      // Stripe has no provider until S12, so it is refused even if switched on.
      !this.providers.get(dto.paymentMethod)
    ) {
      throw new AppError('PAYMENT_METHOD_UNAVAILABLE');
    }

    const customerPhone = phoneOf(dto.customer.phone, 'customer.phone');
    const recipient = dto.recipient
      ? {
          name: dto.recipient.name.trim(),
          phone: phoneOf(dto.recipient.phone, 'recipient.phone'),
        }
      : { name: dto.customer.name.trim(), phone: customerPhone };

    // FR-DLV-01/02: the pin decides the zone and the fee.
    let address: AddressSnapshot | null = null;
    let feeMinor = 0;
    if (dto.fulfillment === 'DELIVERY') {
      if (!dto.address) throw new AppError('ADDRESS_REQUIRED');
      const zone = await this.delivery.zoneAt(
        dto.address.latitude,
        dto.address.longitude,
      );
      if (!zone) throw new AppError('OUT_OF_ZONE');
      feeMinor = zone.feeMinor;
      address = {
        latitude: dto.address.latitude,
        longitude: dto.address.longitude,
        label: dto.address.label?.trim() ?? '',
        area: dto.address.area?.trim() ?? '',
        landmark: dto.address.landmark?.trim() ?? '',
        building: dto.address.building?.trim() ?? '',
        floor: dto.address.floor?.trim() ?? '',
        details: dto.address.details?.trim() ?? '',
        zone: {
          slug: zone.slug,
          nameAr: zone.nameAr,
          nameEn: zone.nameEn,
          etaAr: zone.etaAr,
          etaEn: zone.etaEn,
        },
      };
    }

    // Every price from the database, the zone fee included (NFR-SEC-06).
    const { quote, priced } = await this.cart.evaluate(
      { lines: dto.lines, couponCode: dto.couponCode },
      client,
      feeMinor,
    );
    if (!quote.orderable) {
      throw new AppError('CART_NOT_ORDERABLE', {
        extra: {
          lines: quote.lines
            .filter((l) => l.issues.length > 0)
            .map((l) => ({ id: l.id, issues: l.issues })),
        },
      });
    }
    if (dto.couponCode && !quote.coupon?.applied) {
      throw new AppError('COUPON_INVALID', {
        extra: { problem: quote.coupon?.problem },
      });
    }

    const calendar = await this.delivery.calendarSettings();
    const slotTemplate = calendar.slots.find((s) => s.start === dto.slot.start);
    const now = this.clock.now();
    const today = shopDate(now);

    const payment = await this.providers.get(dto.paymentMethod)!.start(now);

    const order = await this.prisma.$transaction(async (tx) => {
      // FR-DLV-04: count the slot's places under its lock; the customer's own
      // hold is theirs to use.
      if (dto.fulfillment === 'DELIVERY')
        await lockSlot(tx, dto.slot.date, dto.slot.start);
      const hold = dto.slotHoldId
        ? await tx.slotHold.findUnique({ where: { id: dto.slotHoldId } })
        : null;
      const ownHold =
        hold &&
        dateString(hold.date) === dto.slot.date &&
        hold.start === dto.slot.start &&
        hold.expiresAt > now
          ? hold.id
          : undefined;
      const taken = await this.delivery.taken(
        dto.slot.date,
        dto.slot.date,
        ownHold,
        tx,
      );
      const slot = this.delivery
        .slotsOf(
          dto.slot.date,
          quote.leadTimeHours,
          dto.fulfillment,
          calendar,
          taken,
        )
        .find((s) => s.start === dto.slot.start);
      assertSlot(slot);

      const reservations = await this.reserve(tx, priced, today);

      // FR-CRT-07: a coupon with a limit is used once per order, never past it.
      if (quote.coupon?.applied) {
        const used = await tx.coupon.updateMany({
          where: {
            code: quote.coupon.code,
            OR: [
              { maxRedemptions: null },
              { redemptions: { lt: tx.coupon.fields.maxRedemptions } },
            ],
          },
          data: { redemptions: { increment: 1 } },
        });
        if (used.count === 0) {
          throw new AppError('COUPON_INVALID', {
            extra: { problem: 'USED_UP' },
          });
        }
      }

      // FR-ORD-01: BB-1001, BB-1002, ... from a database sequence.
      const [{ n }] = await tx.$queryRaw<
        { n: bigint }[]
      >`SELECT nextval('order_number_seq') AS n`;
      const number = `BB-${n}`;

      const created = await tx.order.create({
        data: {
          number,
          userId: user?.id ?? null,
          paymentMethod: dto.paymentMethod,
          fulfillment: dto.fulfillment,
          customerName: dto.customer.name.trim(),
          customerPhone,
          recipientName: recipient.name,
          recipientPhone: recipient.phone,
          hideSender: dto.hideSender ?? false,
          address: (address ?? undefined) as Prisma.InputJsonValue | undefined,
          zoneSlug: address?.zone.slug ?? null,
          slotDate: dateValue(dto.slot.date),
          slotStart: dto.slot.start,
          slotEnd: slotTemplate?.end ?? dto.slot.start,
          callBeforeArrival: dto.callBeforeArrival ?? false,
          whatsappConfirm: dto.whatsappConfirm ?? false,
          notes: dto.notes?.trim() ?? '',
          couponCode: quote.coupon?.applied ? quote.coupon.code : null,
          usdRate,
          itemsMinor: quote.syp.itemsMinor,
          assemblyFeeMinor: quote.syp.assemblyFeeMinor,
          discountMinor: quote.syp.discountMinor,
          deliveryFeeMinor: quote.syp.deliveryFeeMinor,
          roundingMinor: quote.syp.roundingAdjustmentMinor,
          totalMinor: quote.syp.totalMinor,
          totalUsdCents: quote.usd.totalMinor,
          paymentDueAt: payment.dueAt,
          createdAt: now,
          lines: {
            create: priced.map((p, i) => ({
              position: i + 1,
              kind: p.dto.kind,
              titleAr: p.dto.title.ar,
              titleEn: p.dto.title.en,
              summaryAr: p.dto.summary.ar,
              summaryEn: p.dto.summary.en,
              qty: p.dto.qty,
              unitPriceMinor: p.dto.unitPriceMinor,
              totalMinor: p.dto.totalMinor,
              leadTimeHours: p.dto.leadTimeHours,
              choice: this.choiceOf(p),
              imageUrl: this.ownMedia(p.dto.imageUrl),
            })),
          },
          history: {
            create: {
              from: null,
              to: 'NEW',
              byUserId: user?.id ?? null,
              createdAt: now,
            },
          },
          reservations: { create: reservations },
          // FR-PAY-09: the payment's history starts with the order.
          payments: {
            create: {
              kind: 'created',
              method: dto.paymentMethod,
              status: 'PENDING',
              amountMinor: quote.syp.totalMinor,
              byUserId: user?.id ?? null,
              createdAt: now,
            },
          },
        },
        include: ORDER_INCLUDE,
      });
      await this.moved(
        tx,
        reservations,
        -1,
        `order ${number}`,
        user?.id ?? null,
      );

      if (ownHold) await tx.slotHold.delete({ where: { id: ownHold } });
      if (user && address && dto.address?.save) {
        const saved = await tx.address.count({ where: { userId: user.id } });
        await tx.address.create({
          data: {
            userId: user.id,
            isDefault: saved === 0,
            callBeforeArrival: dto.callBeforeArrival ?? false,
            label: address.label || 'العنوان',
            latitude: address.latitude,
            longitude: address.longitude,
            zoneSlug: address.zone.slug,
            area: address.area,
            landmark: address.landmark,
            building: address.building,
            floor: address.floor,
            details: address.details,
          },
        });
      }
      return created;
    });

    await this.notify(() =>
      this.notifier.orderPlaced({
        number: order.number,
        status: order.status,
        fulfillment: order.fulfillment,
        slotDate: dto.slot.date,
        slotStart: order.slotStart,
        totalMinor: order.totalMinor,
        customerPhone,
      }),
    );
    this.events.emit({
      type: 'order.placed',
      number: order.number,
      status: order.status,
      fulfillment: order.fulfillment,
      slotDate: dto.slot.date,
      slotStart: order.slotStart,
      totalMinor: order.totalMinor,
      at: now.toISOString(),
    });
    return this.toDto(order);
  }

  /**
   * FR-INV-02/03: takes the stock in one conditional update per item, so two
   * orders for the last piece cannot both succeed; the loser's transaction
   * rolls back whole. Flowers and greens come from today's list; null counts
   * are made to order.
   */
  private async reserve(
    tx: Prisma.TransactionClient,
    priced: Priced[],
    today: Date,
  ): Promise<Prisma.StockReservationCreateWithoutOrderInput[]> {
    const products = new Map<string, number>();
    const items = new Map<string, number>();
    for (const use of priced.flatMap((p) => p.uses)) {
      if (use.productId)
        products.set(
          use.productId,
          (products.get(use.productId) ?? 0) + use.qty,
        );
      if (use.itemSlug)
        items.set(use.itemSlug, (items.get(use.itemSlug) ?? 0) + use.qty);
    }
    const out: Prisma.StockReservationCreateWithoutOrderInput[] = [];

    // A stable order of updates keeps two orders from waiting on each other.
    for (const [productId, qty] of [...products].sort(([a], [b]) =>
      a.localeCompare(b),
    )) {
      const done = await tx.product.updateMany({
        where: { id: productId, stockQuantity: { gte: qty } },
        data: { stockQuantity: { decrement: qty } },
      });
      if (done.count === 0) {
        const row = await tx.product.findUnique({ where: { id: productId } });
        throw new AppError('STOCK_INSUFFICIENT', {
          extra: {
            itemId: row?.slug,
            requested: qty,
            available: row?.stockQuantity ?? 0,
          },
        });
      }
      out.push({ productId, qty });
    }

    const rows = await tx.designerItem.findMany({
      where: { slug: { in: [...items.keys()] } },
    });
    for (const row of rows.sort((a, b) => a.id.localeCompare(b.id))) {
      const qty = items.get(row.slug)!;
      if (DAILY_TYPES.includes(row.type)) {
        const done = await tx.dailyAvailability.updateMany({
          where: {
            designerItemId: row.id,
            date: today,
            quantity: { gte: qty },
          },
          data: { quantity: { decrement: qty } },
        });
        if (done.count === 0) {
          const daily = await tx.dailyAvailability.findUnique({
            where: {
              designerItemId_date: { designerItemId: row.id, date: today },
            },
          });
          throw new AppError('STOCK_INSUFFICIENT', {
            extra: {
              itemId: row.slug,
              requested: qty,
              available: daily?.quantity ?? 0,
            },
          });
        }
        out.push({ designerItemId: row.id, dailyDate: today, qty });
      } else if (row.stockQuantity !== null) {
        const done = await tx.designerItem.updateMany({
          where: { id: row.id, stockQuantity: { gte: qty } },
          data: { stockQuantity: { decrement: qty } },
        });
        if (done.count === 0) {
          const now = await tx.designerItem.findUnique({
            where: { id: row.id },
          });
          throw new AppError('STOCK_INSUFFICIENT', {
            extra: {
              itemId: row.slug,
              requested: qty,
              available: now?.stockQuantity ?? 0,
            },
          });
        }
        out.push({ designerItemId: row.id, qty });
      }
    }
    return out;
  }

  /** FR-INV-05: each change to a counted stock is logged (daily list changes are not counts). */
  private async moved(
    tx: Prisma.TransactionClient,
    reservations: Prisma.StockReservationCreateWithoutOrderInput[],
    sign: 1 | -1,
    reason: string,
    userId: string | null,
  ): Promise<void> {
    for (const r of reservations) {
      if (r.dailyDate) continue;
      const after = r.productId
        ? (await tx.product.findUnique({ where: { id: r.productId } }))
            ?.stockQuantity
        : (
            await tx.designerItem.findUnique({
              where: { id: r.designerItemId! },
            })
          )?.stockQuantity;
      await tx.stockMovement.create({
        data: {
          productId: r.productId ?? null,
          designerItemId: r.designerItemId ?? null,
          delta: sign * r.qty,
          quantityAfter: after ?? 0,
          reason,
          userId,
          createdAt: this.clock.now(),
        },
      });
    }
  }

  /** What the app sent for the line, kept as it was (FR-ORD-06). */
  private choiceOf(p: Priced): Prisma.InputJsonValue {
    const input = p.input;
    const choice: Record<string, unknown> = {
      id: input.id,
      kind: input.kind,
      qty: input.qty,
    };
    if (input.product) {
      choice.product = {
        slug: input.product.slug,
        options: input.product.options.map((o) => ({
          group: o.group,
          option: o.option,
        })),
        inscription: input.product.inscription,
        referenceImageUrl:
          this.ownMedia(input.product.referenceImageUrl) ?? undefined,
      };
    }
    if (input.spec) choice.spec = input.spec;
    const preview = this.ownMedia(input.previewUrl);
    if (preview) choice.previewUrl = preview;
    return JSON.parse(JSON.stringify(choice)) as Prisma.InputJsonValue;
  }

  /** Only images we stored ourselves go on an order (NFR-SEC-08). */
  private ownMedia(url: string | null | undefined): string | null {
    return url && this.media.owns(url) ? url : null;
  }

  private async notify(send: () => Promise<void>): Promise<void> {
    try {
      await send();
    } catch (error) {
      this.logger.error(`order notice failed: ${String(error)}`);
    }
  }

  // ---------- reading orders ----------

  async mine(userId: string): Promise<OrderSummaryDto[]> {
    const rows = await this.prisma.order.findMany({
      where: { userId },
      include: { lines: { orderBy: { position: 'asc' } } },
      orderBy: { createdAt: 'desc' },
      take: 100,
    });
    return rows.map((r) => ({
      number: r.number,
      status: r.status,
      fulfillment: r.fulfillment,
      createdAt: r.createdAt,
      slot: {
        date: dateString(r.slotDate),
        start: r.slotStart,
        end: r.slotEnd,
      },
      totalMinor: r.totalMinor,
      itemCount: r.lines.reduce((s, l) => s + l.qty, 0),
      paymentStatus: r.paymentStatus,
      paymentMethod: r.paymentMethod,
      title: text(r.lines[0]?.titleAr ?? '', r.lines[0]?.titleEn ?? ''),
      ...(r.lines.find((l) => l.imageUrl)?.imageUrl
        ? { imageUrl: r.lines.find((l) => l.imageUrl)!.imageUrl! }
        : {}),
    }));
  }

  async forUser(number: string, user: AuthUser): Promise<OrderDto> {
    const row = await this.find(number);
    if (row.userId !== user.id)
      throw new AppError('NOT_FOUND', { detail: number });
    return this.toDto(row);
  }

  /** FR-ORD-04: a guest finds the order by its number and the phone on it. */
  async lookup(number: string, phone: string): Promise<OrderDto> {
    const row = await this.find(number);
    if (normalizePhone(phone) !== row.customerPhone) {
      throw new AppError('NOT_FOUND', { detail: number });
    }
    return this.toDto(row);
  }

  /** The order, or NOT_FOUND. */
  async find(number: string): Promise<OrderRow> {
    const row = await this.prisma.order.findUnique({
      where: { number: number.toUpperCase() },
      include: ORDER_INCLUDE,
    });
    if (!row) throw new AppError('NOT_FOUND', { detail: number });
    return row;
  }

  // ---------- changing status ----------

  /** FR-ORD-05: the customer cancels until the shop confirms. */
  async cancelByCustomer(
    number: string,
    user: AuthUser | undefined,
    phone: string | undefined,
    reason: string | undefined,
  ): Promise<OrderDto> {
    const row = await this.find(number);
    if (!this.isOwner(row, user, phone)) {
      throw new AppError('NOT_FOUND', { detail: number });
    }
    return this.move(
      row.number,
      'CANCELLED',
      user ?? null,
      reason ?? 'cancelled by the customer',
      'customer',
    );
  }

  /** UC-04: staff move an order on; every move is checked, logged and audited. */
  async advance(
    number: string,
    to: OrderStatus,
    actor: AuthUser,
    note: string | undefined,
  ): Promise<AdminOrderDto> {
    if (to === 'CANCELLED' && !note?.trim()) {
      throw new AppError('VALIDATION_FAILED', {
        detail: 'a cancellation needs a reason',
      });
    }
    await this.move(
      number.toUpperCase(),
      to,
      actor,
      note?.trim() ?? '',
      'staff',
    );
    return this.forStaff(number, actor.role);
  }

  private async move(
    number: string,
    to: OrderStatus,
    actor: AuthUser | null,
    note: string,
    by: MoveBy,
  ): Promise<OrderDto> {
    const { row, from } = await this.prisma.$transaction(async (tx) => {
      const current = await this.lock(tx, number);
      await this.transitionInTx(tx, current, to, actor, note, by);
      const fresh = await tx.order.findUniqueOrThrow({
        where: { id: current.id },
        include: ORDER_INCLUDE,
      });
      return { row: fresh, from: current.status };
    });
    await this.statusNotice(row, from);
    return this.toDto(row);
  }

  /** Locks the order row, so two people (or a job) take turns on it. */
  async lock(tx: Prisma.TransactionClient, number: string): Promise<Order> {
    await tx.$queryRaw`SELECT id FROM "order" WHERE number = ${number} FOR UPDATE`;
    const current = await tx.order.findUnique({ where: { number } });
    if (!current) throw new AppError('NOT_FOUND', { detail: number });
    return current;
  }

  /**
   * One checked status move inside the caller's transaction: history, stock
   * back on cancel, audit for staff. Payment confirmation (S6) moves the
   * order with it.
   */
  async transitionInTx(
    tx: Prisma.TransactionClient,
    current: Order,
    to: OrderStatus,
    actor: AuthUser | null,
    note: string,
    by: MoveBy,
  ): Promise<void> {
    const now = this.clock.now();
    if (by === 'customer') {
      if (!customerCanCancel(current.status))
        throw new AppError('ORDER_NOT_CANCELLABLE');
    } else if (by === 'staff') {
      const check = checkMove(
        current.status,
        to,
        actor!.role,
        current.fulfillment,
      );
      if (check === 'NOT_ALLOWED') {
        throw new AppError('STATUS_CHANGE_NOT_ALLOWED', {
          extra: { from: current.status, to },
        });
      }
      if (check === 'FORBIDDEN') throw new AppError('FORBIDDEN');
    } else if (current.status !== 'NEW' || to !== 'CANCELLED') {
      // The system only cancels orders nobody confirmed (FR-PAY-10).
      throw new AppError('STATUS_CHANGE_NOT_ALLOWED', {
        extra: { from: current.status, to },
      });
    }

    // Cash is paid when the order is handed over.
    const paid =
      current.paymentMethod === 'CASH' &&
      (to === 'DELIVERED' || to === 'PICKED_UP');
    await tx.order.update({
      where: { id: current.id },
      data: {
        status: to,
        ...(paid ? { paymentStatus: 'PAID' } : {}),
        updatedAt: now,
      },
    });
    if (paid) {
      await tx.paymentEvent.create({
        data: {
          orderId: current.id,
          kind: 'collected',
          method: 'CASH',
          status: 'PAID',
          amountMinor: current.totalMinor,
          byUserId: actor?.id ?? null,
          createdAt: now,
        },
      });
    }
    await tx.orderStatusHistory.create({
      data: {
        orderId: current.id,
        from: current.status,
        to,
        byUserId: actor?.id ?? null,
        note,
        createdAt: now,
      },
    });
    if (releasesStock(to)) {
      await this.release(
        tx,
        current.id,
        current.number,
        current.couponCode,
        actor,
      );
    }
    if (actor && by === 'staff') {
      await this.audit.record(
        {
          actor,
          action: 'order.status.change',
          entity: 'order',
          entityId: current.id,
          before: { status: current.status },
          after: { status: to, note },
        },
        tx,
      );
    }
  }

  /** Tells the customer (S7) and the dashboard stream about a move. */
  async statusNotice(row: OrderRow, from: OrderStatus): Promise<void> {
    if (row.status === from) return;
    this.events.emit({
      type: 'order.status',
      number: row.number,
      status: row.status,
      fulfillment: row.fulfillment,
      slotDate: dateString(row.slotDate),
      slotStart: row.slotStart,
      totalMinor: row.totalMinor,
      at: this.clock.now().toISOString(),
    });
    await this.notify(() =>
      this.notifier.statusChanged({
        number: row.number,
        from,
        status: row.status,
        fulfillment: row.fulfillment,
        slotDate: dateString(row.slotDate),
        slotStart: row.slotStart,
        totalMinor: row.totalMinor,
        customerPhone: row.customerPhone,
      }),
    );
  }

  /** The signed-in owner, or a guest with the order's phone (FR-ORD-04). */
  isOwner(
    row: { userId: string | null; customerPhone: string },
    user: AuthUser | undefined,
    phone: string | undefined,
  ): boolean {
    return (
      (user !== undefined && row.userId === user.id) ||
      (phone !== undefined && normalizePhone(phone) === row.customerPhone)
    );
  }

  /** FR-INV-02: a cancelled order gives back its stock and its coupon use. */
  private async release(
    tx: Prisma.TransactionClient,
    orderId: string,
    number: string,
    couponCode: string | null,
    actor: AuthUser | null,
  ): Promise<void> {
    const held = await tx.stockReservation.findMany({
      where: { orderId, releasedAt: null },
    });
    for (const r of held) {
      if (r.productId) {
        await tx.product.updateMany({
          where: { id: r.productId, stockQuantity: { not: null } },
          data: { stockQuantity: { increment: r.qty } },
        });
      } else if (r.designerItemId && r.dailyDate) {
        await tx.dailyAvailability.updateMany({
          where: { designerItemId: r.designerItemId, date: r.dailyDate },
          data: { quantity: { increment: r.qty } },
        });
      } else if (r.designerItemId) {
        await tx.designerItem.updateMany({
          where: { id: r.designerItemId, stockQuantity: { not: null } },
          data: { stockQuantity: { increment: r.qty } },
        });
      }
    }
    await tx.stockReservation.updateMany({
      where: { orderId, releasedAt: null },
      data: { releasedAt: this.clock.now() },
    });
    await this.moved(
      tx,
      held.map((r) => ({
        productId: r.productId ?? undefined,
        designerItemId: r.designerItemId ?? undefined,
        dailyDate: r.dailyDate ?? undefined,
        qty: r.qty,
      })),
      1,
      `order ${number} cancelled`,
      actor?.id ?? null,
    );
    if (couponCode) {
      await tx.coupon.updateMany({
        where: { code: couponCode, redemptions: { gt: 0 } },
        data: { redemptions: { decrement: 1 } },
      });
    }
  }

  // ---------- the shop's view ----------

  /** What the recipe and the slip print (FR-DSG-16). */
  async printData(
    number: string,
  ): Promise<{ order: PrintOrder; names: ItemNames }> {
    const row = await this.find(number);
    const items = await this.prisma.designerItem.findMany({
      select: { slug: true, nameAr: true },
    });
    const byId = new Map(items.map((i) => [i.slug, i.nameAr]));
    const a = row.address as AddressSnapshot | null;
    return {
      names: (id) => byId.get(id) ?? id,
      order: {
        number: row.number,
        fulfillment: row.fulfillment,
        slotDate: dateString(row.slotDate),
        slotStart: row.slotStart,
        slotEnd: row.slotEnd,
        customerName: row.customerName,
        customerPhone: row.customerPhone,
        recipientName: row.recipientName,
        recipientPhone: row.recipientPhone,
        hideSender: row.hideSender,
        callBeforeArrival: row.callBeforeArrival,
        address: a
          ? {
              label: a.label,
              area: a.area,
              landmark: a.landmark,
              building: a.building,
              floor: a.floor,
              details: a.details,
              zoneName: a.zone.nameAr,
            }
          : null,
        notes: row.notes,
        paymentMethod: row.paymentMethod,
        paymentStatus: row.paymentStatus,
        totalMinor: row.totalMinor,
        lines: row.lines.map((l) => ({
          position: l.position,
          kind: l.kind,
          title: l.titleAr,
          summary: l.summaryAr,
          qty: l.qty,
          imageUrl: l.imageUrl,
          choice: l.choice as Record<string, unknown>,
        })),
      },
    };
  }

  async forStaff(number: string, role: Role): Promise<AdminOrderDto> {
    return this.toAdminDto(await this.find(number), role);
  }

  async listForStaff(
    role: Role,
    filter: { status?: OrderStatus; date?: string },
  ): Promise<AdminOrderDto[]> {
    const rows = await this.prisma.order.findMany({
      where: {
        ...(filter.status ? { status: filter.status } : {}),
        ...(filter.date ? { slotDate: dateValue(filter.date) } : {}),
      },
      include: ORDER_INCLUDE,
      orderBy: [
        { slotDate: 'asc' },
        { slotStart: 'asc' },
        { createdAt: 'asc' },
      ],
      take: 200,
    });
    return rows.map((r) => this.toAdminDto(r, role));
  }

  private toAdminDto(row: OrderRow, role: Role): AdminOrderDto {
    return Object.assign(this.toDto(row), {
      customer: { name: row.customerName, phone: row.customerPhone },
      next: nextStatuses(row.status, role, row.fulfillment),
      payments: row.payments.map((p) => ({
        kind: p.kind,
        method: p.method,
        status: p.status,
        amountMinor: p.amountMinor,
        currency: p.currency,
        ...(p.reference ? { reference: p.reference } : {}),
        ...(p.receiptUrl ? { receiptUrl: p.receiptUrl } : {}),
        note: p.note,
        at: p.createdAt,
      })),
    });
  }

  // ---------- mapping ----------

  toDto(row: OrderRow): OrderDto {
    const address = row.address as AddressSnapshot | null;
    return {
      number: row.number,
      status: row.status,
      paymentStatus: row.paymentStatus,
      paymentMethod: row.paymentMethod,
      fulfillment: row.fulfillment,
      createdAt: row.createdAt,
      recipient: { name: row.recipientName, phone: row.recipientPhone },
      hideSender: row.hideSender,
      ...(address
        ? {
            address: {
              latitude: address.latitude,
              longitude: address.longitude,
              label: address.label,
              area: address.area,
              landmark: address.landmark,
              building: address.building,
              floor: address.floor,
              details: address.details,
            },
            zone: {
              slug: address.zone.slug,
              name: text(address.zone.nameAr, address.zone.nameEn),
              feeMinor: row.deliveryFeeMinor,
              eta: text(address.zone.etaAr, address.zone.etaEn),
            },
          }
        : {}),
      slot: {
        date: dateString(row.slotDate),
        start: row.slotStart,
        end: row.slotEnd,
      },
      callBeforeArrival: row.callBeforeArrival,
      whatsappConfirm: row.whatsappConfirm,
      notes: row.notes,
      ...(row.couponCode ? { couponCode: row.couponCode } : {}),
      lines: row.lines.map((l) => ({
        position: l.position,
        kind: l.kind,
        title: text(l.titleAr, l.titleEn),
        summary: text(l.summaryAr, l.summaryEn),
        qty: l.qty,
        unitPriceMinor: l.unitPriceMinor,
        totalMinor: l.totalMinor,
        ...(l.imageUrl ? { imageUrl: l.imageUrl } : {}),
        choice: l.choice as unknown as OrderDto['lines'][number]['choice'],
      })),
      syp: {
        itemsMinor: row.itemsMinor,
        assemblyFeeMinor: row.assemblyFeeMinor,
        discountMinor: row.discountMinor,
        deliveryFeeMinor: row.deliveryFeeMinor,
        roundingAdjustmentMinor: row.roundingMinor,
        totalMinor: row.totalMinor,
      },
      totalUsdCents: row.totalUsdCents,
      usdRate: row.usdRate,
      canCancel: customerCanCancel(row.status),
      history: row.history.map((h) => ({ status: h.to, at: h.createdAt })),
      // The deadline matters only while the payment is still owed.
      ...(row.paymentDueAt &&
      row.status === 'NEW' &&
      (row.paymentStatus === 'PENDING' || row.paymentStatus === 'FAILED')
        ? { paymentDueAt: row.paymentDueAt }
        : {}),
      ...(row.paymentStatus === 'FAILED' && row.paymentNote
        ? { paymentNote: row.paymentNote }
        : {}),
    };
  }
}

function phoneOf(input: string, field: string): string {
  const phone = normalizePhone(input);
  if (!phone) throw new AppError('PHONE_INVALID', { extra: { field } });
  return phone;
}
