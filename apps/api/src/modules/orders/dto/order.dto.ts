import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsBoolean,
  IsIn,
  IsLatitude,
  IsLongitude,
  IsOptional,
  IsString,
  IsUUID,
  Matches,
  MaxLength,
  MinLength,
  ValidateNested,
} from 'class-validator';
import { LocalizedTextDto } from '../../catalog/dto/catalog.dto.js';
import {
  CartLineInputDto,
  MoneyBreakdownDto,
} from '../../cart/dto/cart.dto.js';
import {
  DATE,
  FULFILLMENTS,
  type FulfillmentValue,
  TIME,
  ZoneDto,
} from '../../delivery/dto/delivery.dto.js';

// Orders (screens 21, 23, 25; FR-CRT-09/10, FR-ORD-*, FR-PAY-02).

export const ORDER_STATUSES = [
  'NEW',
  'CONFIRMED',
  'PREPARING',
  'READY',
  'OUT_FOR_DELIVERY',
  'DELIVERED',
  'PICKED_UP',
  'CANCELLED',
] as const;
export type OrderStatusValue = (typeof ORDER_STATUSES)[number];

export const PAYMENT_METHODS = ['CASH', 'SHAMCASH', 'STRIPE'] as const;
export type PaymentMethodValue = (typeof PAYMENT_METHODS)[number];

export const PAYMENT_STATUSES = [
  'PENDING',
  'PAID',
  'FAILED',
  'REFUNDED',
] as const;

export class PersonDto {
  @ApiProperty({ example: 'لين' })
  @IsString()
  @MinLength(1)
  @MaxLength(80)
  name!: string;

  @ApiProperty({
    example: '0944123456',
    description: 'Checked as in FR-CRT-09',
  })
  @IsString()
  @MaxLength(32)
  phone!: string;
}

export class OrderAddressInputDto {
  @ApiProperty({ example: 33.5138 }) @IsLatitude() latitude!: number;
  @ApiProperty({ example: 36.2765 }) @IsLongitude() longitude!: number;
  @ApiPropertyOptional({ example: 'البيت' })
  @IsOptional()
  @IsString()
  @MaxLength(40)
  label?: string;
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(120)
  area?: string;
  @ApiPropertyOptional()
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

  @ApiPropertyOptional({
    description: 'Signed in: also save it to my addresses (screen 22)',
  })
  @IsOptional()
  @IsBoolean()
  save?: boolean;
}

export class SlotChoiceDto {
  @ApiProperty({ example: '2026-11-12' }) @Matches(DATE) date!: string;
  @ApiProperty({ example: '12:00' }) @Matches(TIME) start!: string;
}

export class CreateOrderDto {
  @ApiProperty({ type: [CartLineInputDto] })
  @IsArray()
  @ArrayMinSize(1)
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

  @ApiProperty({ enum: FULFILLMENTS, enumName: 'Fulfillment' })
  @IsIn(FULFILLMENTS)
  fulfillment!: FulfillmentValue;

  @ApiProperty({ type: PersonDto, description: 'Who orders' })
  @ValidateNested()
  @Type(() => PersonDto)
  customer!: PersonDto;

  @ApiPropertyOptional({
    type: PersonDto,
    description: 'Someone else receives it (FR-DLV-07); absent: the customer',
  })
  @IsOptional()
  @ValidateNested()
  @Type(() => PersonDto)
  recipient?: PersonDto;

  @ApiPropertyOptional({ description: '"لا تُظهر اسمي للمستلم"' })
  @IsOptional()
  @IsBoolean()
  hideSender?: boolean;

  @ApiPropertyOptional({
    type: OrderAddressInputDto,
    description: 'Delivery only',
  })
  @IsOptional()
  @ValidateNested()
  @Type(() => OrderAddressInputDto)
  address?: OrderAddressInputDto;

  @ApiProperty({ type: SlotChoiceDto })
  @ValidateNested()
  @Type(() => SlotChoiceDto)
  slot!: SlotChoiceDto;

  @ApiPropertyOptional({ description: 'From POST /v1/delivery/slot-holds' })
  @IsOptional()
  @IsUUID()
  slotHoldId?: string;

  @ApiPropertyOptional({ description: 'FR-DLV-06' })
  @IsOptional()
  @IsBoolean()
  callBeforeArrival?: boolean;

  @ApiPropertyOptional({ description: 'FR-CRT-12: confirm on WhatsApp' })
  @IsOptional()
  @IsBoolean()
  whatsappConfirm?: boolean;

  @ApiPropertyOptional({ description: 'FR-CRT-06' })
  @IsOptional()
  @IsString()
  @MaxLength(300)
  notes?: string;

  @ApiProperty({ enum: PAYMENT_METHODS, enumName: 'PaymentMethod' })
  @IsIn(PAYMENT_METHODS)
  paymentMethod!: PaymentMethodValue;
}

export class OrderLineDto {
  @ApiProperty({ type: 'integer' }) position!: number;
  @ApiProperty({ example: 'design' }) kind!: string;
  @ApiProperty({ type: LocalizedTextDto }) title!: LocalizedTextDto;
  @ApiProperty({ type: LocalizedTextDto }) summary!: LocalizedTextDto;
  @ApiProperty({ type: 'integer' }) qty!: number;
  @ApiProperty({ type: 'integer' }) unitPriceMinor!: number;
  @ApiProperty({ type: 'integer' }) totalMinor!: number;
  @ApiPropertyOptional() imageUrl?: string;
}

