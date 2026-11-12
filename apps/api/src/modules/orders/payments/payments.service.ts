import { Injectable, Logger } from '@nestjs/common';
import { MediaStorage } from '../../../adapters/storage/media-storage.js';
import { Clock } from '../../../common/clock/clock.js';
import { AppError } from '../../../common/errors/app-error.js';
import type {
  Order,
  PaymentStatus,
  Prisma,
} from '../../../generated/prisma/client.js';
import { PrismaService } from '../../../infra/prisma/prisma.service.js';
import type { AuthUser } from '../../accounts/auth/auth.decorators.js';
import { AuditService } from '../../audit/audit.service.js';
import type { AdminOrderDto, OrderDto } from '../dto/order.dto.js';
import { OrdersService } from '../orders.service.js';
import { PaymentProviders } from './payment-providers.js';

/** Payments still owed: these expire at their deadline (FR-PAY-10). */
const OWED: PaymentStatus[] = ['PENDING', 'FAILED'];

/**
 * Sham Cash proof, the shop's check, refunds and unpaid expiry (FR-PAY-03,
 * 09, 10, 11). Every step is a payment event on the order.
 */
@Injectable()
export class PaymentsService {
  private readonly logger = new Logger(PaymentsService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
    private readonly orders: OrdersService,
    private readonly providers: PaymentProviders,
    private readonly audit: AuditService,
    private readonly media: MediaStorage,
  ) {}

  private event(
    tx: Prisma.TransactionClient,
    order: Order,
    data: {
      kind: string;
      status: PaymentStatus;
      reference?: string | null;
      receiptUrl?: string | null;
      note?: string;
      byUserId?: string | null;
      method?: Order['paymentMethod'];
    },
  ) {
    return tx.paymentEvent.create({
      data: {
        orderId: order.id,
        kind: data.kind,
        method: data.method ?? order.paymentMethod,
        status: data.status,
        amountMinor: order.totalMinor,
        reference: data.reference ?? null,
        receiptUrl: data.receiptUrl ?? null,
        note: data.note ?? '',
        byUserId: data.byUserId ?? null,
        createdAt: this.clock.now(),
      },
    });
  }

  /** The owner's order, locked, or NOT_FOUND for anyone else. */
  private async ownOrder(
    tx: Prisma.TransactionClient,
    number: string,
    user: AuthUser | undefined,
    phone: string | undefined,
  ): Promise<Order> {
    const order = await this.orders.lock(tx, number);
    if (!this.orders.isOwner(order, user, phone)) {
      throw new AppError('NOT_FOUND', { detail: number });
    }
    return order;
  }

  private assertOwed(order: Order): void {
    if (order.status !== 'NEW' || !OWED.includes(order.paymentStatus)) {
      throw new AppError('PAYMENT_NOT_EXPECTED');
    }
  }

  // ---------- the customer ----------

  /** Screen 24 "أرسلت الدفعة": a transaction number, a receipt, or both. */
  async submitProof(
    number: string,
    proof: { reference?: string; receiptUrl?: string },
    user: AuthUser | undefined,
    phone: string | undefined,
  ): Promise<OrderDto> {
    const reference = proof.reference?.trim() || null;
    const receiptUrl =
      proof.receiptUrl && this.media.owns(proof.receiptUrl)
        ? proof.receiptUrl
        : null;
    if (!reference && !receiptUrl) {
      throw new AppError('VALIDATION_FAILED', {
        detail: 'a transaction number or a receipt image',
      });
    }
    await this.prisma.$transaction(async (tx) => {
      const order = await this.ownOrder(tx, number, user, phone);
      this.assertOwed(order);
      if (!this.providers.get(order.paymentMethod)?.takesProof) {
        throw new AppError('PAYMENT_NOT_EXPECTED');
      }
      await tx.order.update({
        where: { id: order.id },
        data: { paymentStatus: 'SUBMITTED', paymentNote: '' },
      });
      await this.event(tx, order, {
        kind: 'submitted',
        status: 'SUBMITTED',
        reference,
        receiptUrl,
        byUserId: user?.id,
      });
    });
    return this.orders.toDto(await this.orders.find(number));
  }

  /** Screen 38 "الدفع عند الاستلام بدلاً من ذلك". */
  async switchToCash(
    number: string,
    user: AuthUser | undefined,
    phone: string | undefined,
  ): Promise<OrderDto> {
    await this.prisma.$transaction(async (tx) => {
      const order = await this.ownOrder(tx, number, user, phone);
      this.assertOwed(order);
      if (order.paymentMethod === 'CASH') return;
      await tx.order.update({
        where: { id: order.id },
        data: {
          paymentMethod: 'CASH',
          paymentStatus: 'PENDING',
          paymentDueAt: null,
          paymentNote: '',
        },
      });
      await this.event(tx, order, {
        kind: 'method.changed',
        method: 'CASH',
        status: 'PENDING',
        byUserId: user?.id,
      });
    });
    return this.orders.toDto(await this.orders.find(number));
  }

  // ---------- the shop ----------

