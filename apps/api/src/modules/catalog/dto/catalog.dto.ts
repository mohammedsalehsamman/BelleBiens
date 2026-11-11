import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  IsBoolean,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
} from 'class-validator';

// Customer-facing catalog shapes (screens 06-14, 32, 34). Text comes in both
// languages so the app can switch language at once, even from its offline cache
// (EI-UI-01, FR-LOC-04). Prices are SYP minor units (ADR 0011).

export const PRODUCT_KINDS = [
  'BOUQUET',
  'CAKE',
  'SWEET',
  'DRINK',
  'GIFT',
] as const;
export type ProductKindValue = (typeof PRODUCT_KINDS)[number];

export const PRODUCT_BADGES = [
  'bestSeller',
  'seasonal',
  'today',
  'todayOnly',
  'limited',
  'unavailable',
] as const;

export const PRODUCT_SORTS = [
  'popular',
  'newest',
  'price_asc',
  'price_desc',
] as const;
export type ProductSort = (typeof PRODUCT_SORTS)[number];

export class LocalizedTextDto {
  @ApiProperty({ example: 'باقة الجوري الأحمر' }) ar!: string;
  @ApiProperty({ example: 'Red rose bouquet' }) en!: string;
}

export class ProductImageDto {
  @ApiProperty() url!: string;
  @ApiProperty({ type: LocalizedTextDto }) alt!: LocalizedTextDto;
}

export class ProductCardDto {
  @ApiProperty() id!: string;
  @ApiProperty({ example: 'red-rose-bouquet' }) slug!: string;
  @ApiProperty({ enum: PRODUCT_KINDS, enumName: 'ProductKind' })
  kind!: ProductKindValue;
  @ApiProperty({ example: 'flowers' }) categorySlug!: string;
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({ type: LocalizedTextDto }) subtitle!: LocalizedTextDto;
  @ApiProperty({ nullable: true, type: String }) imageUrl!: string | null;
  @ApiProperty({
    type: 'integer',
    example: 240000,
    description: 'Base plus default options, SYP minor units',
  })
  priceMinor!: number;
  @ApiProperty({
    description: 'Show "from" before the price (sizes cost more)',
  })
  priceFrom!: boolean;
  @ApiProperty({ description: 'Can be ordered today' }) available!: boolean;
  @ApiProperty({
    enum: PRODUCT_BADGES,
    enumName: 'ProductBadge',
    isArray: true,
  })
  badges!: (typeof PRODUCT_BADGES)[number][];
  @ApiProperty({
    nullable: true,
    type: 'integer',
    description: 'Pieces left; null when made to order (FR-INV-01)',
  })
  stockLeft!: number | null;
  @ApiProperty({ type: 'integer', example: 0, description: 'FR-DLV-05' })
  leadTimeHours!: number;
}

export class ProductOptionDto {
  @ApiProperty({ example: 'medium' }) key!: string;
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({ type: LocalizedTextDto }) detail!: LocalizedTextDto;
  @ApiProperty({ nullable: true, type: String, example: '#7A1F3D' })
  swatch!: string | null;
  @ApiProperty({ type: 'integer', example: 60000 }) priceChangeMinor!: number;
  @ApiProperty() isDefault!: boolean;
}

export class ProductOptionGroupDto {
  @ApiProperty({ example: 'size' }) key!: string;
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({ enum: ['SINGLE', 'MULTIPLE'], enumName: 'OptionSelection' })
  selection!: 'SINGLE' | 'MULTIPLE';
  @ApiProperty() required!: boolean;
  @ApiProperty({ type: [ProductOptionDto] }) options!: ProductOptionDto[];
}

export class CategoryRefDto {
  @ApiProperty() slug!: string;
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
}

export class ProductDetailDto extends ProductCardDto {
  @ApiProperty({ type: CategoryRefDto }) category!: CategoryRefDto;
  @ApiProperty({ type: LocalizedTextDto }) description!: LocalizedTextDto;
  @ApiProperty({ type: [ProductImageDto] }) images!: ProductImageDto[];
  @ApiProperty({ type: [ProductOptionGroupDto] })
  optionGroups!: ProductOptionGroupDto[];
  @ApiProperty({
    type: [String],
    example: ['nuts', 'milk'],
    description: 'FR-CKE-05',
  })
  allergens!: string[];
  @ApiProperty({ type: [String] }) occasions!: string[];
  @ApiProperty({ type: [String] }) colors!: string[];
  @ApiProperty({ type: [String] }) flowerTypes!: string[];
  @ApiProperty({
    description:
      'Opens in the bouquet designer as a starting point (FR-CAT-07)',
  })
  customizable!: boolean;
  @ApiProperty({
    type: 'integer',
    example: 0,
    description: 'Days from today to the earliest delivery (0 = today)',
  })
  earliestDeliveryInDays!: number;
  @ApiProperty({ type: [ProductCardDto], description: '"Add to your gift"' })
  pairings!: ProductCardDto[];
  @ApiProperty({ description: 'False for guests' }) isFavorite!: boolean;
}

