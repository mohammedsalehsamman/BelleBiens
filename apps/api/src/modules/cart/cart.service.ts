import { Injectable } from '@nestjs/common';
import { Clock } from '../../common/clock/clock.js';
import { AppError } from '../../common/errors/app-error.js';
import type { Coupon, Prisma } from '../../generated/prisma/client.js';
import { PrismaService } from '../../infra/prisma/prisma.service.js';
import { CARD_INCLUDE, text, toCard } from '../catalog/catalog.mapper.js';
import {
  availability,
  earliestReadyAt,
  shopDate,
} from '../catalog/domain/product-rules.js';
import type { ProductCardDto } from '../catalog/dto/catalog.dto.js';
import { DesignerService, type Stocked } from '../designer/designer.service.js';
import {
  type Coupon as PriceCoupon,
  type PriceLine,
  priceQuote,
} from '../pricing/price-quote.js';
import { SettingsService } from '../settings/settings.service.js';
import { CouponAttemptLimiter } from './coupon-limiter.js';
import { checkBoxSchema, type Compartment, filled } from './domain/box.js';
import type {
  BoxCatalogDto,
  CartDto,
  CartLineInputDto,
  CartQuoteDto,
  CartQuoteRequestDto,
  CouponResultDto,
  LineIssueDto,
  QuotedLineDto,
} from './dto/cart.dto.js';

const PRODUCT_INCLUDE = {
  category: { select: { slug: true } },
  images: { select: { url: true }, orderBy: { sortOrder: 'asc' }, take: 1 },
  optionGroups: {
    orderBy: { sortOrder: 'asc' },
    include: { options: { orderBy: { sortOrder: 'asc' } } },
  },
} as const satisfies Prisma.ProductInclude;

type ProductRow = Prisma.ProductGetPayload<{ include: typeof PRODUCT_INCLUDE }>;

/** A priced line plus what the price pipeline needs. */
interface Priced {
  dto: QuotedLineDto;
  line: PriceLine;
}

const join = (parts: string[]) => parts.filter((p) => p !== '').join(' · ');

/** Which designer item types each box compartment kind takes. */
const COMPARTMENT_TYPES: Record<Compartment['kind'], string[]> = {
  FLOWER: ['FLOWER', 'FILLER'],
  SWEET: ['SWEET'],
  EXTRA: ['EXTRA'],
};

