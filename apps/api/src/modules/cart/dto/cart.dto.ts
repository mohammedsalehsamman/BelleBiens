import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
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
import {
  LocalizedTextDto,
  ProductCardDto,
} from '../../catalog/dto/catalog.dto.js';
import { DesignerItemDto } from '../../designer/dto/designer.dto.js';

// The cart (screens 19, 20, 35; FR-CRT-*, FR-BOX-*). Lines carry choices only;
// every quote prices them from the database (NFR-SEC-06).

export const LINE_KINDS = ['product', 'design', 'box'] as const;
export type LineKind = (typeof LINE_KINDS)[number];

const SLUG = /^[a-z0-9][a-z0-9-]{0,79}$/;

export class OptionChoiceDto {
  @ApiProperty({ example: 'size' })
  @Matches(SLUG)
  group!: string;

  @ApiProperty({ example: '22cm' })
  @Matches(SLUG)
  option!: string;
}

export class ProductChoiceDto {
  @ApiProperty({ example: 'rose-pistachio-cake' })
  @Matches(SLUG)
  slug!: string;

  @ApiProperty({ type: [OptionChoiceDto] })
  @IsArray()
  @ArrayMaxSize(30)
  @ValidateNested({ each: true })
  @Type(() => OptionChoiceDto)
  options!: OptionChoiceDto[];

  @ApiPropertyOptional({
    example: 'كل عام وأنت بخير',
    description: 'Message on the cake (FR-CKE-03)',
  })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  inscription?: string;

  @ApiPropertyOptional({
    description: 'From POST /v1/uploads/reference-image (FR-CKE-04)',
  })
  @IsOptional()
  @IsUrl({ require_tld: false, protocols: ['http', 'https'] })
  @MaxLength(500)
  referenceImageUrl?: string;
}

export class CartLineInputDto {
  @ApiProperty({
    example: '3f2c9a8e-…',
    description: 'Chosen by the app; stays the same while the line lives',
  })
  @IsString()
  @MinLength(1)
  @MaxLength(64)
  id!: string;

  @ApiProperty({ enum: LINE_KINDS, enumName: 'CartLineKind' })
  @IsIn(LINE_KINDS)
  kind!: LineKind;

  @ApiProperty({ example: 1 })
  @IsInt()
  @Min(1)
  @Max(50)
  qty!: number;

  @ApiPropertyOptional({ type: ProductChoiceDto })
  @IsOptional()
  @ValidateNested()
  @Type(() => ProductChoiceDto)
  product?: ProductChoiceDto;

  @ApiPropertyOptional({
    type: Object,
    description: 'BouquetSpec v1 for a design, BoxSpec v1 for a box',
  })
  @IsOptional()
  @IsObject()
  spec?: Record<string, unknown>;

  @ApiPropertyOptional({ description: 'The rendered 2D preview (FR-D2D-05)' })
  @IsOptional()
  @IsUrl({ require_tld: false, protocols: ['http', 'https'] })
  @MaxLength(500)
  previewUrl?: string;
}

export class CartQuoteRequestDto {
  @ApiProperty({ type: [CartLineInputDto] })
  @IsArray()
  @ArrayMaxSize(50)
  @ValidateNested({ each: true })
  @Type(() => CartLineInputDto)
  lines!: CartLineInputDto[];

  @ApiPropertyOptional({ example: 'WELCOME10' })
  @IsOptional()
  @IsString()
  @MinLength(3)
  @MaxLength(32)
  couponCode?: string;

  @ApiPropertyOptional({
    example: 'abu-rummaneh',
    description:
      'Checkout: add the delivery fee of this zone (FR-CRT-08, screen 23)',
  })
  @IsOptional()
  @Matches(/^[a-z0-9][a-z0-9-]{0,79}$/)
  zone?: string;
}

export class SaveCartDto {
  @ApiProperty({ type: [CartLineInputDto] })
  @IsArray()
  @ArrayMaxSize(50)
  @ValidateNested({ each: true })
  @Type(() => CartLineInputDto)
  lines!: CartLineInputDto[];
}

export class CartDto {
  @ApiProperty({ type: [CartLineInputDto] }) lines!: CartLineInputDto[];
  @ApiProperty({ nullable: true, type: Date }) updatedAt!: Date | null;
}

export const LINE_ISSUES = [
  'PRODUCT_UNAVAILABLE',
  'OPTION_UNAVAILABLE',
  'STOCK_INSUFFICIENT',
  'ITEM_UNAVAILABLE',
  'STEMS_OUT_OF_RANGE',
  'BOX_COMPARTMENT_INVALID',
  'BOX_OVER_CAPACITY',
  'INSCRIPTION_NOT_ALLOWED',
] as const;

export class LineIssueDto {
  @ApiProperty({ enum: LINE_ISSUES, enumName: 'CartIssueCode' })
  code!: (typeof LINE_ISSUES)[number];
  @ApiPropertyOptional({ example: 'white_gypsophila' }) itemId?: string;
  @ApiPropertyOptional({ type: 'integer' }) requested?: number;
  @ApiPropertyOptional({ type: 'integer' }) available?: number;
}

