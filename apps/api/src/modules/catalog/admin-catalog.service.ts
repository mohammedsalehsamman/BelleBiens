import { Injectable } from '@nestjs/common';
import { Clock } from '../../common/clock/clock.js';
import { AppError } from '../../common/errors/app-error.js';
import { Prisma } from '../../generated/prisma/client.js';
import { PrismaService } from '../../infra/prisma/prisma.service.js';
import type { AuthUser } from '../accounts/auth/auth.decorators.js';
import { AuditService } from '../audit/audit.service.js';
import {
  buildSearchText,
  displayPrice,
  shopDate,
} from './domain/product-rules.js';
import { COLORS, FLOWER_TYPES } from './domain/vocabulary.js';
import type {
  AdminDesignerItemDto,
  AdminProductDto,
  CreateProductDto,
  DailyStemsInputDto,
  DesignerItemInputDto,
  OptionGroupInputDto,
  StockAdjustmentDto,
  StockMovementDto,
  TodayListDto,
  UpdateDesignerItemDto,
  UpdateProductDto,
} from './dto/admin-catalog.dto.js';

const FULL_PRODUCT = {
  category: true,
  images: { orderBy: { sortOrder: 'asc' } },
  optionGroups: {
    orderBy: { sortOrder: 'asc' },
    include: { options: { orderBy: { sortOrder: 'asc' } } },
  },
} as const satisfies Prisma.ProductInclude;

type FullProduct = Prisma.ProductGetPayload<{ include: typeof FULL_PRODUCT }>;

/** The fields worth comparing in the audit log (FR-ADM-09: prices and stock). */
function auditView(p: FullProduct) {
  return {
    slug: p.slug,
    status: p.status,
    basePriceMinor: p.basePriceMinor,
    displayPriceMinor: p.displayPriceMinor,
    stockQuantity: p.stockQuantity,
    options: p.optionGroups.flatMap((g) =>
      g.options.map((o) => `${g.key}.${o.key}:${o.priceChangeMinor}`),
    ),
  };
}

function checkGroups(groups: OptionGroupInputDto[]): void {
  const keys = new Set<string>();
  for (const g of groups) {
    if (keys.has(g.key)) {
      throw new AppError('VALIDATION_FAILED', {
        detail: `duplicate group ${g.key}`,
      });
    }
    keys.add(g.key);
    const optionKeys = new Set(g.options.map((o) => o.key));
    if (optionKeys.size !== g.options.length) {
      throw new AppError('VALIDATION_FAILED', {
        detail: `duplicate option in ${g.key}`,
      });
    }
    const defaults = g.options.filter((o) => o.isDefault).length;
    if ((g.selection ?? 'SINGLE') === 'SINGLE' && defaults > 1) {
      throw new AppError('VALIDATION_FAILED', {
        detail: `group ${g.key} has more than one default`,
      });
    }
  }
}

