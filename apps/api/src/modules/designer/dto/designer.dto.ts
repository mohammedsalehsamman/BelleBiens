import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsIn,
  IsInt,
  IsObject,
  Max,
  Min,
  ValidateNested,
} from 'class-validator';
import { LocalizedTextDto } from '../../catalog/dto/catalog.dto.js';

// The bouquet designer (screens 15-18, 37; FR-DSG-*, FR-D2D-*).

export const DESIGNER_ITEM_TYPES = [
  'FLOWER',
  'FILLER',
  'GREEN',
  'WRAP',
  'RIBBON',
  'EXTRA',
  'SWEET',
] as const;
export type DesignerItemTypeValue = (typeof DESIGNER_ITEM_TYPES)[number];

export const SIZE_KEYS = ['small', 'medium', 'large', 'luxury'] as const;
export const PALETTE_KEYS = [
  'pastel',
  'romantic_red',
  'luxury_white',
  'mixed',
] as const;

export class DesignerItemDto {
  @ApiProperty({ example: 'red_rose', description: 'The id used in specs' })
  id!: string;
  @ApiProperty({ enum: DESIGNER_ITEM_TYPES, enumName: 'DesignerPart' })
  type!: DesignerItemTypeValue;
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({ type: LocalizedTextDto }) detail!: LocalizedTextDto;
  @ApiProperty({ type: 'integer', example: 9000 }) unitPriceMinor!: number;
  @ApiProperty({ nullable: true, type: String, example: '#B3263E' })
  swatch!: string | null;
  @ApiProperty({ type: [String], example: ['red'] }) colorTags!: string[];
  @ApiProperty({ nullable: true, type: String }) cutoutUrl!: string | null;
  @ApiProperty({
    nullable: true,
    type: 'integer',
    description:
      'How many can be used today; null means no limit, 0 not available',
  })
  available!: number | null;
  @ApiProperty({ description: 'Limited quantity today (FR-DLY-01)' })
  limited!: boolean;
}

export class DesignerSizeDto {
  @ApiProperty({ enum: SIZE_KEYS, enumName: 'BouquetSize' })
  key!: (typeof SIZE_KEYS)[number];
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({ type: 'integer', example: 15 }) minStems!: number;
  @ApiProperty({ type: 'integer', example: 30 }) maxStems!: number;
}

export class PaletteDto {
  @ApiProperty({ enum: PALETTE_KEYS, enumName: 'BouquetPalette' })
  key!: (typeof PALETTE_KEYS)[number];
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({
    type: [String],
    description: 'Color tags of the flowers that fit it',
  })
  colors!: string[];
}

export class OccasionOptionDto {
  @ApiProperty({ example: 'birthday', description: '"none" for no occasion' })
  slug!: string;
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
}

export class SlotDto {
  @ApiProperty({ type: 'integer' }) x!: number;
  @ApiProperty({ type: 'integer' }) y!: number;
  @ApiProperty({ type: 'integer' }) size!: number;
  @ApiProperty({ type: 'integer' }) rotation!: number;
}

export class SizeLayoutDto {
  @ApiProperty({ enum: SIZE_KEYS, enumName: 'BouquetSize' })
  size!: (typeof SIZE_KEYS)[number];
  @ApiProperty({ type: [SlotDto] }) flowers!: SlotDto[];
  @ApiProperty({ type: [SlotDto] }) greens!: SlotDto[];
  @ApiProperty({ type: SlotDto }) wrapBack!: SlotDto;
  @ApiProperty({ type: SlotDto }) wrapFront!: SlotDto;
  @ApiProperty({ type: SlotDto }) ribbon!: SlotDto;
  @ApiProperty({ type: [SlotDto] }) extras!: SlotDto[];
}

export class SlotLayoutsDto {
  @ApiProperty({ type: 'integer', example: 1 }) version!: number;
  @ApiProperty({ type: 'integer', example: 1000 }) width!: number;
  @ApiProperty({ type: 'integer', example: 1250 }) height!: number;
  @ApiProperty({ type: [SizeLayoutDto] }) sizes!: SizeLayoutDto[];
}