export class QuotedLineDto {
  @ApiProperty() id!: string;
  @ApiProperty({ enum: LINE_KINDS, enumName: 'CartLineKind' }) kind!: LineKind;
  @ApiProperty({
    type: LocalizedTextDto,
    example: { ar: 'باقتك المصمّمة', en: 'Your bouquet' },
  })
  title!: LocalizedTextDto;
  @ApiProperty({
    type: LocalizedTextDto,
    description: 'Choices in a line: "22 سم · شمعة"',
  })
  summary!: LocalizedTextDto;
  @ApiProperty({ nullable: true, type: String }) imageUrl!: string | null;
  @ApiProperty({ type: 'integer' }) unitPriceMinor!: number;
  @ApiProperty({ type: 'integer' }) qty!: number;
  @ApiProperty({ type: 'integer' }) totalMinor!: number;
  @ApiProperty({ type: 'integer', description: 'FR-DLV-05' })
  leadTimeHours!: number;
  @ApiProperty({ type: [LineIssueDto] }) issues!: LineIssueDto[];
}

export const COUPON_PROBLEMS = [
  'NOT_FOUND',
  'EXPIRED',
  'MIN_ORDER',
  'USED_UP',
] as const;

export class CouponResultDto {
  @ApiProperty({ example: 'WELCOME10' }) code!: string;
  @ApiProperty() applied!: boolean;
  @ApiPropertyOptional({
    enum: COUPON_PROBLEMS,
    enumName: 'CouponProblem',
    description: 'Why it was not applied; absent when applied',
  })
  problem?: (typeof COUPON_PROBLEMS)[number];
  @ApiProperty({ type: 'integer', description: 'For MIN_ORDER' })
  minOrderMinor!: number;
}

export class MoneyBreakdownDto {
  @ApiProperty({ type: 'integer' }) itemsMinor!: number;
  @ApiProperty({ type: 'integer' }) assemblyFeeMinor!: number;
  @ApiProperty({ type: 'integer' }) discountMinor!: number;
  @ApiProperty({ type: 'integer', description: 'Set at checkout (S5)' })
  deliveryFeeMinor!: number;
  @ApiProperty({ type: 'integer' }) roundingAdjustmentMinor!: number;
  @ApiProperty({ type: 'integer' }) totalMinor!: number;
}

export class CartQuoteDto {
  @ApiProperty({ type: [QuotedLineDto] }) lines!: QuotedLineDto[];
  @ApiProperty({ type: MoneyBreakdownDto, description: 'SYP minor units' })
  syp!: MoneyBreakdownDto;
  @ApiProperty({ type: MoneyBreakdownDto, description: 'US cents (FR-PAY-05)' })
  usd!: MoneyBreakdownDto;
  @ApiProperty({ example: '120' }) usdRate!: string;
  @ApiPropertyOptional({
    type: CouponResultDto,
    description: 'Only when a code was sent',
  })
  coupon?: CouponResultDto;
  @ApiProperty({
    type: 'integer',
    description: 'Longest lead time in the cart',
  })
  leadTimeHours!: number;
  @ApiProperty({
    example: '2026-11-12T15:00:00.000+03:00',
    description: 'Earliest delivery or pickup for the whole cart (FR-DLV-05)',
  })
  earliestAt!: string;
  @ApiProperty({ type: 'integer', example: 1 }) earliestInDays!: number;
  @ApiProperty({ description: 'No line has an issue' }) orderable!: boolean;
  @ApiProperty({ type: [ProductCardDto], description: '"قد يعجبك أيضاً"' })
  suggestions!: ProductCardDto[];
}

export class BoxCompartmentDto {
  @ApiProperty({ type: 'integer' }) index!: number;
  @ApiProperty({ enum: ['FLOWER', 'SWEET', 'EXTRA'], enumName: 'BoxPartKind' })
  kind!: 'FLOWER' | 'SWEET' | 'EXTRA';
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({ type: 'integer', example: 12 }) capacity!: number;
}

export class BoxTypeDto {
  @ApiProperty({ example: 'square_two' }) id!: string;
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({ type: LocalizedTextDto }) detail!: LocalizedTextDto;
  @ApiProperty({ type: 'integer' }) basePriceMinor!: number;
  @ApiProperty({ type: 'integer', description: 'Base plus the default fill' })
  fromPriceMinor!: number;
  @ApiProperty({ type: [BoxCompartmentDto] })
  compartments!: BoxCompartmentDto[];
}

export class BoxCatalogDto {
  @ApiProperty({ type: [BoxTypeDto] }) types!: BoxTypeDto[];
  @ApiProperty({
    type: [DesignerItemDto],
    description: 'Flowers, sweets, gifts',
  })
  items!: DesignerItemDto[];
}

export class UploadedImageDto {
  @ApiProperty() url!: string;
}

export class CouponInputDto {
  @ApiProperty({ example: 'WELCOME10' })
  @Matches(/^[A-Za-z0-9_-]{3,32}$/)
  code!: string;
  @ApiProperty({ enum: ['PERCENT', 'FIXED'] })
  @IsIn(['PERCENT', 'FIXED'])
  type!: 'PERCENT' | 'FIXED';
  @ApiProperty({ example: 10, description: 'Percent, or SYP minor units' })
  @IsInt()
  @Min(1)
  @Max(1_000_000_000)
  value!: number;
  @ApiPropertyOptional() @IsOptional() @IsInt() @Min(0) minOrderMinor?: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Date) startsAt?: Date;
  @ApiPropertyOptional() @IsOptional() @Type(() => Date) endsAt?: Date;
  @ApiPropertyOptional() @IsOptional() @IsInt() @Min(1) maxRedemptions?: number;
  @ApiPropertyOptional() @IsOptional() @IsIn([true, false]) active?: boolean;
}

export class CouponDto extends CouponInputDto {
  @ApiProperty() id!: string;
  @ApiProperty({ type: 'integer' }) redemptions!: number;
}
