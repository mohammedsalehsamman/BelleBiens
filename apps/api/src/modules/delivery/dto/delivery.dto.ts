import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsBoolean,
  IsIn,
  IsInt,
  IsLatitude,
  IsLongitude,
  IsOptional,
  IsString,
  Matches,
  Max,
  MaxLength,
  Min,
  MinLength,
  ValidateNested,
} from 'class-validator';
import { LocalizedTextDto } from '../../catalog/dto/catalog.dto.js';

// Delivery (screens 21, 22, 36, 39; FR-DLV-01..09, FR-ADM-12).

export const DATE = /^\d{4}-\d{2}-\d{2}$/;
export const TIME = /^([01]\d|2[0-3]):[0-5]\d$|^24:00$/;
const SLUG = /^[a-z0-9][a-z0-9-]{0,79}$/;

export const FULFILLMENTS = ['DELIVERY', 'PICKUP'] as const;
export type FulfillmentValue = (typeof FULFILLMENTS)[number];

export const SLOT_PROBLEMS = [
  'TOO_SOON',
  'FULL',
  'CLOSED',
  'BUSY',
  'OUT_OF_RANGE',
] as const;

export class ZoneDto {
  @ApiProperty({ example: 'abu-rummaneh' }) slug!: string;
  @ApiProperty({ type: LocalizedTextDto }) name!: LocalizedTextDto;
  @ApiProperty({ type: 'integer', example: 15000 }) feeMinor!: number;
  @ApiProperty({
    type: LocalizedTextDto,
    description: 'Estimated delivery time, as the shop writes it',
  })
  eta!: LocalizedTextDto;
}

export class ZoneWithAreaDto extends ZoneDto {
  @ApiProperty({
    description: 'Ring of [longitude, latitude] points (GeoJSON order)',
    type: 'array',
    items: { type: 'array', items: { type: 'number' } },
  })
  polygon!: number[][];
}

export class PointDto {
  @ApiProperty({ example: 33.5138 })
  @IsLatitude()
  latitude!: number;

  @ApiProperty({ example: 36.2765 })
  @IsLongitude()
  longitude!: number;
}

export class ZoneCheckDto {
  @ApiProperty({ description: 'FR-DLV-01: the pin is inside a delivery zone' })
  inZone!: boolean;
  @ApiPropertyOptional({ type: ZoneDto }) zone?: ZoneDto;
}

export class DeliverySlotDto {
  @ApiProperty({ example: '12:00' }) start!: string;
  @ApiProperty({ example: '14:00' }) end!: string;
  @ApiProperty({ description: 'The slot can be chosen' }) available!: boolean;
  @ApiPropertyOptional({
    enum: SLOT_PROBLEMS,
    enumName: 'SlotProblem',
    description: 'Why it cannot be chosen',
  })
  problem?: (typeof SLOT_PROBLEMS)[number];
}

export class DeliveryDayDto {
  @ApiProperty({ example: '2026-11-12' }) date!: string;
  @ApiProperty({ type: 'integer', description: '0 today, 1 tomorrow, ...' })
  inDays!: number;
  @ApiProperty() available!: boolean;
  @ApiPropertyOptional({
    enum: SLOT_PROBLEMS,
    enumName: 'SlotProblem',
    description: 'For a day with no slot: the reason of its first slot',
  })
  problem?: (typeof SLOT_PROBLEMS)[number];
}

export class DeliveryCalendarDto {
  @ApiProperty({
    type: 'integer',
    description: 'The longest lead time asked about',
  })
  leadTimeHours!: number;
  @ApiProperty({ type: 'integer', example: 60 }) windowDays!: number;
  @ApiProperty({
    type: [DeliveryDayDto],
    description: 'Today to the end of the window',
  })
  days!: DeliveryDayDto[];
}

export class DaySlotsDto {
  @ApiProperty({ example: '2026-11-12' }) date!: string;
  @ApiProperty({ type: [DeliverySlotDto] }) slots!: DeliverySlotDto[];
}

export class SlotHoldRequestDto {
  @ApiProperty({ example: '2026-11-12' })
  @Matches(DATE)
  date!: string;

  @ApiProperty({ example: '12:00' })
  @Matches(TIME)
  start!: string;

  @ApiPropertyOptional({ type: 'integer', description: 'The cart lead time' })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(24 * 60)
  leadTimeHours?: number;
}

export class SlotHoldDto {
  @ApiProperty() id!: string;
  @ApiProperty({ example: '2026-11-12' }) date!: string;
  @ApiProperty({ example: '12:00' }) start!: string;
  @ApiProperty() expiresAt!: Date;
}