export class OrderAddressDto {
  @ApiProperty() latitude!: number;
  @ApiProperty() longitude!: number;
  @ApiProperty() label!: string;
  @ApiProperty() area!: string;
  @ApiProperty() landmark!: string;
  @ApiProperty() building!: string;
  @ApiProperty() floor!: string;
  @ApiProperty() details!: string;
}

export class OrderSlotDto {
  @ApiProperty({ example: '2026-11-12' }) date!: string;
  @ApiProperty({ example: '12:00' }) start!: string;
  @ApiProperty({ example: '14:00' }) end!: string;
}

export class StatusEventDto {
  @ApiProperty({ enum: ORDER_STATUSES, enumName: 'OrderStatus' })
  status!: OrderStatusValue;
  @ApiProperty() at!: Date;
}

export class RecipientDto {
  @ApiProperty() name!: string;
  @ApiProperty() phone!: string;
}

export class OrderDto {
  @ApiProperty({ example: 'BB-1001' }) number!: string;
  @ApiProperty({ enum: ORDER_STATUSES, enumName: 'OrderStatus' })
  status!: OrderStatusValue;
  @ApiProperty({ enum: PAYMENT_STATUSES, enumName: 'PaymentStatus' })
  paymentStatus!: (typeof PAYMENT_STATUSES)[number];
  @ApiProperty({ enum: PAYMENT_METHODS, enumName: 'PaymentMethod' })
  paymentMethod!: PaymentMethodValue;
  @ApiProperty({ enum: FULFILLMENTS, enumName: 'Fulfillment' })
  fulfillment!: FulfillmentValue;
  @ApiProperty() createdAt!: Date;
  @ApiProperty({ type: RecipientDto }) recipient!: RecipientDto;
  @ApiProperty() hideSender!: boolean;
  @ApiPropertyOptional({ type: OrderAddressDto }) address?: OrderAddressDto;
  @ApiPropertyOptional({
    type: ZoneDto,
    description: 'The zone and fee when ordered',
  })
  zone?: ZoneDto;
  @ApiProperty({ type: OrderSlotDto }) slot!: OrderSlotDto;
  @ApiProperty() callBeforeArrival!: boolean;
  @ApiProperty() whatsappConfirm!: boolean;
  @ApiProperty() notes!: string;
  @ApiPropertyOptional() couponCode?: string;
  @ApiProperty({ type: [OrderLineDto] }) lines!: OrderLineDto[];
  @ApiProperty({
    type: MoneyBreakdownDto,
    description: 'Fixed when ordered (FR-PAY-06)',
  })
  syp!: MoneyBreakdownDto;
  @ApiProperty({
    type: 'integer',
    description: 'The total in US cents at the fixed rate',
  })
  totalUsdCents!: number;
  @ApiProperty({ example: '120' }) usdRate!: string;
  @ApiProperty({ description: 'FR-ORD-05: the customer may still cancel' })
  canCancel!: boolean;
  @ApiProperty({ type: [StatusEventDto] }) history!: StatusEventDto[];
}

export class OrderSummaryDto {
  @ApiProperty({ example: 'BB-1001' }) number!: string;
  @ApiProperty({ enum: ORDER_STATUSES, enumName: 'OrderStatus' })
  status!: OrderStatusValue;
  @ApiProperty({ enum: FULFILLMENTS, enumName: 'Fulfillment' })
  fulfillment!: FulfillmentValue;
  @ApiProperty() createdAt!: Date;
  @ApiProperty({ type: OrderSlotDto }) slot!: OrderSlotDto;
  @ApiProperty({ type: 'integer' }) totalMinor!: number;
  @ApiProperty({ type: 'integer' }) itemCount!: number;
  @ApiPropertyOptional() imageUrl?: string;
}

export class OrderLookupDto {
  @ApiProperty({ example: 'BB-1001' })
  @Matches(/^BB-\d{4,9}$/i)
  number!: string;

  @ApiProperty({
    example: '0944123456',
    description: "The customer's phone on the order",
  })
  @IsString()
  @MaxLength(32)
  phone!: string;
}

export class CancelOrderDto {
  @ApiPropertyOptional({ description: 'A guest gives the phone on the order' })
  @IsOptional()
  @IsString()
  @MaxLength(32)
  phone?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(300)
  reason?: string;
}

export class StatusChangeDto {
  @ApiProperty({ enum: ORDER_STATUSES, enumName: 'OrderStatus' })
  @IsIn(ORDER_STATUSES)
  to!: OrderStatusValue;

  @ApiPropertyOptional({ description: 'Required to cancel (UC-04 2a)' })
  @IsOptional()
  @IsString()
  @MaxLength(300)
  note?: string;
}

export class AdminOrderDto extends OrderDto {
  @ApiProperty({ type: RecipientDto, description: 'Who ordered' })
  customer!: RecipientDto;
  @ApiProperty({
    type: 'array',
    items: { type: 'string', enum: [...ORDER_STATUSES] },
    description: 'Where this role may move it next',
  })
  next!: OrderStatusValue[];
}
