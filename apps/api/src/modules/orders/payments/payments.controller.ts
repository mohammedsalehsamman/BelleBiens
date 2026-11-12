import { randomUUID } from 'node:crypto';
import type {} from 'multer';
import {
  Body,
  Controller,
  Get,
  Header,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Sse,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiBearerAuth,
  ApiBody,
  ApiConsumes,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiOperation,
  ApiProduces,
  ApiTags,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { map, type Observable } from 'rxjs';
import { MediaStorage } from '../../../adapters/storage/media-storage.js';
import { AppError } from '../../../common/errors/app-error.js';
import {
  type AuthUser,
  CurrentUser,
  Public,
  Roles,
} from '../../accounts/auth/auth.decorators.js';
import { UploadedImageDto } from '../../cart/dto/cart.dto.js';
import { MediaUploadDto } from '../../catalog/dto/admin-catalog.dto.js';
import { processImage } from '../../media/image-processing.js';
import {
  AdminOrderDto,
  OrderDto,
  OwnerDto,
  PaymentProofDto,
  StaffNoteDto,
} from '../dto/order.dto.js';
import { OrderEvents } from '../order-events.js';
import { orderNumber } from '../orders.controller.js';
import { OrdersService } from '../orders.service.js';
import { recipeHtml, slipHtml } from '../print/order-print.js';
import { PaymentsService } from './payments.service.js';

/** Screen 24: "JPG أو PNG · حتى 5 ميغابايت". */
const RECEIPT_MAX_BYTES = 5 * 1024 * 1024;

@ApiTags('orders')
@Controller()
export class OrderPaymentsController {
  constructor(
    private readonly payments: PaymentsService,
    private readonly storage: MediaStorage,
  ) {}

  @Public()
  @Post('orders/:number/payment/proof')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 10, ttl: 60_000 } })
  @ApiOperation({
    summary: 'Send the Sham Cash transaction number or receipt (FR-PAY-03)',
  })
  @ApiOkResponse({ type: OrderDto })
  proof(
    @Param('number') number: string,
    @Body() dto: PaymentProofDto,
    @CurrentUser() user: AuthUser | undefined,
  ): Promise<OrderDto> {
    return this.payments.submitProof(orderNumber(number), dto, user, dto.phone);
  }

  @Public()
  @Post('orders/:number/payment/cash')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 10, ttl: 60_000 } })
  @ApiOperation({ summary: 'Pay on delivery instead (screen 38)' })
  @ApiOkResponse({ type: OrderDto })
  cash(
    @Param('number') number: string,
    @Body() dto: OwnerDto,
    @CurrentUser() user: AuthUser | undefined,
  ): Promise<OrderDto> {
    return this.payments.switchToCash(orderNumber(number), user, dto.phone);
  }

  @Public()
  @Post('uploads/receipt')
  @Throttle({ default: { limit: 10, ttl: 60_000 } })
  @UseInterceptors(
    FileInterceptor('file', {
      limits: { fileSize: RECEIPT_MAX_BYTES, files: 1 },
    }),
  )
  @ApiConsumes('multipart/form-data')
  @ApiBody({ type: MediaUploadDto })
  @ApiOperation({
    summary: 'A Sham Cash receipt photo, checked and re-encoded (NFR-SEC-08)',
  })
  @ApiCreatedResponse({ type: UploadedImageDto })
  async receipt(
    @UploadedFile() file: Express.Multer.File | undefined,
  ): Promise<UploadedImageDto> {
    if (!file) throw new AppError('VALIDATION_FAILED', { detail: 'no file' });
    const image = await processImage(file.buffer, {
      maxBytes: RECEIPT_MAX_BYTES,
    });
    const url = await this.storage.put(
      `receipts/${randomUUID()}.webp`,
      image.bytes,
      image.contentType,
    );
    return { url };
  }
}

const STAFF = ['OWNER', 'MANAGER', 'FLORIST', 'DELIVERY_COORDINATOR'] as const;

/** Listed before the admin orders controller, so "stream" is not an order number. */
@ApiTags('admin')
@ApiBearerAuth()
@Controller('admin/orders')
export class AdminOrderPaymentsController {
  constructor(
    private readonly payments: PaymentsService,
    private readonly orders: OrdersService,
    private readonly events: OrderEvents,
  ) {}

  /** FR-ORD-08: the dashboard hears of new orders at once. */
  @Sse('stream')
  @Roles(...STAFF)
  @ApiOperation({
    summary: 'New orders and status changes, as server-sent events',
  })
  stream(): Observable<{ type: string; data: object }> {
    return this.events.stream.pipe(map((e) => ({ type: e.type, data: e })));
  }

  @Post(':number/payment/confirm')
  @HttpCode(HttpStatus.OK)
  @Roles('OWNER', 'MANAGER')
  @ApiOperation({
    summary:
      'The Sham Cash money arrived: paid, and the order confirmed (audited)',
  })
  @ApiOkResponse({ type: AdminOrderDto })
  confirm(
    @CurrentUser() actor: AuthUser,
    @Param('number') number: string,
  ): Promise<AdminOrderDto> {
    return this.payments.confirm(orderNumber(number), actor);
  }

  @Post(':number/payment/reject')
  @HttpCode(HttpStatus.OK)
  @Roles('OWNER', 'MANAGER')
  @ApiOperation({
    summary: 'The receipt does not match; tell the customer why',
  })
  @ApiOkResponse({ type: AdminOrderDto })
  reject(
    @CurrentUser() actor: AuthUser,
    @Param('number') number: string,
    @Body() dto: StaffNoteDto,
  ): Promise<AdminOrderDto> {
    return this.payments.reject(orderNumber(number), actor, dto.note);
  }

  @Post(':number/payment/refund')
  @HttpCode(HttpStatus.OK)
  @Roles('OWNER', 'MANAGER')
  @ApiOperation({ summary: 'Record a refund with its reason (FR-PAY-11)' })
  @ApiOkResponse({ type: AdminOrderDto })
  refund(
    @CurrentUser() actor: AuthUser,
    @Param('number') number: string,
    @Body() dto: StaffNoteDto,
  ): Promise<AdminOrderDto> {
    return this.payments.refund(orderNumber(number), actor, dto.note);
  }

  @Get(':number/recipe')
  @Roles(...STAFF)
  @Header('Content-Type', 'text/html; charset=utf-8')
  @ApiProduces('text/html')
  @ApiOperation({ summary: "The florist's recipe, A4 (FR-DSG-16)" })
  @ApiOkResponse({ description: 'HTML to print', schema: { type: 'string' } })
  async recipe(@Param('number') number: string): Promise<string> {
    const { order, names } = await this.orders.printData(orderNumber(number));
    return recipeHtml(order, names);
  }

  @Get(':number/slip')
  @Roles(...STAFF)
  @Header('Content-Type', 'text/html; charset=utf-8')
  @ApiProduces('text/html')
  @ApiOperation({ summary: 'The order slip for an 80 mm printer (UC-04)' })
  @ApiOkResponse({ description: 'HTML to print', schema: { type: 'string' } })
  async slip(@Param('number') number: string): Promise<string> {
    const { order } = await this.orders.printData(orderNumber(number));
    return slipHtml(order);
  }
}
