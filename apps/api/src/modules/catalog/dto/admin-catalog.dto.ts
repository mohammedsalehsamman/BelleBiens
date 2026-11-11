import { ApiProperty, ApiPropertyOptional, PartialType } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsBoolean,
  IsHexColor,
  IsIn,
  IsInt,
  IsObject,
  IsOptional,
  IsString,
  IsUrl,
  Matches,
  Max,
  MaxLength,
  Min,
  MinLength,
  ValidateNested,
} from 'class-validator';
import { COLOR_SLUGS, FLOWER_TYPE_SLUGS } from '../domain/vocabulary.js';
import { PRODUCT_KINDS, type ProductKindValue } from './catalog.dto.js';

// Dashboard writes (FR-ADM-02/03/04). Every change is audited (FR-ADM-09).

const SLUG = /^[a-z0-9][a-z0-9-]{0,79}$/;
const SLUG_MESSAGE = 'lowercase letters, digits and dashes';
/** 10 million pounds, far above any real price; catches a misplaced zero. */
const MAX_PRICE_MINOR = 1_000_000_000;
const DESIGNER_TYPES = ['FLOWER', 'GREEN', 'WRAP', 'RIBBON', 'EXTRA'] as const;
const STATUSES = ['ACTIVE', 'HIDDEN'] as const;

export class OptionInputDto {
  @ApiProperty({ example: 'medium' })
  @Matches(SLUG, { message: SLUG_MESSAGE })
  key!: string;
  @ApiProperty() @IsString() @MinLength(1) @MaxLength(80) nameAr!: string;
  @ApiProperty() @IsString() @MinLength(1) @MaxLength(80) nameEn!: string;
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(80)
  detailAr?: string;
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(80)
  detailEn?: string;
  @ApiPropertyOptional({ example: '#7A1F3D' })
  @IsOptional()
  @IsHexColor()
  swatch?: string;
  @ApiPropertyOptional({ example: 60000 })
  @IsOptional()
  @IsInt()
  @Min(-MAX_PRICE_MINOR)
  @Max(MAX_PRICE_MINOR)
  priceChangeMinor?: number;
  @ApiPropertyOptional() @IsOptional() @IsBoolean() isDefault?: boolean;
}

export class OptionGroupInputDto {
  @ApiProperty({ example: 'size' })
  @Matches(SLUG, { message: SLUG_MESSAGE })
  key!: string;
  @ApiProperty() @IsString() @MinLength(1) @MaxLength(80) nameAr!: string;
  @ApiProperty() @IsString() @MinLength(1) @MaxLength(80) nameEn!: string;
  @ApiPropertyOptional({ enum: ['SINGLE', 'MULTIPLE'], default: 'SINGLE' })
  @IsOptional()
  @IsIn(['SINGLE', 'MULTIPLE'])
  selection?: 'SINGLE' | 'MULTIPLE';
  @ApiPropertyOptional({ default: true })
  @IsOptional()
  @IsBoolean()
  required?: boolean;
  @ApiProperty({ type: [OptionInputDto] })
  @IsArray()
  @ArrayMaxSize(30)
  @ValidateNested({ each: true })
  @Type(() => OptionInputDto)
  options!: OptionInputDto[];
}

export class ImageInputDto {
  @ApiProperty({ description: 'A URL returned by POST /v1/admin/media' })
  @IsUrl({ require_tld: false, protocols: ['http', 'https'] })
  @MaxLength(500)
  url!: string;
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(200)
  altAr?: string;
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(200)
  altEn?: string;
}

