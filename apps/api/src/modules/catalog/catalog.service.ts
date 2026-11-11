import { Injectable } from '@nestjs/common';
import { DateTime } from 'luxon';
import { Clock, SHOP_TIME_ZONE } from '../../common/clock/clock.js';
import { AppError } from '../../common/errors/app-error.js';
import {
  normalizeArabic,
  searchTokens,
} from '../../common/text/arabic-normalize.js';
import type { Prisma } from '../../generated/prisma/client.js';
import { PrismaService } from '../../infra/prisma/prisma.service.js';
import { SettingsService } from '../settings/settings.service.js';
import {
  CARD_INCLUDE,
  type CardRow,
  text,
  toCard,
  toOptionGroups,
} from './catalog.mapper.js';
import {
  earliestDeliveryDate,
  isOpenNow,
  shopDate,
} from './domain/product-rules.js';
import { COLORS, FLOWER_TYPES } from './domain/vocabulary.js';
import type {
  BranchDto,
  CatalogFiltersDto,
  CategoryDto,
  DailyFlowersDto,
  HomeDto,
  OccasionDto,
  OccasionPageDto,
  PageDto,
  ProductCardDto,
  ProductDetailDto,
  ProductPageDto,
  ProductQueryDto,
  SearchQueryDto,
  SearchResultDto,
  ShopStatusDto,
} from './dto/catalog.dto.js';

const ORDER_BY: Record<
  NonNullable<ProductQueryDto['sort']>,
  Prisma.ProductOrderByWithRelationInput[]
> = {
  popular: [{ popularity: 'desc' }, { slug: 'asc' }],
  newest: [{ createdAt: 'desc' }, { slug: 'asc' }],
  price_asc: [{ displayPriceMinor: 'asc' }, { slug: 'asc' }],
  price_desc: [{ displayPriceMinor: 'desc' }, { slug: 'asc' }],
};

/** Customers never see hidden products. */
const VISIBLE: Prisma.ProductWhereInput = { status: 'ACTIVE' };

const SEARCH_LIMIT = 50;