export class DesignerCatalogDto {
  @ApiProperty({ example: '2026-11-11', description: 'Shop date of the stock' })
  date!: string;
  @ApiProperty({ type: [DesignerSizeDto] }) sizes!: DesignerSizeDto[];
  @ApiProperty({ type: [PaletteDto] }) palettes!: PaletteDto[];
  @ApiProperty({ type: [OccasionOptionDto] }) occasions!: OccasionOptionDto[];
  @ApiProperty({ type: [DesignerItemDto] }) items!: DesignerItemDto[];
  @ApiProperty({ type: SlotLayoutsDto }) layouts!: SlotLayoutsDto;
}

export class DesignerQuoteRequestDto {
  @ApiProperty({
    type: Object,
    description: 'A BouquetSpec v1 (contracts/schemas/bouquet-spec.v1.json)',
  })
  @IsObject()
  spec!: Record<string, unknown>;
}

export class QuoteLineDto {
  @ApiProperty({ example: 'red_rose' }) id!: string;
  @ApiProperty({ enum: DESIGNER_ITEM_TYPES, enumName: 'DesignerPart' })
  type!: DesignerItemTypeValue;
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({ type: 'integer' }) qty!: number;
  @ApiProperty({ type: 'integer' }) unitPriceMinor!: number;
  @ApiProperty({ type: 'integer' }) totalMinor!: number;
}

export class AlternativeDto {
  @ApiProperty({ example: 'white_rose' }) id!: string;
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({ nullable: true, type: 'integer' }) available!: number | null;
  @ApiProperty({ type: 'integer' }) unitPriceMinor!: number;
  @ApiProperty({ description: 'Shares a color with the missing item' })
  sameColor!: boolean;
}

export const QUOTE_ISSUES = [
  'STOCK_INSUFFICIENT',
  'ITEM_UNAVAILABLE',
  'STEMS_OUT_OF_RANGE',
] as const;

export class QuoteIssueDto {
  @ApiProperty({ enum: QUOTE_ISSUES, enumName: 'QuoteIssueCode' })
  code!: (typeof QUOTE_ISSUES)[number];
  @ApiPropertyOptional({ example: 'white_gypsophila' }) itemId?: string;
  @ApiPropertyOptional({ type: 'integer', example: 8 }) requested?: number;
  @ApiPropertyOptional({ type: 'integer', example: 6 }) available?: number;
  @ApiPropertyOptional({ type: 'integer' }) min?: number;
  @ApiPropertyOptional({ type: 'integer' }) max?: number;
  @ApiPropertyOptional({ type: [AlternativeDto] })
  alternatives?: AlternativeDto[];
}

export class DesignerQuoteDto {
  @ApiProperty({ description: 'FR-DAI-06' }) specHash!: string;
  @ApiProperty({ type: 'integer', example: 18 }) stems!: number;
  @ApiProperty({ type: DesignerSizeDto }) size!: DesignerSizeDto;
  @ApiProperty({ type: [QuoteLineDto] }) lines!: QuoteLineDto[];
  @ApiProperty({ type: 'integer', example: 267600 }) itemsMinor!: number;
  @ApiProperty({ type: 'integer', example: 0 }) assemblyFeeMinor!: number;
  @ApiProperty({ type: 'integer', example: 267600, description: 'SYP minor' })
  totalMinor!: number;
  @ApiProperty({ type: 'integer', example: 2230 }) totalUsdCents!: number;
  @ApiProperty({ example: '120' }) usdRate!: string;
  @ApiProperty({ type: [QuoteIssueDto] }) issues!: QuoteIssueDto[];
  @ApiProperty({ description: 'No issues: it can go to the cart' })
  orderable!: boolean;
}

export class PreviewImageDto {
  @ApiProperty() url!: string;
}

export class SizeLimitInputDto {
  @ApiProperty({ enum: SIZE_KEYS })
  @IsIn(SIZE_KEYS)
  key!: (typeof SIZE_KEYS)[number];
  @ApiProperty({ example: 15 }) @IsInt() @Min(1) @Max(200) minStems!: number;
  @ApiProperty({ example: 30 }) @IsInt() @Min(1) @Max(200) maxStems!: number;
}

export class SizeLimitsDto {
  @ApiProperty({ type: [SizeLimitInputDto] })
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(4)
  @ValidateNested({ each: true })
  @Type(() => SizeLimitInputDto)
  sizes!: SizeLimitInputDto[];
}