  /**
   * FR-PAY-03: the shop found the money. A placed order is confirmed with
   * it (screen 27 "تأكيد الطلب · بعد التحقق من الدفع").
   */
  async confirm(number: string, actor: AuthUser): Promise<AdminOrderDto> {
    const before = await this.prisma.$transaction(async (tx) => {
      const order = await this.orders.lock(tx, number);
      if (
        order.paymentMethod === 'CASH' ||
        !['PENDING', 'SUBMITTED', 'FAILED'].includes(order.paymentStatus) ||
        order.status === 'CANCELLED'
      ) {
        throw new AppError('PAYMENT_NOT_EXPECTED');
      }
      await tx.order.update({
        where: { id: order.id },
        data: { paymentStatus: 'PAID', paymentNote: '' },
      });
      await this.event(tx, order, {
        kind: 'confirmed',
        status: 'PAID',
        byUserId: actor.id,
      });
      await this.audit.record(
        {
          actor,
          action: 'order.payment.confirm',
          entity: 'order',
          entityId: order.id,
          before: { paymentStatus: order.paymentStatus },
          after: { paymentStatus: 'PAID' },
        },
        tx,
      );
      if (order.status === 'NEW') {
        await this.orders.transitionInTx(
          tx,
          order,
          'CONFIRMED',
          actor,
          'payment confirmed',
          'staff',
        );
      }
      return order;
    });
    await this.orders.statusNotice(
      await this.orders.find(number),
      before.status,
    );
    return this.orders.forStaff(number, actor.role);
  }

  /** Screen 38: the shop could not match it; the customer may try again. */
  async reject(
    number: string,
    actor: AuthUser,
    note: string,
  ): Promise<AdminOrderDto> {
    await this.prisma.$transaction(async (tx) => {
      const order = await this.orders.lock(tx, number);
      if (order.paymentStatus !== 'SUBMITTED' || order.status !== 'NEW') {
        throw new AppError('PAYMENT_NOT_EXPECTED');
      }
      await tx.order.update({
        where: { id: order.id },
        data: { paymentStatus: 'FAILED', paymentNote: note.trim() },
      });
      await this.event(tx, order, {
        kind: 'rejected',
        status: 'FAILED',
        note: note.trim(),
        byUserId: actor.id,
      });
      await this.audit.record(
        {
          actor,
          action: 'order.payment.reject',
          entity: 'order',
          entityId: order.id,
          after: { note: note.trim() },
        },
        tx,
      );
    });
    return this.orders.forStaff(number, actor.role);
  }

  /** FR-PAY-11: money given back, with the reason, kept on the order. */
  async refund(
    number: string,
    actor: AuthUser,
    note: string,
  ): Promise<AdminOrderDto> {
    await this.prisma.$transaction(async (tx) => {
      const order = await this.orders.lock(tx, number);
      if (order.paymentStatus !== 'PAID') {
        throw new AppError('PAYMENT_NOT_EXPECTED');
      }
      await tx.order.update({
        where: { id: order.id },
        data: { paymentStatus: 'REFUNDED' },
      });
      await this.event(tx, order, {
        kind: 'refunded',
        status: 'REFUNDED',
        note: note.trim(),
        byUserId: actor.id,
      });
      await this.audit.record(
        {
          actor,
          action: 'order.payment.refund',
          entity: 'order',
          entityId: order.id,
          before: { paymentStatus: 'PAID' },
          after: { paymentStatus: 'REFUNDED', note: note.trim() },
        },
        tx,
      );
    });
    return this.orders.forStaff(number, actor.role);
  }

  // ---------- the job ----------

  /**
   * FR-PAY-10: online payments not made by their deadline cancel the order
   * and give back its stock. A receipt waiting for the shop is not touched:
   * the customer paid, the shop owes them an answer.
   */
  async expireUnpaid(): Promise<string[]> {
    const due = await this.prisma.order.findMany({
      where: {
        status: 'NEW',
        paymentStatus: { in: OWED },
        paymentDueAt: { lte: this.clock.now() },
      },
      select: { number: true },
      orderBy: { paymentDueAt: 'asc' },
      take: 100,
    });
    const cancelled: string[] = [];
    for (const { number } of due) {
      try {
        const from = await this.prisma.$transaction(async (tx) => {
          const order = await this.orders.lock(tx, number);
          // Paid or confirmed meanwhile: nothing to do.
          if (
            order.status !== 'NEW' ||
            !OWED.includes(order.paymentStatus) ||
            !order.paymentDueAt ||
            order.paymentDueAt > this.clock.now()
          ) {
            return null;
          }
          await this.event(tx, order, { kind: 'expired', status: 'FAILED' });
          await tx.order.update({
            where: { id: order.id },
            data: { paymentStatus: 'FAILED' },
          });
          await this.orders.transitionInTx(
            tx,
            order,
            'CANCELLED',
            null,
            'not paid in time',
            'system',
          );
          return order.status;
        });
        if (from) {
          cancelled.push(number);
          await this.orders.statusNotice(await this.orders.find(number), from);
        }
      } catch (error) {
        this.logger.error(`expiring ${number} failed: ${String(error)}`);
      }
    }
    return cancelled;
  }
}
