import {
  Body,
  Controller,
  Get,
  Headers,
  HttpCode,
  HttpStatus,
  Ip,
  Param,
  Patch,
  Post,
  Query,
  Res,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiHeader,
  ApiOkResponse,
  ApiOperation,
  ApiPropertyOptional,
  ApiTags,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { IsIn, IsOptional, Matches } from 'class-validator';
import type { Response } from 'express';
import { AppError } from '../../common/errors/app-error.js';
import {
  type AuthUser,
  CurrentUser,
  Public,
  Roles,
} from '../accounts/auth/auth.decorators.js';
import { DATE } from '../delivery/dto/delivery.dto.js';
import {
  AdminOrderDto,
  CancelOrderDto,
  CreateOrderDto,
  ORDER_STATUSES,
  OrderDto,
  OrderLookupDto,
  type OrderStatusValue,
  OrderSummaryDto,
  StatusChangeDto,
} from './dto/order.dto.js';
import { OrdersService } from './orders.service.js';

const KEY = /^[A-Za-z0-9_-]{8,100}$/;
const NUMBER = /^BB-\d{4,9}$/i;

function orderNumber(value: string): string {
  if (!NUMBER.test(value)) throw new AppError('NOT_FOUND', { detail: value });
  return value.toUpperCase();
}

@ApiTags('orders')
@Controller('orders')
export class OrdersController {
  constructor(private readonly orders: OrdersService) {}

  /** UC-01 step 7. Guests and customers; prices and stock from the server only. */
  @Public()
  @Post()
  @Throttle({ default: { limit: 20, ttl: 60_000 } })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: true,
    description:
      'Made by the app for this checkout; a retry sends the same one (FR-CRT-10)',
  })
  @ApiOperation({
    summary: 'Place an order: zone, slot, stock and coupon are checked at once',
  })
  @ApiCreatedResponse({ type: OrderDto })
  async create(
    @Body() dto: CreateOrderDto,
    @Headers('idempotency-key') key: string | undefined,
    @CurrentUser() user: AuthUser | undefined,
    @Ip() ip: string,
    @Res({ passthrough: true }) res: Response,
  ): Promise<OrderDto> {
    if (!key || !KEY.test(key)) {
      throw new AppError('VALIDATION_FAILED', {
        detail: 'Idempotency-Key header: 8 to 100 letters, digits, - or _',
      });
    }
    const { status, body } = await this.orders.place(dto, key, user, ip);
    res.status(status);
    return body;
  }

  @Public()
  @Post('lookup')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 10, ttl: 60_000 } })
  @ApiOperation({
    summary: 'A guest finds an order by number and phone (FR-ORD-04)',
  })
  @ApiOkResponse({ type: OrderDto })
  lookup(@Body() dto: OrderLookupDto): Promise<OrderDto> {
    return this.orders.lookup(dto.number, dto.phone);
  }

  @ApiBearerAuth()
  @Get(':number')
  @ApiOperation({ summary: 'One of my orders' })
  @ApiOkResponse({ type: OrderDto })
  get(
    @Param('number') number: string,
    @CurrentUser() user: AuthUser,
  ): Promise<OrderDto> {
    return this.orders.forUser(orderNumber(number), user);
  }

  @Public()
  @Post(':number/cancel')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 10, ttl: 60_000 } })
  @ApiOperation({
    summary:
      'Cancel before the shop confirms (FR-ORD-05); a guest gives the phone',
  })
  @ApiOkResponse({ type: OrderDto })
  cancel(
    @Param('number') number: string,
    @Body() dto: CancelOrderDto,
    @CurrentUser() user: AuthUser | undefined,
  ): Promise<OrderDto> {
    return this.orders.cancelByCustomer(
      orderNumber(number),
      user,
      dto.phone,
      dto.reason,
    );
  }
}

@ApiTags('me')
@ApiBearerAuth()
@Controller('me/orders')
export class MyOrdersController {
  constructor(private readonly orders: OrdersService) {}

  @Get()
  @ApiOperation({ summary: 'My orders, newest first (screen 26)' })
  @ApiOkResponse({ type: [OrderSummaryDto] })
  list(@CurrentUser() user: AuthUser): Promise<OrderSummaryDto[]> {
    return this.orders.mine(user.id);
  }
}

class AdminOrdersQueryDto {
  @ApiPropertyOptional({ enum: ORDER_STATUSES, enumName: 'OrderStatus' })
  @IsOptional()
  @IsIn(ORDER_STATUSES)
  status?: OrderStatusValue;

  @ApiPropertyOptional({
    example: '2026-11-12',
    description: 'Delivery or pickup day',
  })
  @IsOptional()
  @Matches(DATE)
  date?: string;
}

@ApiTags('admin')
@ApiBearerAuth()
@Controller('admin/orders')
export class AdminOrdersController {
  constructor(private readonly orders: OrdersService) {}

  @Get()
  @Roles('OWNER', 'MANAGER', 'FLORIST', 'DELIVERY_COORDINATOR')
  @ApiOperation({ summary: 'Orders by day and status, in slot order (UC-04)' })
  @ApiOkResponse({ type: [AdminOrderDto] })
  list(
    @CurrentUser() user: AuthUser,
    @Query() q: AdminOrdersQueryDto,
  ): Promise<AdminOrderDto[]> {
    return this.orders.listForStaff(user.role, q);
  }

  @Get(':number')
  @Roles('OWNER', 'MANAGER', 'FLORIST', 'DELIVERY_COORDINATOR')
  @ApiOperation({ summary: 'One order, and where this role may move it' })
  @ApiOkResponse({ type: AdminOrderDto })
  get(
    @CurrentUser() user: AuthUser,
    @Param('number') number: string,
  ): Promise<AdminOrderDto> {
    return this.orders.forStaff(orderNumber(number), user.role);
  }

  @Patch(':number/status')
  @Roles('OWNER', 'MANAGER', 'FLORIST', 'DELIVERY_COORDINATOR')
  @ApiOperation({
    summary: 'Move an order on (FR-ORD-02/03); cancelling gives the stock back',
  })
  @ApiOkResponse({ type: AdminOrderDto })
  status(
    @CurrentUser() user: AuthUser,
    @Param('number') number: string,
    @Body() dto: StatusChangeDto,
  ): Promise<AdminOrderDto> {
    return this.orders.advance(orderNumber(number), dto.to, user, dto.note);
  }
}
