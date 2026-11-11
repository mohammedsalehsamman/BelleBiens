import type {
  Category,
  Product,
  ProductImage,
  ProductOption,
  ProductOptionGroup,
} from '../../generated/prisma/client.js';
import { availability } from './domain/product-rules.js';
import type {
  LocalizedTextDto,
  ProductCardDto,
  ProductOptionGroupDto,
} from './dto/catalog.dto.js';

export const text = (ar: string, en: string): LocalizedTextDto => ({ ar, en });

/** What a card needs from the database: the product, its category and first image. */
export type CardRow = Product & {
  category: Pick<Category, 'slug'>;
  images: Pick<ProductImage, 'url'>[];
};

export const CARD_INCLUDE = {
  category: { select: { slug: true } },
  images: { select: { url: true }, orderBy: { sortOrder: 'asc' }, take: 1 },
} as const;

export function toCard(row: CardRow, today: Date): ProductCardDto {
  const { available, badges } = availability(row, today);
  return {
    id: row.id,
    slug: row.slug,
    kind: row.kind,
    categorySlug: row.category.slug,
    name: text(row.nameAr, row.nameEn),
    subtitle: text(row.subtitleAr, row.subtitleEn),
    imageUrl: row.images[0]?.url ?? null,
    priceMinor: row.displayPriceMinor,
    priceFrom: row.priceFrom,
    available,
    badges,
    stockLeft: row.stockQuantity,
    leadTimeHours: row.leadTimeHours,
  };
}

export function toOptionGroups(
  groups: (ProductOptionGroup & { options: ProductOption[] })[],
): ProductOptionGroupDto[] {
  return groups.map((g) => ({
    key: g.key,
    name: text(g.nameAr, g.nameEn),
    selection: g.selection,
    required: g.required,
    options: g.options.map((o) => ({
      key: o.key,
      name: text(o.nameAr, o.nameEn),
      detail: text(o.detailAr, o.detailEn),
      swatch: o.swatch,
      priceChangeMinor: o.priceChangeMinor,
      isDefault: o.isDefault,
    })),
  }));
}