const toBool = ({ value }: { value: unknown }) =>
  value === true || value === 'true' || value === '1';
const toList = ({ value }: { value: unknown }) =>
  (Array.isArray(value) ? value : String(value).split(','))
    .map((v) => String(v).trim())
    .filter((v) => v !== '');

export class ProductQueryDto {
  @ApiPropertyOptional({ example: 'flowers' })
  @IsOptional()
  @IsString()
  @MaxLength(60)
  category?: string;

  @ApiPropertyOptional({ example: 'birthday' })
  @IsOptional()
  @IsString()
  @MaxLength(60)
  occasion?: string;

  @ApiPropertyOptional({
    type: [String],
    example: ['red', 'pink'],
    description: 'Any of',
  })
  @IsOptional()
  @Transform(toList)
  @IsString({ each: true })
  @MaxLength(30, { each: true })
  colors?: string[];

  @ApiPropertyOptional({
    type: [String],
    example: ['rose'],
    description: 'Any of',
  })
  @IsOptional()
  @Transform(toList)
  @IsString({ each: true })
  @MaxLength(30, { each: true })
  flowerTypes?: string[];

  @ApiPropertyOptional({ example: 100000, description: 'SYP minor units' })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  minPrice?: number;

  @ApiPropertyOptional({ example: 300000, description: 'SYP minor units' })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  maxPrice?: number;

  @ApiPropertyOptional({ description: 'Only what can be ordered today' })
  @IsOptional()
  @Transform(toBool)
  @IsBoolean()
  availableToday?: boolean;

  @ApiPropertyOptional({
    description: 'Only what can still be delivered today',
  })
  @IsOptional()
  @Transform(toBool)
  @IsBoolean()
  deliverableToday?: boolean;

  @ApiPropertyOptional({ description: 'Search words (FR-CAT-04)' })
  @IsOptional()
  @IsString()
  @MaxLength(80)
  q?: string;

  @ApiPropertyOptional({
    enum: PRODUCT_SORTS,
    enumName: 'ProductSort',
    default: 'popular',
  })
  @IsOptional()
  @IsIn(PRODUCT_SORTS)
  sort?: ProductSort;