@Injectable()
export class CatalogService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
    private readonly settings: SettingsService,
  ) {}

  private today(): Date {
    return shopDate(this.clock.now());
  }

  /** Orderable today: in stock, and on today's list when it is a "today only" product. */
  private availableWhere(today: Date): Prisma.ProductWhereInput {
    return {
      AND: [
        { OR: [{ stockQuantity: null }, { stockQuantity: { gt: 0 } }] },
        { OR: [{ dailyOnly: false }, { dailyDate: today }] },
      ],
    };
  }

  /** Largest lead time that still makes delivery before closing today. */
  private async maxLeadHoursToday(): Promise<number> {
    const hours = await this.settings.get('shop.workingHours');
    const now = this.clock.nowInShopZone();
    const [h, m] = hours.close.split(':').map(Number);
    const closeMinutes = (h ?? 0) * 60 + (m ?? 0);
    const left = closeMinutes - (now.hour * 60 + now.minute);
    return left <= 0 ? -1 : Math.ceil(left / 60) - 1;
  }

  private searchWhere(q: string | undefined): Prisma.ProductWhereInput {
    const tokens = searchTokens(q ?? '');
    return tokens.length === 0
      ? {}
      : { AND: tokens.map((t) => ({ searchText: { contains: t } })) };
  }

  async listProducts(query: ProductQueryDto): Promise<ProductPageDto> {
    const today = this.today();
    const and: Prisma.ProductWhereInput[] = [
      VISIBLE,
      this.searchWhere(query.q),
    ];
    if (query.category) and.push({ category: { slug: query.category } });
    if (query.occasion) and.push({ occasions: { has: query.occasion } });
    if (query.colors?.length) and.push({ colors: { hasSome: query.colors } });
    if (query.flowerTypes?.length) {
      and.push({ flowerTypes: { hasSome: query.flowerTypes } });
    }
    if (query.minPrice !== undefined || query.maxPrice !== undefined) {
      and.push({
        displayPriceMinor: { gte: query.minPrice, lte: query.maxPrice },
      });
    }
    if (query.availableToday || query.deliverableToday) {
      and.push(this.availableWhere(today));
    }
    if (query.deliverableToday) {
      and.push({ leadTimeHours: { lte: await this.maxLeadHoursToday() } });
    }

    const where = { AND: and };
    const page = query.page ?? 1;
    const pageSize = query.pageSize ?? 20;
    const [total, rows] = await Promise.all([
      this.prisma.product.count({ where }),
      pageSize === 0
        ? Promise.resolve([])
        : this.prisma.product.findMany({
            where,
            include: CARD_INCLUDE,
            orderBy: ORDER_BY[query.sort ?? 'popular'],
            skip: (page - 1) * pageSize,
            take: pageSize,
          }),
    ]);
    return {
      items: rows.map((r) => toCard(r, today)),
      total,
      page,
      pageSize,
    };
  }

  /**
   * FR-CAT-04: every word must match, after Arabic normalization. Names that start
   * with the query come first, then names that contain it, then other matches
   * (tags, category), each by popularity.
   */
  async search(query: SearchQueryDto): Promise<SearchResultDto> {
    const today = this.today();
    const normalized = normalizeArabic(query.q);
    if (normalized === '') {
      return { query: query.q, total: 0, facets: [], items: [] };
    }
    const rows = await this.prisma.product.findMany({
      where: { AND: [VISIBLE, this.searchWhere(query.q)] },
      include: {
        ...CARD_INCLUDE,
        category: {
          select: { slug: true, nameAr: true, nameEn: true, sortOrder: true },
        },
      },
      orderBy: ORDER_BY.popular,
      take: 500,
    });

    const rank = (r: CardRow) => {
      const names = [normalizeArabic(r.nameAr), normalizeArabic(r.nameEn)];
      if (names.some((n) => n.startsWith(normalized))) return 0;
      if (names.some((n) => n.includes(normalized))) return 1;
      return 2;
    };
    const sorted = rows
      .map((r, i) => ({ r, i, rank: rank(r) }))
      .sort((a, b) => a.rank - b.rank || a.i - b.i)
      .map((x) => x.r);

    const facets = new Map<
      string,
      { name: { ar: string; en: string }; count: number; order: number }
    >();
    for (const r of rows) {
      const f = facets.get(r.category.slug) ?? {
        name: text(r.category.nameAr, r.category.nameEn),
        count: 0,
        order: r.category.sortOrder,
      };
      f.count += 1;
      facets.set(r.category.slug, f);
    }

    return {
      query: query.q,
      total: rows.length,
      facets: [...facets.entries()]
        .sort((a, b) => a[1].order - b[1].order)
        .map(([categorySlug, f]) => ({
          categorySlug,
          name: f.name,
          count: f.count,
        })),
      items: sorted
        .filter((r) => !query.category || r.category.slug === query.category)
        .slice(0, SEARCH_LIMIT)
        .map((r) => toCard(r, today)),
    };
  }

  async product(slug: string, userId?: string): Promise<ProductDetailDto> {
    const row = await this.prisma.product.findFirst({
      where: { slug, ...VISIBLE },
      include: {
        category: true,
        images: { orderBy: { sortOrder: 'asc' } },
        optionGroups: {
          orderBy: { sortOrder: 'asc' },
          include: { options: { orderBy: { sortOrder: 'asc' } } },
        },
      },
    });
    if (!row) throw new AppError('NOT_FOUND', { detail: `product ${slug}` });

    const today = this.today();
    const [pairings, favorite, hours] = await Promise.all([
      row.pairings.length === 0
        ? Promise.resolve([])
        : this.prisma.product.findMany({
            where: { slug: { in: row.pairings }, ...VISIBLE },
            include: CARD_INCLUDE,
          }),
      userId
        ? this.prisma.favorite.findUnique({
            where: { userId_productId: { userId, productId: row.id } },
          })
        : Promise.resolve(null),
      this.settings.get('shop.workingHours'),
    ]);

    const earliest = DateTime.fromISO(
      earliestDeliveryDate(this.clock.now(), row.leadTimeHours, hours),
      { zone: SHOP_TIME_ZONE },
    );
    const todayLocal = this.clock.nowInShopZone().startOf('day');

    return Object.assign(toCard(row, today), {
      category: {
        slug: row.category.slug,
        name: text(row.category.nameAr, row.category.nameEn),
      },
      description: text(row.descriptionAr, row.descriptionEn),
      images: row.images.map((i) => ({
        url: i.url,
        alt: text(i.altAr, i.altEn),
      })),
      optionGroups: toOptionGroups(row.optionGroups),
      allergens: row.allergens,
      occasions: row.occasions,
      colors: row.colors,
      flowerTypes: row.flowerTypes,
      customizable: row.designerTemplate !== null,
      earliestDeliveryInDays: Math.max(
        0,
        Math.round(earliest.diff(todayLocal, 'days').days),
      ),
      // Keep the shop's order of suggestions.
      pairings: row.pairings
        .map((s) => pairings.find((p) => p.slug === s))
        .filter((p): p is (typeof pairings)[number] => p !== undefined)
        .map((p) => toCard(p, today)),
      isFavorite: favorite !== null,
    });
  }

  async categories(): Promise<CategoryDto[]> {
    const rows = await this.prisma.category.findMany({
      orderBy: { sortOrder: 'asc' },
      include: { _count: { select: { products: { where: VISIBLE } } } },
    });
    return rows.map((c) => ({
      slug: c.slug,
      name: text(c.nameAr, c.nameEn),
      icon: c.icon,
      productCount: c._count.products,
    }));
  }

  async occasions(): Promise<OccasionDto[]> {
    const rows = await this.prisma.occasion.findMany({
      orderBy: { sortOrder: 'asc' },
    });
    return rows.map((o) => ({
      slug: o.slug,
      name: text(o.nameAr, o.nameEn),
      title: text(o.titleAr, o.titleEn),
      heroImage: o.heroImage,
    }));
  }

  async occasion(slug: string): Promise<OccasionPageDto> {
    const occasion = await this.prisma.occasion.findUnique({ where: { slug } });
    if (!occasion)
      throw new AppError('NOT_FOUND', { detail: `occasion ${slug}` });
    const today = this.today();
    const rows = await this.prisma.product.findMany({
      where: { ...VISIBLE, occasions: { has: slug } },
      include: CARD_INCLUDE,
      orderBy: ORDER_BY.popular,
      take: 100,
    });
    return {
      occasion: {
        slug: occasion.slug,
        name: text(occasion.nameAr, occasion.nameEn),
        title: text(occasion.titleAr, occasion.titleEn),
        heroImage: occasion.heroImage,
      },
      products: rows.map((r) => toCard(r, today)),
    };
  }

  async filters(): Promise<CatalogFiltersDto> {
    const [occasions, price] = await Promise.all([
      this.occasions(),
      this.prisma.product.aggregate({
        where: VISIBLE,
        _min: { displayPriceMinor: true },
        _max: { displayPriceMinor: true },
      }),
    ]);
    return {
      occasions: occasions.map((o) => ({
        slug: o.slug,
        name: o.name,
        swatch: null,
      })),
      colors: COLORS.map((c) => ({
        slug: c.slug,
        name: text(c.ar, c.en),
        swatch: c.swatch ?? null,
      })),
      flowerTypes: FLOWER_TYPES.map((f) => ({
        slug: f.slug,
        name: text(f.ar, f.en),
        swatch: null,
      })),
      price: {
        minMinor: price._min.displayPriceMinor ?? 0,
        maxMinor: price._max.displayPriceMinor ?? 0,
      },
    };
  }

  /** FR-DLY-01..05: today's products and stems. Yesterday's rows simply stop matching. */
  async dailyFlowers(): Promise<DailyFlowersDto> {
    const today = this.today();
    const [products, stems] = await Promise.all([
      this.prisma.product.findMany({
        where: { ...VISIBLE, dailyDate: today },
        include: CARD_INCLUDE,
        orderBy: ORDER_BY.popular,
      }),
      this.prisma.dailyAvailability.findMany({
        where: { date: today, quantity: { gt: 0 }, item: { status: 'ACTIVE' } },
        include: { item: true },
        orderBy: { item: { sortOrder: 'asc' } },
      }),
    ]);
    const local = this.clock.nowInShopZone();
    return {
      date: local.toISODate() ?? '',
      expiresAt: local.plus({ days: 1 }).startOf('day').toISO() ?? '',
      products: products.map((r) => toCard(r, today)),
      stems: stems.map((s) => ({
        slug: s.item.slug,
        type: s.item.type,
        name: text(s.item.nameAr, s.item.nameEn),
        quantity: s.quantity,
        limited: s.limited,
        swatch: s.item.swatch,
        unitPriceMinor: s.item.unitPriceMinor,
      })),
    };
  }

  async shopStatus(): Promise<ShopStatusDto> {
    const [mode, hours] = await Promise.all([
      this.settings.get('shop.mode'),
      this.settings.get('shop.workingHours'),
    ]);
    return {
      mode,
      openNow: isOpenNow(this.clock.now(), mode, hours),
      opensAt: hours.open,
      closesAt: hours.close,
    };
  }

  async branch(): Promise<BranchDto> {
    const [branch, pages, status, whatsapp] = await Promise.all([
      this.prisma.branch.findFirst({ orderBy: { createdAt: 'asc' } }),
      this.prisma.page.findMany({ orderBy: { slug: 'asc' } }),
      this.shopStatus(),
      this.settings.get('shop.whatsapp'),
    ]);
    if (!branch) throw new AppError('NOT_FOUND', { detail: 'branch' });
    return {
      code: branch.code,
      name: text(branch.nameAr, branch.nameEn),
      address: text(branch.addressAr, branch.addressEn),
      phone: branch.phone,
      whatsapp: branch.whatsapp ?? whatsapp,
      instagram: branch.instagram,
      latitude: branch.latitude,
      longitude: branch.longitude,
      partners: branch.partners,
      status,
      pages: PAGE_ORDER.flatMap((slug) => {
        const p = pages.find((x) => x.slug === slug);
        return p ? [{ slug: p.slug, title: text(p.titleAr, p.titleEn) }] : [];
      }).concat(
        pages
          .filter((p) => !PAGE_ORDER.includes(p.slug))
          .map((p) => ({ slug: p.slug, title: text(p.titleAr, p.titleEn) })),
      ),
    };
  }

  async page(slug: string): Promise<PageDto> {
    const page = await this.prisma.page.findUnique({ where: { slug } });
    if (!page) throw new AppError('NOT_FOUND', { detail: `page ${slug}` });
    return {
      slug: page.slug,
      title: text(page.titleAr, page.titleEn),
      body: text(page.bodyAr, page.bodyEn),
      updatedAt: page.updatedAt,
    };
  }

  /** Screen 06 in one call, so the home screen opens fast on a slow network. */
  async home(): Promise<HomeDto> {
    const today = this.today();
    const cards = (
      where: Prisma.ProductWhereInput,
    ): Promise<ProductCardDto[]> =>
      this.prisma.product
        .findMany({
          where: { AND: [VISIBLE, this.availableWhere(today), where] },
          include: CARD_INCLUDE,
          orderBy: ORDER_BY.popular,
          take: 6,
        })
        .then((rows) => rows.map((r) => toCard(r, today)));

    const [categories, todayCards, cakes, branch] = await Promise.all([
      this.categories(),
      cards({ dailyDate: today }),
      cards({ category: { slug: 'cakes' } }),
      this.branch(),
    ]);
    return { categories, today: todayCards, cakes, branch };
  }

  async favorites(userId: string): Promise<ProductCardDto[]> {
    const today = this.today();
    const rows = await this.prisma.favorite.findMany({
      where: { userId, product: VISIBLE },
      include: { product: { include: CARD_INCLUDE } },
      orderBy: { createdAt: 'desc' },
    });
    return rows.map((f) => toCard(f.product, today));
  }

  async addFavorite(userId: string, slug: string): Promise<void> {
    const product = await this.prisma.product.findFirst({
      where: { slug, ...VISIBLE },
      select: { id: true },
    });
    if (!product)
      throw new AppError('NOT_FOUND', { detail: `product ${slug}` });
    await this.prisma.favorite.upsert({
      where: { userId_productId: { userId, productId: product.id } },
      update: {},
      create: { userId, productId: product.id, createdAt: this.clock.now() },
    });
  }

  async removeFavorite(userId: string, slug: string): Promise<void> {
    await this.prisma.favorite.deleteMany({
      where: { userId, product: { slug } },
    });
  }
}

/** Screen 34 lists the policies in this order. */
const PAGE_ORDER = ['delivery', 'cancellation', 'privacy', 'terms'];
