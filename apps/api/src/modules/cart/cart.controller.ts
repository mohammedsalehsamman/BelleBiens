import { randomUUID } from 'node:crypto';
import type {} from 'multer';
import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Ip,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Put,
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
  ApiTags,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { MediaStorage } from '../../adapters/storage/media-storage.js';
import { AppError } from '../../common/errors/app-error.js';
import { PrismaService } from '../../infra/prisma/prisma.service.js';
import {
  type AuthUser,
  CurrentUser,
  Public,
  Roles,
} from '../accounts/auth/auth.decorators.js';
import { AuditService } from '../audit/audit.service.js';
import { MediaUploadDto } from '../catalog/dto/admin-catalog.dto.js';
import { processImage } from '../media/image-processing.js';
import { CartService } from './cart.service.js';
import {
  BoxCatalogDto,
  CartDto,
  CartQuoteDto,
  CartQuoteRequestDto,
  CouponDto,
  CouponInputDto,
  SaveCartDto,
  UploadedImageDto,
} from './dto/cart.dto.js';

/** A reference photo for a cake (FR-CKE-04): a phone photo, re-encoded. */
const REFERENCE_MAX_BYTES = 8 * 1024 * 1024;

@ApiTags('cart')
@Controller()
export class CartController {
  constructor(
    private readonly cart: CartService,
    private readonly storage: MediaStorage,
  ) {}

  /** Guests and customers alike; the app keeps the lines (FR-CRT-03). */
  @Public()
  @Post('cart/quote')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary:
      'Price a cart: lines, coupon, totals in SYP and USD, earliest time (FR-CRT-05..08)',
  })
  @ApiOkResponse({ type: CartQuoteDto })
  quote(
    @Body() dto: CartQuoteRequestDto,
    @Ip() ip: string,
  ): Promise<CartQuoteDto> {
    return this.cart.quote(dto, ip);
  }

  @Public()
  @Get('boxes/catalog')
  @ApiOperation({
    summary: 'Box types and what can go in them (screen 19, FR-BOX-01/02)',
  })
  @ApiOkResponse({ type: BoxCatalogDto })
  boxes(): Promise<BoxCatalogDto> {
    return this.cart.boxCatalog();
  }

  @Public()
  @Post('uploads/reference-image')
  @Throttle({ default: { limit: 10, ttl: 60_000 } })
  @UseInterceptors(
    FileInterceptor('file', {
      limits: { fileSize: REFERENCE_MAX_BYTES, files: 1 },
    }),
  )
  @ApiConsumes('multipart/form-data')
  @ApiBody({ type: MediaUploadDto })
  @ApiOperation({ summary: 'A photo of the cake design wanted (FR-CKE-04)' })
  @ApiCreatedResponse({ type: UploadedImageDto })
  async referenceImage(
    @UploadedFile() file: Express.Multer.File | undefined,
  ): Promise<UploadedImageDto> {
    if (!file) throw new AppError('VALIDATION_FAILED', { detail: 'no file' });
    const image = await processImage(file.buffer, {
      maxBytes: REFERENCE_MAX_BYTES,
    });
    const url = await this.storage.put(
      `references/${randomUUID()}.webp`,
      image.bytes,
      image.contentType,
    );
    return { url };
  }
}

@ApiTags('me')
@ApiBearerAuth()
@Controller('me/cart')
export class SavedCartController {
  constructor(private readonly cart: CartService) {}

  @Get()
  @ApiOperation({ summary: 'The cart kept for this account (FR-CRT-03)' })
  @ApiOkResponse({ type: CartDto })
  get(@CurrentUser() user: AuthUser): Promise<CartDto> {
    return this.cart.savedCart(user.id);
  }

  @Put()
  @ApiOperation({ summary: 'Replace the saved cart (the app merges first)' })
  @ApiOkResponse({ type: CartDto })
  put(
    @CurrentUser() user: AuthUser,
    @Body() dto: SaveCartDto,
  ): Promise<CartDto> {
    return this.cart.saveCart(user.id, dto.lines);
  }
}

@ApiTags('admin')
@ApiBearerAuth()
@Controller('admin/coupons')
export class AdminCouponsController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  @Get()
  @Roles('OWNER', 'MANAGER')
  @ApiOperation({ summary: 'Discount codes (FR-CRT-07)' })
  @ApiOkResponse({ type: [CouponDto] })
  async list(): Promise<CouponDto[]> {
    const rows = await this.prisma.coupon.findMany({
      orderBy: { createdAt: 'desc' },
    });
    return rows.map(toCouponDto);
  }

  @Post()
  @Roles('OWNER', 'MANAGER')
  @ApiOperation({ summary: 'Add a discount code (audited)' })
  @ApiCreatedResponse({ type: CouponDto })
  async create(
    @CurrentUser() actor: AuthUser,
    @Body() dto: CouponInputDto,
  ): Promise<CouponDto> {
    if (dto.type === 'PERCENT' && dto.value > 100) {
      throw new AppError('VALIDATION_FAILED', { detail: 'percent above 100' });
    }
    const code = dto.code.toUpperCase();
    if (await this.prisma.coupon.findUnique({ where: { code } })) {
      throw new AppError('CONFLICT', { detail: `code ${code} exists` });
    }
    return this.prisma.$transaction(async (tx) => {
      const row = await tx.coupon.create({ data: couponData(dto) });
      await this.audit.record(
        {
          actor,
          action: 'coupon.create',
          entity: 'coupon',
          entityId: row.id,
          after: { code, type: row.type, value: row.value },
        },
        tx,
      );
      return toCouponDto(row);
    });
  }

  @Patch(':id')
  @Roles('OWNER', 'MANAGER')
  @ApiOperation({ summary: 'Change or switch off a discount code (audited)' })
  @ApiOkResponse({ type: CouponDto })
  async update(
    @CurrentUser() actor: AuthUser,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: CouponInputDto,
  ): Promise<CouponDto> {
    const before = await this.prisma.coupon.findUnique({ where: { id } });
    if (!before) throw new AppError('NOT_FOUND', { detail: `coupon ${id}` });
    return this.prisma.$transaction(async (tx) => {
      const row = await tx.coupon.update({
        where: { id },
        data: couponData(dto),
      });
      await this.audit.record(
        {
          actor,
          action: 'coupon.update',
          entity: 'coupon',
          entityId: id,
          before: { value: before.value, active: before.active },
          after: { value: row.value, active: row.active },
        },
        tx,
      );
      return toCouponDto(row);
    });
  }
}

function toCouponDto(row: {
  id: string;
  code: string;
  type: 'PERCENT' | 'FIXED';
  value: number;
  minOrderMinor: number;
  startsAt: Date | null;
  endsAt: Date | null;
  maxRedemptions: number | null;
  redemptions: number;
  active: boolean;
}): CouponDto {
  return {
    id: row.id,
    code: row.code,
    type: row.type,
    value: row.value,
    minOrderMinor: row.minOrderMinor,
    startsAt: row.startsAt ?? undefined,
    endsAt: row.endsAt ?? undefined,
    maxRedemptions: row.maxRedemptions ?? undefined,
    redemptions: row.redemptions,
    active: row.active,
  };
}

/** The stored fields of a coupon; codes are kept upper-case. */
function couponData(dto: CouponInputDto) {
  return {
    code: dto.code.toUpperCase(),
    type: dto.type,
    value: dto.value,
    minOrderMinor: dto.minOrderMinor ?? 0,
    startsAt: dto.startsAt ?? null,
    endsAt: dto.endsAt ?? null,
    maxRedemptions: dto.maxRedemptions ?? null,
    active: dto.active ?? true,
  };
}
