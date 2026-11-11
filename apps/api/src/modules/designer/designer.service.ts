import { Injectable } from '@nestjs/common';
import { Clock } from '../../common/clock/clock.js';
import { SLOT_LAYOUTS } from '../../common/contracts/contracts.js';
import { AppError } from '../../common/errors/app-error.js';
import type {
  DesignerItem,
  DesignerItemType,
} from '../../generated/prisma/client.js';
import { PrismaService } from '../../infra/prisma/prisma.service.js';
import type { AuthUser } from '../accounts/auth/auth.decorators.js';
import { AuditService } from '../audit/audit.service.js';
import { text } from '../catalog/catalog.mapper.js';
import { shopDate } from '../catalog/domain/product-rules.js';
import { priceQuote, sypToUsdCents } from '../pricing/price-quote.js';
import { SettingsService } from '../settings/settings.service.js';
import {
  type BouquetSpec,
  checkSpecSchema,
  type SpecLine,
  specHash,
  stemCount,
} from './domain/spec.js';
import type {
  AlternativeDto,
  DesignerCatalogDto,
  DesignerItemDto,
  DesignerQuoteDto,
  DesignerSizeDto,
  PaletteDto,
  QuoteIssueDto,
  QuoteLineDto,
  SizeLimitsDto,
} from './dto/designer.dto.js';

/** FR-DSG-05: optional palettes; they highlight flowers in these colors. */
export const PALETTES: PaletteDto[] = [
  {
    key: 'pastel',
    name: text('باستيل', 'Pastel'),
    colors: ['pastel', 'pink', 'white'],
  },
  {
    key: 'romantic_red',
    name: text('أحمر رومانسي', 'Romantic red'),
    colors: ['red', 'pink'],
  },
  {
    key: 'luxury_white',
    name: text('أبيض فاخر', 'Luxury white'),
    colors: ['white'],
  },
  { key: 'mixed', name: text('مكس', 'Mixed'), colors: [] },
];

/** Which item types each part of the spec accepts. */
const SLOTS: Record<
  'flowers' | 'greens' | 'extras' | 'wrap' | 'ribbon',
  DesignerItemType[]
> = {
  flowers: ['FLOWER', 'FILLER'],
  greens: ['GREEN'],
  extras: ['EXTRA'],
  wrap: ['WRAP'],
  ribbon: ['RIBBON'],
};

type Part = keyof typeof SLOTS;

/** Types that come from today's list rather than a stock count (FR-DLY-01). */
const DAILY_TYPES: DesignerItemType[] = ['FLOWER', 'FILLER', 'GREEN'];

interface Stocked {
  item: DesignerItem;
  /** null: no limit. */
  available: number | null;
  limited: boolean;
}