@Injectable()
export class CartService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
    private readonly settings: SettingsService,
    private readonly designer: DesignerService,
    private readonly limiter: CouponAttemptLimiter,
  ) {}

  // ---------- products ----------

  private priceProduct(
    input: CartLineInputDto,
    row: ProductRow | undefined,
    today: Date,
  ): Priced {
    const choice = input.product;
    if (!choice) {
      throw new AppError('VALIDATION_FAILED', {
        detail: `line ${input.id}: product missing`,
      });
    }
    if (!row) {
      return {
        dto: {
          id: input.id,
          kind: 'product',
          title: text(choice.slug, choice.slug),
          summary: text('', ''),
          imageUrl: null,
          unitPriceMinor: 0,
          qty: input.qty,
          totalMinor: 0,
          leadTimeHours: 0,
          issues: [{ code: 'PRODUCT_UNAVAILABLE' }],
        },
        line: { kind: 'product', qty: input.qty, unitPriceMinor: 0 },
      };
    }

    const issues: LineIssueDto[] = [];
    if (!availability(row, today).available)
      issues.push({ code: 'PRODUCT_UNAVAILABLE' });
    if (
      row.stockQuantity !== null &&
      input.qty > row.stockQuantity &&
      row.stockQuantity > 0
    ) {
      issues.push({
        code: 'STOCK_INSUFFICIENT',
        requested: input.qty,
        available: row.stockQuantity,
      });
    }

    // Each group: the customer's choice, else the default (FR-CRT-01).
    const chosen = new Map<string, string[]>();
    for (const c of choice.options) {
      chosen.set(c.group, [...(chosen.get(c.group) ?? []), c.option]);
    }
    const known = new Set(row.optionGroups.map((g) => g.key));
    if ([...chosen.keys()].some((g) => !known.has(g))) {
      issues.push({ code: 'OPTION_UNAVAILABLE' });
    }
    const picked: {
      nameAr: string;
      nameEn: string;
      priceChangeMinor: number;
    }[] = [];
    for (const group of row.optionGroups) {
      const wanted = chosen.get(group.key) ?? [];
      const found = group.options.filter((o) => wanted.includes(o.key));
      if (found.length < wanted.length)
        issues.push({ code: 'OPTION_UNAVAILABLE' });
      if (group.selection === 'SINGLE') {
        const option = found[0] ?? group.options.find((o) => o.isDefault);
        if (option) picked.push(option);
      } else {
        picked.push(...found);
      }
    }

    const inscription = choice.inscription?.trim();
    if (inscription) {
      const max = row.inscriptionMaxLength;
      if (max === null || characters(inscription) > max) {
        issues.push({ code: 'INSCRIPTION_NOT_ALLOWED' });
      }
    }

    const unit =
      row.basePriceMinor + picked.reduce((s, o) => s + o.priceChangeMinor, 0);
    const summaryAr = join([
      ...picked.map((o) => o.nameAr),
      inscription ? 'رسالة على الكيك' : '',
      choice.referenceImageUrl && row.allowsReferenceImage
        ? 'صورة للتصميم'
        : '',
    ]);
    const summaryEn = join([
      ...picked.map((o) => o.nameEn),
      inscription ? 'Message on the cake' : '',
      choice.referenceImageUrl && row.allowsReferenceImage
        ? 'Design photo'
        : '',
    ]);
    return {
      dto: {
        id: input.id,
        kind: 'product',
        title: text(row.nameAr, row.nameEn),
        summary: text(summaryAr, summaryEn),
        imageUrl: row.images[0]?.url ?? null,
        unitPriceMinor: unit,
        qty: input.qty,
        totalMinor: unit * input.qty,
        leadTimeHours: row.leadTimeHours,
        issues: dedupe(issues),
      },
      line: {
        kind: 'product',
        qty: input.qty,
        unitPriceMinor: row.basePriceMinor,
        options: picked.map((o) => ({ priceChangeMinor: o.priceChangeMinor })),
      },
    };
  }

  // ---------- designed bouquets ----------

  private async priceDesign(input: CartLineInputDto): Promise<Priced> {
    if (!input.spec) {
      throw new AppError('VALIDATION_FAILED', {
        detail: `line ${input.id}: spec missing`,
      });
    }
    const quote = await this.designer.quote(input.spec);
    const issues: LineIssueDto[] = quote.issues.map((i) => ({
      code: i.code,
      itemId: i.itemId,
      requested: i.requested,
      available: i.available,
    }));
    const summary = (lang: 'ar' | 'en') =>
      join(
        quote.lines.map((l) =>
          l.type === 'WRAP' || l.type === 'RIBBON' || l.qty === 1
            ? l.name[lang]
            : `${l.name[lang]} ${l.qty}`,
        ),
      );
    return {
      dto: {
        id: input.id,
        kind: 'design',
        title: text('باقتك المصمّمة', 'Your designed bouquet'),
        summary: text(summary('ar'), summary('en')),
        imageUrl: input.previewUrl ?? null,
        unitPriceMinor: quote.itemsMinor,
        qty: input.qty,
        totalMinor: quote.itemsMinor * input.qty,
        leadTimeHours: 0,
        issues,
      },
      line: {
        kind: 'design',
        qty: input.qty,
        unitPriceMinor: 0,
        components: quote.lines.map((l) => ({
          unitPriceMinor: l.unitPriceMinor,
          qty: l.qty,
        })),
      },
    };
  }

  // ---------- split boxes ----------

  private async priceBox(
    input: CartLineInputDto,
    stocked: Stocked[],
  ): Promise<Priced> {
    const checked = checkBoxSchema(input.spec);
    if (!checked.ok) {
      throw new AppError('SPEC_INVALID', {
        extra: { problems: checked.problems },
      });
    }
    const spec = checked.spec;
    const type = await this.prisma.boxType.findFirst({
      where: { slug: spec.boxType, status: 'ACTIVE' },
    });
    if (!type)
      throw new AppError('SPEC_INVALID', {
        detail: `unknown box ${spec.boxType}`,
      });
    const compartments = type.compartments as unknown as Compartment[];
    const bySlug = new Map(stocked.map((s) => [s.item.slug, s]));

    const issues: LineIssueDto[] = [];
    const components: { unitPriceMinor: number; qty: number }[] = [];
    const parts: { ar: string; en: string }[] = [];
    for (const part of spec.compartments) {
      const compartment = compartments.find((c) => c.index === part.index);
      if (!compartment) {
        issues.push({ code: 'BOX_COMPARTMENT_INVALID' });
        continue;
      }
      if (filled(part.items) > compartment.capacity) {
        issues.push({
          code: 'BOX_OVER_CAPACITY',
          requested: filled(part.items),
          available: compartment.capacity,
        });
      }
      for (const line of part.items) {
        const found = bySlug.get(line.id);
        if (
          !found ||
          !COMPARTMENT_TYPES[compartment.kind].includes(found.item.type)
        ) {
          if (found)
            issues.push({ code: 'BOX_COMPARTMENT_INVALID', itemId: line.id });
          else
            issues.push({
              code: 'ITEM_UNAVAILABLE',
              itemId: line.id,
              available: 0,
            });
          continue;
        }
        components.push({
          unitPriceMinor: found.item.unitPriceMinor,
          qty: line.qty,
        });
        parts.push({
          ar: `${found.item.nameAr} × ${line.qty}`,
          en: `${found.item.nameEn} × ${line.qty}`,
        });
        if (found.available !== null && line.qty > found.available) {
          issues.push({
            code:
              found.available === 0 ? 'ITEM_UNAVAILABLE' : 'STOCK_INSUFFICIENT',
            itemId: line.id,
            requested: line.qty,
            available: found.available,
          });
        }
      }
    }
    const unit =
      type.basePriceMinor +
      components.reduce((s, c) => s + c.unitPriceMinor * c.qty, 0);
    return {
      dto: {
        id: input.id,
        kind: 'box',
        title: text(type.nameAr, type.nameEn),
        summary: text(
          join(parts.map((p) => p.ar)),
          join(parts.map((p) => p.en)),
        ),
        imageUrl: input.previewUrl ?? null,
        unitPriceMinor: unit,
        qty: input.qty,
        totalMinor: unit * input.qty,
        // FR-BOX-04: the longest lead time of what is inside; box items are ready today.
        leadTimeHours: 0,
        issues: dedupe(issues),
      },
      line: {
        kind: 'product',
        qty: input.qty,
        unitPriceMinor: type.basePriceMinor,
        components,
      },
    };
  }

  // ---------- coupons ----------

  private async checkCoupon(
    code: string,
    subtotal: number,
    client: string,
  ): Promise<{ result: CouponResultDto; coupon: PriceCoupon | null }> {
    if (this.limiter.blocked(client)) {
      throw new AppError('RATE_LIMITED', {
        extra: { retryAfterSeconds: this.limiter.retryAfterSeconds(client) },
      });
    }
    const normalized = code.trim().toUpperCase();
    const row = await this.prisma.coupon.findUnique({
      where: { code: normalized },
    });
    const now = this.clock.now();
    const problem = ((c: Coupon | null) => {
      if (!c || !c.active) return 'NOT_FOUND' as const;
      if ((c.startsAt && now < c.startsAt) || (c.endsAt && now > c.endsAt)) {
        return 'EXPIRED' as const;
      }
      if (c.maxRedemptions !== null && c.redemptions >= c.maxRedemptions) {
        return 'USED_UP' as const;
      }
      if (subtotal < c.minOrderMinor) return 'MIN_ORDER' as const;
      return null;
    })(row);
    // Only guesses count against the limit, not a cart below the minimum.
    if (problem === 'NOT_FOUND' || problem === 'EXPIRED')
      this.limiter.fail(client);
    const result: CouponResultDto = {
      code: normalized,
      applied: problem === null,
      ...(problem === null ? {} : { problem }),
      minOrderMinor: row?.minOrderMinor ?? 0,
    };
    if (problem !== null || !row) return { result, coupon: null };
    return {
      result,
      coupon:
        row.type === 'PERCENT'
          ? {
              type: 'percent',
              value: row.value,
              minOrderMinor: row.minOrderMinor,
            }
          : {
              type: 'fixed',
              valueMinor: row.value,
              minOrderMinor: row.minOrderMinor,
            },
    };
  }

  // ---------- the quote ----------

  /**
   * FR-CRT-05..08: prices every line from the database with the shared
   * pipeline, applies the coupon before delivery, and gives the earliest time
   * the whole cart can be ready. Nothing here trusts a price from the app.
   */
  async quote(dto: CartQuoteRequestDto, client: string): Promise<CartQuoteDto> {
    const now = this.clock.now();
    const today = shopDate(now);
    const ids = dto.lines.map((l) => l.id);
    if (new Set(ids).size !== ids.length) {
      throw new AppError('VALIDATION_FAILED', {
        detail: 'line ids must be unique',
      });
    }

    const slugs = dto.lines.flatMap((l) =>
      l.kind === 'product' && l.product ? [l.product.slug] : [],
    );
    const [products, stocked, usdRate, assemblyFeeMinor, rounding, hours] =
      await Promise.all([
        this.prisma.product.findMany({
          where: { slug: { in: slugs }, status: 'ACTIVE' },
          include: PRODUCT_INCLUDE,
        }),
        dto.lines.some((l) => l.kind === 'box')
          ? this.designer.stocked()
          : Promise.resolve([]),
        this.settings.get('currency.usdRate'),
        this.settings.get('pricing.assemblyFeeMinor'),
        this.settings.get('pricing.rounding'),
        this.settings.get('shop.workingHours'),
      ]);
    const bySlug = new Map(products.map((p) => [p.slug, p]));

    const priced: Priced[] = [];
    for (const line of dto.lines) {
      if (line.kind === 'product') {
        priced.push(
          this.priceProduct(line, bySlug.get(line.product?.slug ?? ''), today),
        );
      } else if (line.kind === 'design') {
        priced.push(await this.priceDesign(line));
      } else {
        priced.push(await this.priceBox(line, stocked));
      }
    }

    const settings = { assemblyFeeMinor, rounding, usdRate };
    const subtotal =
      priced.reduce((s, p) => s + p.dto.totalMinor, 0) +
      assemblyFeeMinor *
        priced
          .filter((p) => p.line.kind === 'design')
          .reduce((s, p) => s + p.line.qty, 0);
    const coupon = dto.couponCode
      ? await this.checkCoupon(dto.couponCode, subtotal, client)
      : null;
    const input = {
      lines: priced.map((p) => p.line),
      settings,
      coupon: coupon?.coupon ?? null,
      // FR-DLV-02: the zone fee is added at checkout (S5).
      deliveryFeeMinor: 0,
    };
    const syp = priceQuote({ ...input, displayCurrency: 'SYP' });
    const usd = priceQuote({ ...input, displayCurrency: 'USD' });

    const leadTimeHours = Math.max(
      0,
      ...priced.map((p) => p.dto.leadTimeHours),
    );
    const earliest = earliestReadyAt(now, leadTimeHours, hours);
    const todayLocal = this.clock.nowInShopZone().startOf('day');

    return {
      lines: priced.map((p) => p.dto),
      syp: breakdown(syp),
      usd: breakdown(usd),
      usdRate,
      ...(coupon ? { coupon: coupon.result } : {}),
      leadTimeHours,
      earliestAt: earliest.toISO() ?? '',
      earliestInDays: Math.round(
        earliest.startOf('day').diff(todayLocal, 'days').days,
      ),
      orderable:
        priced.length > 0 && priced.every((p) => p.dto.issues.length === 0),
      suggestions: await this.suggestions(products, today),
    };
  }

  /** "قد يعجبك أيضاً": what goes with the cart's products, else popular gifts and sweets. */
  private async suggestions(
    inCart: ProductRow[],
    today: Date,
  ): Promise<ProductCardDto[]> {
    const taken = new Set(inCart.map((p) => p.slug));
    const paired = [...new Set(inCart.flatMap((p) => p.pairings))].filter(
      (s) => !taken.has(s),
    );
    const rows = await this.prisma.product.findMany({
      where: {
        status: 'ACTIVE',
        slug: { notIn: [...taken] },
        OR: [{ slug: { in: paired } }, { kind: { in: ['SWEET', 'GIFT'] } }],
      },
      include: CARD_INCLUDE,
      orderBy: [{ popularity: 'desc' }, { slug: 'asc' }],
      take: 20,
    });
    return rows
      .map((r) => toCard(r, today))
      .filter((c) => c.available)
      .sort(
        (a, b) =>
          Number(paired.includes(b.slug)) - Number(paired.includes(a.slug)),
      )
      .slice(0, 4);
  }

  // ---------- saved carts (FR-CRT-03) ----------

  async savedCart(userId: string): Promise<CartDto> {
    const row = await this.prisma.cart.findUnique({ where: { userId } });
    return {
      lines: (row?.lines as unknown as CartLineInputDto[] | undefined) ?? [],
      updatedAt: row?.updatedAt ?? null,
    };
  }

  async saveCart(userId: string, lines: CartLineInputDto[]): Promise<CartDto> {
    const ids = lines.map((l) => l.id);
    if (new Set(ids).size !== ids.length) {
      throw new AppError('VALIDATION_FAILED', {
        detail: 'line ids must be unique',
      });
    }
    const json = lines as unknown as Prisma.InputJsonValue;
    const row = await this.prisma.cart.upsert({
      where: { userId },
      update: { lines: json },
      create: { userId, lines: json },
    });
    return { lines, updatedAt: row.updatedAt };
  }

  // ---------- box builder (screen 19) ----------

  async boxCatalog(): Promise<BoxCatalogDto> {
    const [types, stocked] = await Promise.all([
      this.prisma.boxType.findMany({
        where: { status: 'ACTIVE' },
        orderBy: { sortOrder: 'asc' },
      }),
      this.designer.stocked(),
    ]);
    const usable = stocked.filter(
      (s) =>
        s.item.status === 'ACTIVE' &&
        ['FLOWER', 'FILLER', 'SWEET', 'EXTRA'].includes(s.item.type),
    );
    const cheapest = (types: string[]) =>
      Math.min(
        ...usable
          .filter((s) => types.includes(s.item.type) && s.available !== 0)
          .map((s) => s.item.unitPriceMinor),
        Number.MAX_SAFE_INTEGER,
      );
    return {
      types: types.map((t) => {
        const compartments = t.compartments as unknown as Compartment[];
        // "From" price: three quarters of the flowers and a full sweets part,
        // each at the cheapest item (screen 19: 1,350 + 9 x 90 + 6 x 60).
        const fill = compartments.reduce((sum, c) => {
          if (c.kind === 'EXTRA') return sum;
          const count =
            c.kind === 'FLOWER' ? Math.floor((c.capacity * 3) / 4) : c.capacity;
          // Main flowers only: a box of gypsophila is not the "from" box.
          const price = cheapest(
            c.kind === 'FLOWER' ? ['FLOWER'] : COMPARTMENT_TYPES[c.kind],
          );
          return price === Number.MAX_SAFE_INTEGER ? sum : sum + count * price;
        }, 0);
        return {
          id: t.slug,
          name: text(t.nameAr, t.nameEn),
          detail: text(t.detailAr, t.detailEn),
          basePriceMinor: t.basePriceMinor,
          fromPriceMinor: t.basePriceMinor + fill,
          compartments: compartments.map((c) => ({
            index: c.index,
            kind: c.kind,
            name: text(c.nameAr, c.nameEn),
            capacity: c.capacity,
          })),
        };
      }),
      items: usable.map((s) => this.designer.toItemDto(s)),
    };
  }
}

function breakdown(q: ReturnType<typeof priceQuote>) {
  return {
    itemsMinor: q.itemsMinor,
    assemblyFeeMinor: q.assemblyFeeMinor,
    discountMinor: q.discountMinor,
    deliveryFeeMinor: q.deliveryFeeMinor,
    roundingAdjustmentMinor: q.roundingAdjustmentMinor,
    totalMinor: q.totalMinor,
  };
}

function dedupe(issues: LineIssueDto[]): LineIssueDto[] {
  const seen = new Set<string>();
  return issues.filter((i) => {
    const key = `${i.code}:${i.itemId ?? ''}`;
    if (seen.has(key)) return false;
    seen.add(key);
    return true;
  });
}

/** Characters as a person counts them (an emoji is one). */
function characters(text: string): number {
  let count = 0;
  for (const _ of new Intl.Segmenter().segment(text)) count += 1;
  return count;
}