// ---------- saved addresses (FR-ACC-04, screen 22) ----------

export class AddressInputDto extends PointDto {
  @ApiProperty({ example: 'البيت' })
  @IsString()
  @MinLength(1)
  @MaxLength(40)
  label!: string;

  @ApiPropertyOptional({ example: 'شارع المهدي بن بركة' })
  @IsOptional()
  @IsString()
  @MaxLength(120)
  area?: string;

  @ApiPropertyOptional({ example: 'قرب حديقة الجاحظ' })
  @IsOptional()
  @IsString()
  @MaxLength(160)
  landmark?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(60)
  building?: string;
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(20)
  floor?: string;
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(300)
  details?: string;
}

export class AddressDto {
  @ApiProperty() id!: string;
  @ApiProperty() label!: string;
  @ApiProperty() latitude!: number;
  @ApiProperty() longitude!: number;
  @ApiProperty() area!: string;
  @ApiProperty() landmark!: string;
  @ApiProperty() building!: string;
  @ApiProperty() floor!: string;
  @ApiProperty() details!: string;
  @ApiPropertyOptional({
    type: ZoneDto,
    description: 'Absent: outside the zones now',
  })
  zone?: ZoneDto;
}

// ---------- the shop's side (FR-DLV-02/04/09, FR-ADM-12) ----------

export class ZoneInputDto {
  @ApiProperty({ example: 'abu-rummaneh' })
  @Matches(SLUG)
  slug!: string;
  @ApiProperty() @IsString() @MinLength(1) @MaxLength(80) nameAr!: string;
  @ApiProperty() @IsString() @MinLength(1) @MaxLength(80) nameEn!: string;

  @ApiProperty({
    type: 'array',
    items: { type: 'array', items: { type: 'number' } },
    description: '[longitude, latitude] corners, at least three',
  })
  @IsArray()
  @ArrayMinSize(3)
  @ArrayMaxSize(500)
  polygon!: number[][];

  @ApiProperty({ type: 'integer' })
  @IsInt()
  @Min(0)
  @Max(100_000_000)
  feeMinor!: number;
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(80)
  etaAr?: string;
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(80)
  etaEn?: string;
  @ApiPropertyOptional() @IsOptional() @IsBoolean() active?: boolean;
  @ApiPropertyOptional({ type: 'integer' })
  @IsOptional()
  @IsInt()
  sortOrder?: number;
}

export class AdminZoneDto extends ZoneWithAreaDto {
  @ApiProperty() id!: string;
  @ApiProperty() active!: boolean;
  @ApiProperty({ type: 'integer' }) sortOrder!: number;
}

export class SlotTemplateDto {
  @ApiProperty({ example: '12:00' }) @Matches(TIME) start!: string;
  @ApiProperty({ example: '14:00' }) @Matches(TIME) end!: string;
  @ApiProperty({ type: 'integer', example: 6 })
  @IsInt()
  @Min(0)
  @Max(1000)
  capacity!: number;
}

export class DeliverySettingsDto {
  @ApiProperty({ type: [SlotTemplateDto] })
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(24)
  @ValidateNested({ each: true })
  @Type(() => SlotTemplateDto)
  slots!: SlotTemplateDto[];

  @ApiProperty({ type: [String], example: ['2026-12-25'] })
  @IsArray()
  @ArrayMaxSize(400)
  @Matches(DATE, { each: true })
  closedDays!: string[];

  @ApiProperty({ type: 'integer', example: 60 })
  @IsInt()
  @Min(0)
  @Max(365)
  windowDays!: number;

  @ApiProperty({ type: 'integer', example: 15 })
  @IsInt()
  @Min(1)
  @Max(120)
  slotHoldMinutes!: number;
}

export const SHOP_MODES = ['open', 'busy', 'closed'] as const;

export class MessageInputDto {
  @ApiProperty() @IsString() @MaxLength(300) ar!: string;
  @ApiProperty() @IsString() @MaxLength(300) en!: string;
}

export class ShopModeDto {
  @ApiProperty({ enum: SHOP_MODES })
  @IsIn(SHOP_MODES)
  mode!: (typeof SHOP_MODES)[number];

  @ApiPropertyOptional({
    type: MessageInputDto,
    description: 'Shown to customers',
  })
  @IsOptional()
  @ValidateNested()
  @Type(() => MessageInputDto)
  message?: MessageInputDto;

  @ApiPropertyOptional({
    example: '20:00',
    description: 'Busy mode: today, only slots from this time',
  })
  @IsOptional()
  @Matches(TIME)
  acceptsFrom?: string;
}