@Injectable()
export class DesignerService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
    private readonly settings: SettingsService,
    private readonly audit: AuditService,
  ) {}

  /** MM-DD inside an inclusive window that may wrap past the new year (FR-INV-06). */
  private inSeason(item: DesignerItem): boolean {
    if (!item.seasonFrom || !item.seasonTo) return true;
    const today = this.clock.nowInShopZone().toFormat('MM-dd');
    return item.seasonFrom <= item.seasonTo
      ? today >= item.seasonFrom && today <= item.seasonTo
      : today >= item.seasonFrom || today <= item.seasonTo;
  }

  /** Every item with how many can be used today. */
  private async stocked(
    where: { slug?: { in: string[] } } = {},
  ): Promise<Stocked[]> {
    const today = shopDate(this.clock.now());
    const items = await this.prisma.designerItem.findMany({
      where,
      include: { daily: { where: { date: today } } },
      orderBy: [{ type: 'asc' }, { sortOrder: 'asc' }],
    });
    return items.map(({ daily, ...item }) => {
      const usable = item.status === 'ACTIVE' && this.inSeason(item);
      if (!usable) return { item, available: 0, limited: false };
      if (DAILY_TYPES.includes(item.type)) {
        return {
          item,
          available: daily[0]?.quantity ?? 0,
          limited: daily[0]?.limited ?? false,
        };
      }
      return { item, available: item.stockQuantity, limited: false };
    });
  }

  private toItemDto(s: Stocked): DesignerItemDto {
    return {
      id: s.item.slug,
      type: s.item.type,
      name: text(s.item.nameAr, s.item.nameEn),
      detail: text(s.item.detailAr, s.item.detailEn),
      unitPriceMinor: s.item.unitPriceMinor,
      swatch: s.item.swatch,
      colorTags: s.item.colorTags,
      cutoutUrl: s.item.cutoutUrl,
      available: s.available,
      limited: s.limited,
    };
  }

  private async sizes(): Promise<DesignerSizeDto[]> {
    const rows = await this.prisma.designerSize.findMany({
      orderBy: { sortOrder: 'asc' },
    });
    return rows.map((r) => ({
      key: r.key as DesignerSizeDto['key'],
      name: text(r.nameAr, r.nameEn),
      minStems: r.minStems,
      maxStems: r.maxStems,
    }));
  }

  /** Screens 15-17 in one call: sizes, palettes, occasions, items with today's stock, slots. */
  async catalog(): Promise<DesignerCatalogDto> {
    const [sizes, occasions, items] = await Promise.all([
      this.sizes(),
      this.prisma.occasion.findMany({ orderBy: { sortOrder: 'asc' } }),
      this.stocked(),
    ]);
    return {
      date: this.clock.nowInShopZone().toISODate() ?? '',
      sizes,
      palettes: PALETTES,
      occasions: [
        ...occasions.map((o) => ({
          slug: o.slug,
          name: text(o.nameAr, o.nameEn),
        })),
        { slug: 'none', name: text('بدون مناسبة', 'No occasion') },
      ],
      // Hidden items stay out; out-of-stock ones show as "not available today".
      items: items
        .filter((s) => s.item.status === 'ACTIVE')
        .map((s) => this.toItemDto(s)),
      layouts: {
        version: SLOT_LAYOUTS.version,
        width: SLOT_LAYOUTS.canvas.width,
        height: SLOT_LAYOUTS.canvas.height,
        sizes: sizes
          .map((s) => SLOT_LAYOUTS.layouts[s.key])
          .filter((l) => l !== undefined)
          .map((l) => ({ ...l, size: l.size as DesignerSizeDto['key'] })),
      },
    };
  }

  /**
   * FR-DSG-03/04/08: checks a spec and prices it from the server's data. Shape
   * problems are errors (422 SPEC_INVALID, NFR-SEC-07); stock and stem limits
   * come back as issues with substitutes, so the customer can fix them (screen 37).
   */
  async quote(raw: unknown): Promise<DesignerQuoteDto> {
    const checked = checkSpecSchema(raw);
    if (!checked.ok) {
      throw new AppError('SPEC_INVALID', {
        extra: { problems: checked.problems },
      });
    }
    const spec = checked.spec;
    const parts: [Part, SpecLine[]][] = [
      ['flowers', spec.flowers],
      ['greens', spec.greens ?? []],
      ['wrap', [{ id: spec.wrap, qty: 1 }]],
      ['ribbon', [{ id: spec.ribbon, qty: 1 }]],
      ['extras', spec.extras ?? []],
    ];
    for (const [part, lines] of parts) {
      const ids = lines.map((l) => l.id);
      if (new Set(ids).size !== ids.length) {
        throw new AppError('SPEC_INVALID', {
          detail: `${part} lists an item twice`,
        });
      }
    }

    const [sizes, occasion, stocked, usdRate, assemblyFeeMinor] =
      await Promise.all([
        this.sizes(),
        spec.occasion === 'none'
          ? Promise.resolve({ slug: 'none' })
          : this.prisma.occasion.findUnique({ where: { slug: spec.occasion } }),
        this.stocked(),
        this.settings.get('currency.usdRate'),
        this.settings.get('pricing.assemblyFeeMinor'),
      ]);
    if (!occasion) {
      throw new AppError('SPEC_INVALID', {
        detail: `unknown occasion ${spec.occasion}`,
      });
    }
    const size = sizes.find((s) => s.key === spec.size);
    if (!size)
      throw new AppError('SPEC_INVALID', {
        detail: `unknown size ${spec.size}`,
      });

    const bySlug = new Map(stocked.map((s) => [s.item.slug, s]));
    const lines: QuoteLineDto[] = [];
    const issues: QuoteIssueDto[] = [];

    for (const [part, partLines] of parts) {
      for (const line of partLines) {
        const found = bySlug.get(line.id);
        if (found && !SLOTS[part].includes(found.item.type)) {
          throw new AppError('SPEC_INVALID', {
            detail: `${line.id} is a ${found.item.type}, not allowed in ${part}`,
          });
        }
        if (!found || found.item.status !== 'ACTIVE') {
          // Gone from the shop since the draft was saved: offer substitutes.
          issues.push({
            code: 'ITEM_UNAVAILABLE',
            itemId: line.id,
            requested: line.qty,
            available: 0,
            alternatives: this.alternatives(
              stocked,
              SLOTS[part],
              line.qty,
              found?.item,
            ),
          });
          continue;
        }
        const { item, available } = found;
        lines.push({
          id: item.slug,
          type: item.type,
          name: text(item.nameAr, item.nameEn),
          qty: line.qty,
          unitPriceMinor: item.unitPriceMinor,
          totalMinor: item.unitPriceMinor * line.qty,
        });
        if (available !== null && line.qty > available) {
          issues.push({
            code: available === 0 ? 'ITEM_UNAVAILABLE' : 'STOCK_INSUFFICIENT',
            itemId: item.slug,
            requested: line.qty,
            available,
            alternatives: this.alternatives(
              stocked,
              [item.type],
              line.qty,
              item,
            ),
          });
        }
      }
    }

    const stems = stemCount(spec);
    if (stems < size.minStems || stems > size.maxStems) {
      issues.push({
        code: 'STEMS_OUT_OF_RANGE',
        requested: stems,
        min: size.minStems,
        max: size.maxStems,
      });
    }

    const price = priceQuote({
      lines: [{ kind: 'design', qty: 1, unitPriceMinor: 0, components: lines }],
      settings: { assemblyFeeMinor, rounding: { mode: 'none' }, usdRate },
      coupon: null,
      deliveryFeeMinor: 0,
      displayCurrency: 'SYP',
    });
    return {
      specHash: specHash(spec),
      stems,
      size,
      lines,
      itemsMinor: price.itemsMinor,
      assemblyFeeMinor: price.assemblyFeeMinor,
      totalMinor: price.totalMinor,
      totalUsdCents: sypToUsdCents(price.totalMinor, usdRate),
      usdRate,
      issues,
      orderable: issues.length === 0,
    };
  }

  /**
   * Up to three substitutes of the same kind that are in stock: same color
   * first, then those with enough for the whole request, then the closest price.
   */
  private alternatives(
    stocked: Stocked[],
    types: DesignerItemType[],
    qty: number,
    missing: DesignerItem | undefined,
  ): AlternativeDto[] {
    const colors = new Set(missing?.colorTags ?? []);
    const price = missing?.unitPriceMinor ?? 0;
    return stocked
      .filter(
        (s) =>
          s.item.status === 'ACTIVE' &&
          s.item.slug !== missing?.slug &&
          types.includes(s.item.type) &&
          (s.available === null || s.available > 0),
      )
      .map((s) => ({
        s,
        sameColor: s.item.colorTags.some((c) => colors.has(c)),
        enough: s.available === null || s.available >= qty,
      }))
      .sort(
        (a, b) =>
          Number(b.sameColor) - Number(a.sameColor) ||
          Number(b.enough) - Number(a.enough) ||
          Math.abs(a.s.item.unitPriceMinor - price) -
            Math.abs(b.s.item.unitPriceMinor - price) ||
          a.s.item.sortOrder - b.s.item.sortOrder,
      )
      .slice(0, 3)
      .map(({ s, sameColor }) => ({
        id: s.item.slug,
        name: text(s.item.nameAr, s.item.nameEn),
        available: s.available,
        unitPriceMinor: s.item.unitPriceMinor,
        sameColor,
      }));
  }

  /** FR-DSG-04: the shop sets the stem limits of each size. */
  async setSizeLimits(
    actor: AuthUser,
    dto: SizeLimitsDto,
  ): Promise<DesignerSizeDto[]> {
    for (const s of dto.sizes) {
      if (s.minStems > s.maxStems) {
        throw new AppError('VALIDATION_FAILED', {
          detail: `${s.key}: min is above max`,
        });
      }
    }
    const before = await this.sizes();
    await this.prisma.$transaction(async (tx) => {
      for (const s of dto.sizes) {
        await tx.designerSize.update({
          where: { key: s.key },
          data: { minStems: s.minStems, maxStems: s.maxStems },
        });
      }
      await this.audit.record(
        {
          actor,
          action: 'designer.sizes.update',
          entity: 'designer_size',
          before: before.map((s) => ({
            key: s.key,
            min: s.minStems,
            max: s.maxStems,
          })),
          after: dto.sizes.map((s) => ({
            key: s.key,
            min: s.minStems,
            max: s.maxStems,
          })),
        },
        tx,
      );
    });
    return this.sizes();
  }

  /** Spec shape for other modules (cart, orders): the same checks as the quote. */
  parse(raw: unknown): BouquetSpec {
    const checked = checkSpecSchema(raw);
    if (!checked.ok) {
      throw new AppError('SPEC_INVALID', {
        extra: { problems: checked.problems },
      });
    }
    return checked.spec;
  }
}