/** FR-ADM-02/03/04, FR-DLY-01/02, FR-INV-05. Every write leaves an audit entry. */
@Injectable()
export class AdminCatalogService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
    private readonly audit: AuditService,
  ) {}

  private today(): Date {
    return shopDate(this.clock.now());
  }

  private toAdmin(p: FullProduct): AdminProductDto {
    return {
      id: p.id,
      slug: p.slug,
      categorySlug: p.category.slug,
      kind: p.kind,
      nameAr: p.nameAr,
      nameEn: p.nameEn,
      subtitleAr: p.subtitleAr,
      subtitleEn: p.subtitleEn,
      descriptionAr: p.descriptionAr,
      descriptionEn: p.descriptionEn,
      basePriceMinor: p.basePriceMinor,
      displayPriceMinor: p.displayPriceMinor,
      priceFrom: p.priceFrom,
      leadTimeHours: p.leadTimeHours,
      allergens: p.allergens,
      occasions: p.occasions,
      colors: p.colors,
      flowerTypes: p.flowerTypes,
      stockQuantity: p.stockQuantity,
      status: p.status,
      dailyDate: p.dailyDate?.toISOString().slice(0, 10) ?? null,
      dailyOnly: p.dailyOnly,
      limited: p.limited,
      seasonal: p.seasonal,
      bestSeller: p.bestSeller,
      popularity: p.popularity,
      pairings: p.pairings,
      designerTemplate:
        (p.designerTemplate as Record<string, unknown> | null) ?? null,
      images: p.images.map((i) => ({
        url: i.url,
        altAr: i.altAr,
        altEn: i.altEn,
      })),
      optionGroups: p.optionGroups.map((g) => ({
        key: g.key,
        nameAr: g.nameAr,
        nameEn: g.nameEn,
        selection: g.selection,
        required: g.required,
        options: g.options.map((o) => ({
          key: o.key,
          nameAr: o.nameAr,
          nameEn: o.nameEn,
          detailAr: o.detailAr,
          detailEn: o.detailEn,
          swatch: o.swatch ?? undefined,
          priceChangeMinor: o.priceChangeMinor,
          isDefault: o.isDefault,
        })),
      })),
      updatedAt: p.updatedAt,
    };
  }

  async listProducts(): Promise<AdminProductDto[]> {
    const rows = await this.prisma.product.findMany({
      include: FULL_PRODUCT,
      orderBy: [{ category: { sortOrder: 'asc' } }, { popularity: 'desc' }],
    });
    return rows.map((r) => this.toAdmin(r));
  }

  private async categoryId(slug: string): Promise<string> {
    const category = await this.prisma.category.findUnique({ where: { slug } });
    if (!category) {
      throw new AppError('VALIDATION_FAILED', {
        detail: `unknown category ${slug}`,
      });
    }
    return category.id;
  }

  private async checkOccasions(slugs: string[] | undefined): Promise<void> {
    if (!slugs?.length) return;
    const found = await this.prisma.occasion.count({
      where: { slug: { in: slugs } },
    });
    if (found !== new Set(slugs).size) {
      throw new AppError('VALIDATION_FAILED', { detail: 'unknown occasion' });
    }
  }

  /** Recomputes the shown price and the search text after any write. */
  private async refreshDerived(
    tx: Prisma.TransactionClient,
    id: string,
  ): Promise<FullProduct> {
    const p = await tx.product.findUniqueOrThrow({
      where: { id },
      include: FULL_PRODUCT,
    });
    const occasions = await tx.occasion.findMany({
      where: { slug: { in: p.occasions } },
    });
    const names = (
      list: readonly { slug: string; ar: string; en: string }[],
      slugs: string[],
    ) =>
      list.filter((v) => slugs.includes(v.slug)).flatMap((v) => [v.ar, v.en]);
    const derived = displayPrice(p.basePriceMinor, p.optionGroups);
    return tx.product.update({
      where: { id },
      data: {
        ...derived,
        searchText: buildSearchText([
          p.nameAr,
          p.nameEn,
          p.subtitleAr,
          p.subtitleEn,
          p.category.nameAr,
          p.category.nameEn,
          ...occasions.flatMap((o) => [o.nameAr, o.nameEn]),
          ...names(COLORS, p.colors),
          ...names(FLOWER_TYPES, p.flowerTypes),
        ]),
      },
      include: FULL_PRODUCT,
    });
  }

  private async writeChildren(
    tx: Prisma.TransactionClient,
    productId: string,
    dto: UpdateProductDto,
  ): Promise<void> {
    if (dto.optionGroups) {
      await tx.productOptionGroup.deleteMany({ where: { productId } });
      for (const [gi, g] of dto.optionGroups.entries()) {
        await tx.productOptionGroup.create({
          data: {
            productId,
            key: g.key,
            nameAr: g.nameAr,
            nameEn: g.nameEn,
            selection: g.selection ?? 'SINGLE',
            required: g.required ?? true,
            sortOrder: gi,
            options: {
              create: g.options.map((o, oi) => ({
                key: o.key,
                nameAr: o.nameAr,
                nameEn: o.nameEn,
                detailAr: o.detailAr ?? '',
                detailEn: o.detailEn ?? '',
                swatch: o.swatch,
                priceChangeMinor: o.priceChangeMinor ?? 0,
                isDefault: o.isDefault ?? false,
                sortOrder: oi,
              })),
            },
          },
        });
      }
    }
    if (dto.images) {
      await tx.productImage.deleteMany({ where: { productId } });
      await tx.productImage.createMany({
        data: dto.images.map((i, sortOrder) => ({
          productId,
          url: i.url,
          altAr: i.altAr ?? '',
          altEn: i.altEn ?? '',
          sortOrder,
        })),
      });
    }
  }

  private scalarData(dto: UpdateProductDto) {
    const {
      categorySlug: _c,
      images: _i,
      optionGroups: _o,
      designerTemplate,
      ...rest
    } = dto;
    return {
      ...rest,
      ...(designerTemplate === undefined
        ? {}
        : {
            designerTemplate:
              designerTemplate === null
                ? Prisma.DbNull
                : (designerTemplate as Prisma.InputJsonValue),
          }),
    };
  }

  async createProduct(
    actor: AuthUser,
    dto: CreateProductDto,
  ): Promise<AdminProductDto> {
    checkGroups(dto.optionGroups ?? []);
    await this.checkOccasions(dto.occasions);
    const categoryId = await this.categoryId(dto.categorySlug);
    const exists = await this.prisma.product.findUnique({
      where: { slug: dto.slug },
    });
    if (exists)
      throw new AppError('CONFLICT', { detail: `slug ${dto.slug} is taken` });

    const created = await this.prisma.$transaction(async (tx) => {
      const product = await tx.product.create({
        data: {
          ...this.scalarData(dto),
          slug: dto.slug,
          kind: dto.kind,
          nameAr: dto.nameAr,
          nameEn: dto.nameEn,
          basePriceMinor: dto.basePriceMinor,
          categoryId,
        },
      });
      await this.writeChildren(tx, product.id, dto);
      const full = await this.refreshDerived(tx, product.id);
      await this.audit.record(
        {
          actor,
          action: 'product.create',
          entity: 'product',
          entityId: product.id,
          after: auditView(full),
        },
        tx,
      );
      return full;
    });
    return this.toAdmin(created);
  }

  async updateProduct(
    actor: AuthUser,
    id: string,
    dto: UpdateProductDto,
  ): Promise<AdminProductDto> {
    const before = await this.prisma.product.findUnique({
      where: { id },
      include: FULL_PRODUCT,
    });
    if (!before) throw new AppError('NOT_FOUND', { detail: `product ${id}` });
    if (dto.optionGroups) checkGroups(dto.optionGroups);
    await this.checkOccasions(dto.occasions);
    if (dto.slug && dto.slug !== before.slug) {
      const taken = await this.prisma.product.findUnique({
        where: { slug: dto.slug },
      });
      if (taken)
        throw new AppError('CONFLICT', { detail: `slug ${dto.slug} is taken` });
    }
    const categoryId = dto.categorySlug
      ? await this.categoryId(dto.categorySlug)
      : undefined;

    const updated = await this.prisma.$transaction(async (tx) => {
      await tx.product.update({
        where: { id },
        data: {
          ...this.scalarData(dto),
          ...(categoryId ? { categoryId } : {}),
        },
      });
      await this.writeChildren(tx, id, dto);
      const full = await this.refreshDerived(tx, id);
      // FR-INV-05: a count typed in the form is a stock change too.
      if (
        dto.stockQuantity !== undefined &&
        before.stockQuantity !== full.stockQuantity &&
        full.stockQuantity !== null
      ) {
        await tx.stockMovement.create({
          data: {
            productId: id,
            delta: full.stockQuantity - (before.stockQuantity ?? 0),
            quantityAfter: full.stockQuantity,
            reason: 'Set in the product form',
            userId: actor.id,
            createdAt: this.clock.now(),
          },
        });
      }
      await this.audit.record(
        {
          actor,
          action: 'product.update',
          entity: 'product',
          entityId: id,
          before: auditView(before),
          after: auditView(full),
        },
        tx,
      );
      return full;
    });
    return this.toAdmin(updated);
  }

  /** FR-DLY-02: the products on today's list. Tomorrow they drop off by themselves. */
  async setTodayList(
    actor: AuthUser,
    dto: TodayListDto,
  ): Promise<AdminProductDto[]> {
    const today = this.today();
    const slugs = [...new Set(dto.productSlugs)];
    const found = await this.prisma.product.findMany({
      where: { slug: { in: slugs } },
    });
    if (found.length !== slugs.length) {
      throw new AppError('VALIDATION_FAILED', {
        detail: 'unknown product in list',
      });
    }
    await this.prisma.$transaction(async (tx) => {
      await tx.product.updateMany({
        where: { dailyDate: today, slug: { notIn: slugs } },
        data: { dailyDate: null },
      });
      await tx.product.updateMany({
        where: { slug: { in: slugs } },
        data: { dailyDate: today },
      });
      await this.audit.record(
        {
          actor,
          action: 'daily.products.set',
          entity: 'daily_list',
          entityId: today.toISOString().slice(0, 10),
          after: { productSlugs: slugs },
        },
        tx,
      );
    });
    const rows = await this.prisma.product.findMany({
      where: { dailyDate: today },
      include: FULL_PRODUCT,
      orderBy: { popularity: 'desc' },
    });
    return rows.map((r) => this.toAdmin(r));
  }

  async listDesignerItems(): Promise<AdminDesignerItemDto[]> {
    const today = this.today();
    const rows = await this.prisma.designerItem.findMany({
      orderBy: [{ type: 'asc' }, { sortOrder: 'asc' }],
      include: { daily: { where: { date: today } } },
    });
    return rows.map((d) => ({
      id: d.id,
      slug: d.slug,
      type: d.type,
      nameAr: d.nameAr,
      nameEn: d.nameEn,
      unitPriceMinor: d.unitPriceMinor,
      swatch: d.swatch ?? undefined,
      colorTags: d.colorTags,
      occasionTags: d.occasionTags,
      cutoutUrl: d.cutoutUrl ?? undefined,
      stockQuantity: d.stockQuantity,
      seasonFrom: d.seasonFrom ?? undefined,
      seasonTo: d.seasonTo ?? undefined,
      status: d.status,
      sortOrder: d.sortOrder,
      todayQuantity: d.daily[0]?.quantity ?? null,
    }));
  }

  async createDesignerItem(
    actor: AuthUser,
    dto: DesignerItemInputDto,
  ): Promise<void> {
    const exists = await this.prisma.designerItem.findUnique({
      where: { slug: dto.slug },
    });
    if (exists)
      throw new AppError('CONFLICT', { detail: `slug ${dto.slug} is taken` });
    await this.prisma.$transaction(async (tx) => {
      const item = await tx.designerItem.create({ data: dto });
      await this.audit.record(
        {
          actor,
          action: 'designer_item.create',
          entity: 'designer_item',
          entityId: item.id,
          after: {
            slug: item.slug,
            unitPriceMinor: item.unitPriceMinor,
            stockQuantity: item.stockQuantity,
          },
        },
        tx,
      );
    });
  }

  async updateDesignerItem(
    actor: AuthUser,
    id: string,
    dto: UpdateDesignerItemDto,
  ): Promise<void> {
    const before = await this.prisma.designerItem.findUnique({ where: { id } });
    if (!before)
      throw new AppError('NOT_FOUND', { detail: `designer item ${id}` });
    await this.prisma.$transaction(async (tx) => {
      const after = await tx.designerItem.update({ where: { id }, data: dto });
      await this.audit.record(
        {
          actor,
          action: 'designer_item.update',
          entity: 'designer_item',
          entityId: id,
          before: {
            unitPriceMinor: before.unitPriceMinor,
            stockQuantity: before.stockQuantity,
            status: before.status,
          },
          after: {
            unitPriceMinor: after.unitPriceMinor,
            stockQuantity: after.stockQuantity,
            status: after.status,
          },
        },
        tx,
      );
    });
  }

  /** FR-DLY-01: stems available today. A quantity of 0 takes an item off the list. */
  async setDailyStems(actor: AuthUser, dto: DailyStemsInputDto): Promise<void> {
    const today = this.today();
    const slugs = dto.items.map((i) => i.slug);
    if (new Set(slugs).size !== slugs.length) {
      throw new AppError('VALIDATION_FAILED', {
        detail: 'an item is listed twice',
      });
    }
    const items = await this.prisma.designerItem.findMany({
      where: { slug: { in: slugs } },
    });
    if (items.length !== slugs.length) {
      throw new AppError('VALIDATION_FAILED', {
        detail: 'unknown designer item',
      });
    }
    const idOf = new Map(items.map((i) => [i.slug, i.id]));
    await this.prisma.$transaction(async (tx) => {
      for (const entry of dto.items) {
        const designerItemId = idOf.get(entry.slug)!;
        await tx.dailyAvailability.upsert({
          where: { designerItemId_date: { designerItemId, date: today } },
          update: {
            quantity: entry.quantity,
            limited: entry.limited ?? false,
            updatedBy: actor.id,
          },
          create: {
            designerItemId,
            date: today,
            quantity: entry.quantity,
            limited: entry.limited ?? false,
            updatedBy: actor.id,
          },
        });
      }
      await this.audit.record(
        {
          actor,
          action: 'daily.stems.set',
          entity: 'daily_availability',
          entityId: today.toISOString().slice(0, 10),
          after: dto.items.map((i) => ({ slug: i.slug, quantity: i.quantity })),
        },
        tx,
      );
    });
  }

  /**
   * FR-INV-05: one atomic change of a stock count. The count can never go below
   * zero, even when two staff adjust the same item at once.
   */
  async adjustStock(
    actor: AuthUser,
    dto: StockAdjustmentDto,
  ): Promise<StockMovementDto> {
    if (dto.delta === 0)
      throw new AppError('VALIDATION_FAILED', { detail: 'delta is 0' });
    return this.prisma.$transaction(async (tx) => {
      const rows =
        dto.target === 'product'
          ? await tx.$queryRaw<{ id: string; stock_quantity: number }[]>`
              UPDATE product SET stock_quantity = stock_quantity + ${dto.delta}, updated_at = now()
              WHERE slug = ${dto.slug} AND stock_quantity IS NOT NULL
                AND stock_quantity + ${dto.delta} >= 0
              RETURNING id, stock_quantity`
          : await tx.$queryRaw<{ id: string; stock_quantity: number }[]>`
              UPDATE designer_item SET stock_quantity = stock_quantity + ${dto.delta}, updated_at = now()
              WHERE slug = ${dto.slug} AND stock_quantity IS NOT NULL
                AND stock_quantity + ${dto.delta} >= 0
              RETURNING id, stock_quantity`;
      const row = rows[0];
      if (!row) {
        const current =
          dto.target === 'product'
            ? await tx.product.findUnique({ where: { slug: dto.slug } })
            : await tx.designerItem.findUnique({ where: { slug: dto.slug } });
        if (!current)
          throw new AppError('NOT_FOUND', {
            detail: `${dto.target} ${dto.slug}`,
          });
        if (current.stockQuantity === null) {
          throw new AppError('CONFLICT', {
            detail: 'made to order: set a stock count in the form first',
          });
        }
        throw new AppError('STOCK_INSUFFICIENT', {
          detail: dto.slug,
          extra: { available: current.stockQuantity },
        });
      }
      const movement = await tx.stockMovement.create({
        data: {
          productId: dto.target === 'product' ? row.id : null,
          designerItemId: dto.target === 'designerItem' ? row.id : null,
          delta: dto.delta,
          quantityAfter: row.stock_quantity,
          reason: dto.reason,
          userId: actor.id,
          createdAt: this.clock.now(),
        },
      });
      await this.audit.record(
        {
          actor,
          action: 'stock.adjust',
          entity: dto.target === 'product' ? 'product' : 'designer_item',
          entityId: row.id,
          before: { stockQuantity: row.stock_quantity - dto.delta },
          after: { stockQuantity: row.stock_quantity, reason: dto.reason },
        },
        tx,
      );
      return {
        id: movement.id,
        target: dto.target,
        slug: dto.slug,
        delta: movement.delta,
        quantityAfter: movement.quantityAfter,
        reason: movement.reason,
        userId: movement.userId,
        createdAt: movement.createdAt,
      };
    });
  }

  async stockMovements(limit: number): Promise<StockMovementDto[]> {
    const rows = await this.prisma.stockMovement.findMany({
      orderBy: { createdAt: 'desc' },
      take: limit,
      include: {
        product: { select: { slug: true } },
        designerItem: { select: { slug: true } },
      },
    });
    return rows.map((m) => ({
      id: m.id,
      target: m.productId ? 'product' : 'designerItem',
      slug: m.product?.slug ?? m.designerItem?.slug ?? '',
      delta: m.delta,
      quantityAfter: m.quantityAfter,
      reason: m.reason,
      userId: m.userId,
      createdAt: m.createdAt,
    }));
  }
}