  @ApiPropertyOptional({ default: 1, minimum: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(1000)
  page?: number;

  @ApiPropertyOptional({
    default: 20,
    minimum: 0,
    maximum: 50,
    description: '0 counts only',
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  @Max(50)
  pageSize?: number;
}

export class ProductPageDto {
  @ApiProperty({ type: [ProductCardDto] }) items!: ProductCardDto[];
  @ApiProperty({ type: 'integer', example: 18 }) total!: number;
  @ApiProperty({ type: 'integer', example: 1 }) page!: number;
  @ApiProperty({ type: 'integer', example: 20 }) pageSize!: number;
}

export class SearchQueryDto {
  @ApiProperty({ example: 'جوري' })
  @IsString()
  @MaxLength(80)
  q!: string;

  @ApiPropertyOptional({
    example: 'flowers',
    description: 'Limit results to one category',
  })
  @IsOptional()
  @IsString()
  @MaxLength(60)
  category?: string;
}

export class SearchFacetDto {
  @ApiProperty({ example: 'flowers' }) categorySlug!: string;
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({ type: 'integer', example: 4 }) count!: number;
}

export class SearchResultDto {
  @ApiProperty({ example: 'جوري' }) query!: string;
  @ApiProperty({
    type: 'integer',
    example: 5,
    description: 'Matches in every category',
  })
  total!: number;
  @ApiProperty({ type: [SearchFacetDto], description: 'Tabs on screen 08' })
  facets!: SearchFacetDto[];
  @ApiProperty({ type: [ProductCardDto] }) items!: ProductCardDto[];
}

export class CategoryDto {
  @ApiProperty() slug!: string;
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({ nullable: true, type: String, example: 'flower' }) icon!:
    string | null;
  @ApiProperty({ type: 'integer', example: 8 }) productCount!: number;
}

export class OccasionDto {
  @ApiProperty({ example: 'birthday' }) slug!: string;
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({ type: LocalizedTextDto }) title!: LocalizedTextDto;
  @ApiProperty({ nullable: true, type: String }) heroImage!: string | null;
}

export class OccasionPageDto {
  @ApiProperty({ type: OccasionDto }) occasion!: OccasionDto;
  @ApiProperty({ type: [ProductCardDto] }) products!: ProductCardDto[];
}

export class VocabularyDto {
  @ApiProperty({ example: 'red' }) slug!: string;
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({ nullable: true, type: String }) swatch!: string | null;
}

export class PriceRangeDto {
  @ApiProperty({ type: 'integer', example: 12000 }) minMinor!: number;
  @ApiProperty({ type: 'integer', example: 336000 }) maxMinor!: number;
}

export class CatalogFiltersDto {
  @ApiProperty({ type: [VocabularyDto] }) occasions!: VocabularyDto[];
  @ApiProperty({ type: [VocabularyDto] }) colors!: VocabularyDto[];
  @ApiProperty({ type: [VocabularyDto] }) flowerTypes!: VocabularyDto[];
  @ApiProperty({ type: PriceRangeDto }) price!: PriceRangeDto;
}

export class DailyStemDto {
  @ApiProperty({ example: 'red-rose' }) slug!: string;
  @ApiProperty({
    enum: ['FLOWER', 'GREEN', 'WRAP', 'RIBBON', 'EXTRA'],
    enumName: 'DesignerItemType',
  })
  type!: 'FLOWER' | 'GREEN' | 'WRAP' | 'RIBBON' | 'EXTRA';
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({ type: 'integer', example: 120 }) quantity!: number;
  @ApiProperty() limited!: boolean;
  @ApiProperty({ nullable: true, type: String }) swatch!: string | null;
  @ApiProperty({ type: 'integer', example: 9000 }) unitPriceMinor!: number;
}

export class DailyFlowersDto {
  @ApiProperty({ example: '2026-11-11', description: 'Shop date (Damascus)' })
  date!: string;
  @ApiProperty({
    description: 'Midnight in Damascus, when the list expires (FR-DLY-05)',
  })
  expiresAt!: string;
  @ApiProperty({ type: [ProductCardDto] }) products!: ProductCardDto[];
  @ApiProperty({
    type: [DailyStemDto],
    description: 'Stems for the designer today',
  })
  stems!: DailyStemDto[];
}

export class ShopStatusDto {
  @ApiProperty({ enum: ['open', 'busy', 'closed'] }) mode!:
    'open' | 'busy' | 'closed';
  @ApiProperty() openNow!: boolean;
  @ApiProperty({ example: '10:00' }) opensAt!: string;
  @ApiProperty({ example: '24:00' }) closesAt!: string;
}

export class PageLinkDto {
  @ApiProperty({ example: 'delivery' }) slug!: string;
  @ApiProperty({ type: LocalizedTextDto }) title!: LocalizedTextDto;
}

export class BranchDto {
  @ApiProperty({ example: 'abu-rummaneh' }) code!: string;
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({ type: LocalizedTextDto }) address!: LocalizedTextDto;
  @ApiProperty({ nullable: true, type: String }) phone!: string | null;
  @ApiProperty({ nullable: true, type: String }) whatsapp!: string | null;
  @ApiProperty({ nullable: true, type: String, example: 'bellebiens' })
  instagram!: string | null;
  @ApiProperty({ nullable: true, type: Number }) latitude!: number | null;
  @ApiProperty({ nullable: true, type: Number }) longitude!: number | null;
  @ApiProperty({ type: [String], example: ['Movo', 'BeeOrder'] })
  partners!: string[];
  @ApiProperty({ type: ShopStatusDto }) status!: ShopStatusDto;
  @ApiProperty({ type: [PageLinkDto] }) pages!: PageLinkDto[];
}

export class HomeDto {
  @ApiProperty({ type: [CategoryDto] }) categories!: CategoryDto[];
  @ApiProperty({
    type: [ProductCardDto],
    description: "Today's flowers (FR-DLY-02)",
  })
  today!: ProductCardDto[];
  @ApiProperty({ type: [ProductCardDto], description: 'Cakes and sweets' })
  cakes!: ProductCardDto[];
  @ApiProperty({ type: BranchDto }) branch!: BranchDto;
}

export class PageDto {
  @ApiProperty() slug!: string;
  @ApiProperty({ type: LocalizedTextDto }) title!: LocalizedTextDto;
  @ApiProperty({ type: LocalizedTextDto }) body!: LocalizedTextDto;
  @ApiProperty() updatedAt!: Date;
}