export class CreateProductDto {
  @ApiProperty({ example: 'red-rose-bouquet' })
  @Matches(SLUG, { message: SLUG_MESSAGE })
  slug!: string;
  @ApiProperty({ example: 'flowers' })
  @Matches(SLUG, { message: SLUG_MESSAGE })
  categorySlug!: string;
  @ApiProperty({ enum: PRODUCT_KINDS })
  @IsIn(PRODUCT_KINDS)
  kind!: ProductKindValue;
  @ApiProperty() @IsString() @MinLength(1) @MaxLength(120) nameAr!: string;
  @ApiProperty() @IsString() @MinLength(1) @MaxLength(120) nameEn!: string;
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(120)
  subtitleAr?: string;
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(120)
  subtitleEn?: string;
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(4000)
  descriptionAr?: string;
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(4000)
  descriptionEn?: string;
  @ApiProperty({ example: 180000, description: 'SYP minor units' })
  @IsInt()
  @Min(0)
  @Max(MAX_PRICE_MINOR)
  basePriceMinor!: number;
  @ApiPropertyOptional({ example: 24 })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(24 * 60)
  leadTimeHours?: number;
  @ApiPropertyOptional({ type: [String] })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(20)
  @IsString({ each: true })
  @MaxLength(30, { each: true })
  allergens?: string[];
  @ApiPropertyOptional({ type: [String], description: 'Occasion slugs' })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(20)
  @Matches(SLUG, { each: true })
  occasions?: string[];
  @ApiPropertyOptional({ type: [String], enum: COLOR_SLUGS })
  @IsOptional()
  @IsArray()
  @IsIn(COLOR_SLUGS, { each: true })
  colors?: string[];
  @ApiPropertyOptional({ type: [String], enum: FLOWER_TYPE_SLUGS })
  @IsOptional()
  @IsArray()
  @IsIn(FLOWER_TYPE_SLUGS, { each: true })
  flowerTypes?: string[];
  @ApiPropertyOptional({
    nullable: true,
    type: Number,
    description: 'null = made to order',
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  stockQuantity?: number | null;
  @ApiPropertyOptional({ enum: STATUSES })
  @IsOptional()
  @IsIn(STATUSES)
  status?: 'ACTIVE' | 'HIDDEN';
  @ApiPropertyOptional() @IsOptional() @IsBoolean() dailyOnly?: boolean;
  @ApiPropertyOptional() @IsOptional() @IsBoolean() limited?: boolean;
  @ApiPropertyOptional() @IsOptional() @IsBoolean() seasonal?: boolean;
  @ApiPropertyOptional() @IsOptional() @IsBoolean() bestSeller?: boolean;
  @ApiPropertyOptional()
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(1_000_000)
  popularity?: number;
  @ApiPropertyOptional({ type: [String], description: 'Product slugs' })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(8)
  @Matches(SLUG, { each: true })
  pairings?: string[];
  @ApiPropertyOptional({
    type: Object,
    nullable: true,
    description: 'Bouquet spec (S3)',
  })
  @IsOptional()
  @IsObject()
  designerTemplate?: Record<string, unknown> | null;
  @ApiPropertyOptional({ type: [ImageInputDto] })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(10)
  @ValidateNested({ each: true })
  @Type(() => ImageInputDto)
  images?: ImageInputDto[];
  @ApiPropertyOptional({
    type: [OptionGroupInputDto],
    description: 'Replaces all groups',
  })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(10)
  @ValidateNested({ each: true })
  @Type(() => OptionGroupInputDto)
  optionGroups?: OptionGroupInputDto[];
}

export class UpdateProductDto extends PartialType(CreateProductDto) {}

export class AdminProductDto extends CreateProductDto {
  @ApiProperty() id!: string;
  @ApiProperty({ example: 240000 }) displayPriceMinor!: number;
  @ApiProperty() priceFrom!: boolean;
  @ApiProperty({ nullable: true, type: String, example: '2026-11-11' })
  dailyDate!: string | null;
  @ApiProperty() updatedAt!: Date;
}

export class TodayListDto {
  @ApiProperty({
    type: [String],
    description:
      "Product slugs on today's list; others are taken off (FR-DLY-02)",
  })
  @IsArray()
  @ArrayMaxSize(100)
  @Matches(SLUG, { each: true })
  productSlugs!: string[];
}

export class DailyStemInputDto {
  @ApiProperty({ example: 'red-rose' })
  @Matches(SLUG, { message: SLUG_MESSAGE })
  slug!: string;
  @ApiProperty({ example: 120 })
  @IsInt()
  @Min(0)
  @Max(100_000)
  quantity!: number;
  @ApiPropertyOptional() @IsOptional() @IsBoolean() limited?: boolean;
}

export class DailyStemsInputDto {
  @ApiProperty({
    type: [DailyStemInputDto],
    description: "Today's stems (FR-DLY-01)",
  })
  @IsArray()
  @ArrayMaxSize(200)
  @ValidateNested({ each: true })
  @Type(() => DailyStemInputDto)
  items!: DailyStemInputDto[];
}

export class StockAdjustmentDto {
  @ApiProperty({ enum: ['product', 'designerItem'] })
  @IsIn(['product', 'designerItem'])
  target!: 'product' | 'designerItem';
  @ApiProperty({ example: 'glass-vase' })
  @Matches(SLUG, { message: SLUG_MESSAGE })
  slug!: string;
  @ApiProperty({ example: -2, description: 'Positive adds, negative removes' })
  @IsInt()
  @Min(-100_000)
  @Max(100_000)
  delta!: number;
  @ApiProperty({ example: 'Two vases broke in delivery' })
  @IsString()
  @MinLength(3)
  @MaxLength(300)
  reason!: string;
}

export class StockMovementDto {
  @ApiProperty() id!: string;
  @ApiProperty({ enum: ['product', 'designerItem'] }) target!:
    'product' | 'designerItem';
  @ApiProperty() slug!: string;
  @ApiProperty() delta!: number;
  @ApiProperty() quantityAfter!: number;
  @ApiProperty() reason!: string;
  @ApiProperty({ nullable: true, type: String }) userId!: string | null;
  @ApiProperty() createdAt!: Date;
}

export class DesignerItemInputDto {
  @ApiProperty({ example: 'red-rose' })
  @Matches(SLUG, { message: SLUG_MESSAGE })
  slug!: string;
  @ApiProperty({ enum: DESIGNER_TYPES })
  @IsIn(DESIGNER_TYPES)
  type!: (typeof DESIGNER_TYPES)[number];
  @ApiProperty() @IsString() @MinLength(1) @MaxLength(80) nameAr!: string;
  @ApiProperty() @IsString() @MinLength(1) @MaxLength(80) nameEn!: string;
  @ApiProperty({ example: 9000 })
  @IsInt()
  @Min(0)
  @Max(MAX_PRICE_MINOR)
  unitPriceMinor!: number;
  @ApiPropertyOptional() @IsOptional() @IsHexColor() swatch?: string;
  @ApiPropertyOptional({ type: [String] })
  @IsOptional()
  @IsArray()
  @IsIn(COLOR_SLUGS, { each: true })
  colorTags?: string[];
  @ApiPropertyOptional({ type: [String] })
  @IsOptional()
  @IsArray()
  @Matches(SLUG, { each: true })
  occasionTags?: string[];
  @ApiPropertyOptional()
  @IsOptional()
  @IsUrl({ require_tld: false })
  cutoutUrl?: string;
  @ApiPropertyOptional({ nullable: true, type: Number })
  @IsOptional()
  @IsInt()
  @Min(0)
  stockQuantity?: number | null;
  @ApiPropertyOptional({ example: '03-01', description: 'FR-INV-06, MM-DD' })
  @IsOptional()
  @Matches(/^(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$/)
  seasonFrom?: string;
  @ApiPropertyOptional({ example: '05-31' })
  @IsOptional()
  @Matches(/^(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$/)
  seasonTo?: string;
  @ApiPropertyOptional({ enum: STATUSES })
  @IsOptional()
  @IsIn(STATUSES)
  status?: 'ACTIVE' | 'HIDDEN';
  @ApiPropertyOptional() @IsOptional() @IsInt() @Min(0) sortOrder?: number;
}

export class UpdateDesignerItemDto extends PartialType(DesignerItemInputDto) {}

export class AdminDesignerItemDto extends DesignerItemInputDto {
  @ApiProperty() id!: string;
  @ApiProperty({
    nullable: true,
    type: Number,
    description: "Today's stems, if listed",
  })
  todayQuantity!: number | null;
}

export class MediaDto {
  @ApiProperty() url!: string;
  @ApiProperty({ example: 'image/webp' }) contentType!: string;
  @ApiProperty() width!: number;
  @ApiProperty() height!: number;
}

export class MediaUploadDto {
  @ApiProperty({ type: 'string', format: 'binary' }) file!: unknown;
}

export class MediaQueryDto {
  @ApiPropertyOptional({ enum: ['product', 'cutout'], default: 'product' })
  @IsOptional()
  @IsIn(['product', 'cutout'])
  kind?: 'product' | 'cutout';
}
