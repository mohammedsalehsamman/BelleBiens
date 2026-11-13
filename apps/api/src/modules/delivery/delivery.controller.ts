import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiProperty,
  ApiPropertyOptional,
  ApiTags,
} from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsIn, IsInt, IsOptional, Matches, Max, Min } from 'class-validator';
import { Throttle } from '@nestjs/throttler';
import { AppError } from '../../common/errors/app-error.js';
import type { Address, Prisma } from '../../generated/prisma/client.js';
import { PrismaService } from '../../infra/prisma/prisma.service.js';
import {
  type AuthUser,
  CurrentUser,
  Public,
  Roles,
} from '../accounts/auth/auth.decorators.js';
import { AuditService } from '../audit/audit.service.js';
import { SettingsService } from '../settings/settings.service.js';
import { DeliveryService, toZoneDto } from './delivery.service.js';
import type { LngLat } from './domain/delivery-rules.js';
import {
  AddressDto,
  AddressInputDto,
  AdminZoneDto,
  DATE,
  DaySlotsDto,
  DeliveryCalendarDto,
  DeliverySettingsDto,
  FULFILLMENTS,
  type FulfillmentValue,
  PointDto,
  ShopModeDto,
  SlotHoldDto,
  SlotHoldRequestDto,
  ZoneCheckDto,
  ZoneInputDto,
  ZoneWithAreaDto,
} from './dto/delivery.dto.js';

class CalendarQueryDto {
  @ApiPropertyOptional({
    type: 'integer',
    description: 'The longest lead time in the cart (FR-DLV-05)',
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  @Max(24 * 60)
  leadTimeHours?: number;

  @ApiPropertyOptional({ enum: FULFILLMENTS, enumName: 'Fulfillment' })
  @IsOptional()
  @IsIn(FULFILLMENTS)
  fulfillment?: FulfillmentValue;
}

class SlotsQueryDto extends CalendarQueryDto {
  @ApiProperty({ example: '2026-11-12' })
  @Matches(DATE)
  date!: string;
}

@ApiTags('delivery')
@Controller('delivery')
export class DeliveryController {
  constructor(private readonly delivery: DeliveryService) {}

  @Public()
  @Get('zones')
  @ApiOperation({
    summary: 'The areas the shop delivers to, for the map (screen 22)',
  })
  @ApiOkResponse({ type: [ZoneWithAreaDto] })
  zones(): Promise<ZoneWithAreaDto[]> {
    return this.delivery.zones();
  }

  @Public()
  @Post('zone-check')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 60, ttl: 60_000 } })
  @ApiOperation({
    summary: 'Is this pin inside a zone, and its fee (FR-DLV-01/02)',
  })
  @ApiOkResponse({ type: ZoneCheckDto })
  async zoneCheck(@Body() dto: PointDto): Promise<ZoneCheckDto> {
    const zone = await this.delivery.zoneAt(dto.latitude, dto.longitude);
    return zone ? { inZone: true, zone: toZoneDto(zone) } : { inZone: false };
  }

  @Public()
  @Get('dates')
  @ApiOperation({
    summary:
      'Today to 60 days ahead, and which days have a free slot (FR-DLV-03/05/09)',
  })
  @ApiOkResponse({ type: DeliveryCalendarDto })
  dates(@Query() q: CalendarQueryDto): Promise<DeliveryCalendarDto> {
    return this.delivery.calendar(
      q.leadTimeHours ?? 0,
      q.fulfillment ?? 'DELIVERY',
    );
  }

  @Public()
  @Get('slots')
  @ApiOperation({
    summary: "A day's time slots and why some cannot be chosen (FR-DLV-04)",
  })
  @ApiOkResponse({ type: DaySlotsDto })
  slots(@Query() q: SlotsQueryDto): Promise<DaySlotsDto> {
    return this.delivery.slots(
      q.date,
      q.leadTimeHours ?? 0,
      q.fulfillment ?? 'DELIVERY',
    );
  }

  @Public()
  @Post('slot-holds')
  @Throttle({ default: { limit: 20, ttl: 60_000 } })
  @ApiOperation({
    summary:
      'Keep a place in a slot for a few minutes while the customer pays (FR-DLV-04)',
  })
  @ApiCreatedResponse({ type: SlotHoldDto })
  hold(@Body() dto: SlotHoldRequestDto): Promise<SlotHoldDto> {
    return this.delivery.hold(dto.date, dto.start, dto.leadTimeHours ?? 0);
  }
}

// ---------- saved addresses (FR-ACC-04) ----------

@ApiTags('me')
@ApiBearerAuth()
@Controller('me/addresses')
export class AddressesController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly delivery: DeliveryService,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Saved addresses, each with its zone today' })
  @ApiOkResponse({ type: [AddressDto] })
  async list(@CurrentUser() user: AuthUser): Promise<AddressDto[]> {
    const rows = await this.prisma.address.findMany({
      where: { userId: user.id },
      orderBy: [{ isDefault: 'desc' }, { createdAt: 'asc' }],
    });
    return Promise.all(rows.map((r) => this.toDto(r)));
  }

  @Post()
  @ApiOperation({ summary: 'Save an address (screen 22 "احفظ العنوان")' })
  @ApiCreatedResponse({ type: AddressDto })
  async create(
    @CurrentUser() user: AuthUser,
    @Body() dto: AddressInputDto,
  ): Promise<AddressDto> {
    const count = await this.prisma.address.count({
      where: { userId: user.id },
    });
    if (count >= 20) {
      throw new AppError('VALIDATION_FAILED', {
        detail: 'at most 20 addresses',
      });
    }
    const fields = await this.fields(dto);
    // The first address is the default one.
    const isDefault = count === 0 || dto.isDefault === true;
    const row = await this.prisma.$transaction(async (tx) => {
      if (isDefault) await this.clearDefault(tx, user.id);
      return tx.address.create({
        data: { userId: user.id, ...fields, isDefault },
      });
    });
    return this.toDto(row);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Change a saved address' })
  @ApiOkResponse({ type: AddressDto })
  async update(
    @CurrentUser() user: AuthUser,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: AddressInputDto,
  ): Promise<AddressDto> {
    await this.own(user, id);
    const fields = await this.fields(dto);
    const row = await this.prisma.$transaction(async (tx) => {
      if (dto.isDefault === true) await this.clearDefault(tx, user.id);
      return tx.address.update({
        where: { id },
        data: {
          ...fields,
          ...(dto.isDefault === true ? { isDefault: true } : {}),
        },
      });
    });
    return this.toDto(row);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Remove a saved address' })
  @ApiNoContentResponse()
  async remove(
    @CurrentUser() user: AuthUser,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<void> {
    await this.own(user, id);
    await this.prisma.$transaction(async (tx) => {
      const removed = await tx.address.delete({ where: { id } });
      // Another address takes over as the default.
      if (removed.isDefault) {
        const next = await tx.address.findFirst({
          where: { userId: user.id },
          orderBy: { createdAt: 'asc' },
        });
        if (next) {
          await tx.address.update({
            where: { id: next.id },
            data: { isDefault: true },
          });
        }
      }
    });
  }

  private async clearDefault(
    tx: Prisma.TransactionClient,
    userId: string,
  ): Promise<void> {
    await tx.address.updateMany({
      where: { userId, isDefault: true },
      data: { isDefault: false },
    });
  }

  private async own(user: AuthUser, id: string): Promise<void> {
    const row = await this.prisma.address.findUnique({ where: { id } });
    if (!row || row.userId !== user.id) {
      throw new AppError('NOT_FOUND', { detail: `address ${id}` });
    }
  }

  private async fields(dto: AddressInputDto) {
    const zone = await this.delivery.zoneAt(dto.latitude, dto.longitude);
    return {
      label: dto.label.trim(),
      latitude: dto.latitude,
      longitude: dto.longitude,
      zoneSlug: zone?.slug ?? null,
      area: dto.area?.trim() ?? '',
      landmark: dto.landmark?.trim() ?? '',
      building: dto.building?.trim() ?? '',
      floor: dto.floor?.trim() ?? '',
      details: dto.details?.trim() ?? '',
      callBeforeArrival: dto.callBeforeArrival ?? false,
    };
  }

  /** Zones can change after an address is saved, so it is checked again. */
  private async toDto(row: Address): Promise<AddressDto> {
    const zone = await this.delivery.zoneAt(row.latitude, row.longitude);
    return {
      id: row.id,
      label: row.label,
      latitude: row.latitude,
      longitude: row.longitude,
      area: row.area,
      landmark: row.landmark,
      building: row.building,
      floor: row.floor,
      details: row.details,
      isDefault: row.isDefault,
      callBeforeArrival: row.callBeforeArrival,
      ...(zone ? { zone: toZoneDto(zone) } : {}),
    };
  }
}

// ---------- the shop's side ----------

@ApiTags('admin')
@ApiBearerAuth()
@Controller('admin')
export class AdminDeliveryController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
    private readonly settings: SettingsService,
  ) {}

  @Get('delivery/zones')
  @Roles('OWNER', 'MANAGER', 'DELIVERY_COORDINATOR')
  @ApiOperation({ summary: 'Every zone, switched off ones too (FR-DLV-02)' })
  @ApiOkResponse({ type: [AdminZoneDto] })
  async zones(): Promise<AdminZoneDto[]> {
    const rows = await this.prisma.deliveryZone.findMany({
      orderBy: [{ sortOrder: 'asc' }, { slug: 'asc' }],
    });
    return rows.map(toAdminZone);
  }

  @Put('delivery/zones/:slug')
  @Roles('OWNER', 'MANAGER')
  @ApiOperation({ summary: 'Add or change a zone: area, fee, time (audited)' })
  @ApiOkResponse({ type: AdminZoneDto })
  async putZone(
    @CurrentUser() actor: AuthUser,
    @Param('slug') slug: string,
    @Body() dto: ZoneInputDto,
  ): Promise<AdminZoneDto> {
    if (dto.slug !== slug) {
      throw new AppError('VALIDATION_FAILED', {
        detail: 'slug does not match the path',
      });
    }
    const polygon = checkPolygon(dto.polygon);
    const data = {
      nameAr: dto.nameAr,
      nameEn: dto.nameEn,
      polygon: polygon as unknown as Prisma.InputJsonValue,
      feeMinor: dto.feeMinor,
      etaAr: dto.etaAr ?? '',
      etaEn: dto.etaEn ?? '',
      active: dto.active ?? true,
      sortOrder: dto.sortOrder ?? 0,
    };
    return this.prisma.$transaction(async (tx) => {
      const before = await tx.deliveryZone.findUnique({ where: { slug } });
      const row = await tx.deliveryZone.upsert({
        where: { slug },
        update: data,
        create: { slug, ...data },
      });
      await this.audit.record(
        {
          actor,
          action: before ? 'delivery.zone.update' : 'delivery.zone.create',
          entity: 'delivery_zone',
          entityId: row.id,
          ...(before
            ? { before: { feeMinor: before.feeMinor, active: before.active } }
            : {}),
          after: { feeMinor: row.feeMinor, active: row.active },
        },
        tx,
      );
      return toAdminZone(row);
    });
  }

  @Get('settings/delivery')
  @Roles('OWNER', 'MANAGER', 'DELIVERY_COORDINATOR')
  @ApiOperation({ summary: 'Slots, closed days and the booking window' })
  @ApiOkResponse({ type: DeliverySettingsDto })
  async deliverySettings(): Promise<DeliverySettingsDto> {
    const [slots, closedDays, windowDays, slotHoldMinutes] = await Promise.all([
      this.settings.get('delivery.slots'),
      this.settings.get('delivery.closedDays'),
      this.settings.get('delivery.windowDays'),
      this.settings.get('delivery.slotHoldMinutes'),
    ]);
    return { slots, closedDays, windowDays, slotHoldMinutes };
  }

  @Put('settings/delivery')
  @Roles('OWNER', 'MANAGER')
  @ApiOperation({
    summary: 'Change slots and capacity, closed days, the window (audited)',
  })
  @ApiOkResponse({ type: DeliverySettingsDto })
  async putDeliverySettings(
    @CurrentUser() actor: AuthUser,
    @Body() dto: DeliverySettingsDto,
  ): Promise<DeliverySettingsDto> {
    const slots = dto.slots.map((s) => ({
      start: s.start,
      end: s.end,
      capacity: s.capacity,
    }));
    if (slots.some((s) => s.end <= s.start)) {
      throw new AppError('VALIDATION_FAILED', {
        detail: 'a slot ends before it starts',
      });
    }
    if (new Set(slots.map((s) => s.start)).size !== slots.length) {
      throw new AppError('VALIDATION_FAILED', {
        detail: 'two slots start at the same time',
      });
    }
    slots.sort((a, b) => a.start.localeCompare(b.start));
    const closedDays = [...new Set(dto.closedDays)].sort();
    const before = await this.deliverySettings();
    await this.prisma.$transaction(async (tx) => {
      await this.settings.set('delivery.slots', slots, actor.id, tx);
      await this.settings.set('delivery.closedDays', closedDays, actor.id, tx);
      await this.settings.set(
        'delivery.windowDays',
        dto.windowDays,
        actor.id,
        tx,
      );
      await this.settings.set(
        'delivery.slotHoldMinutes',
        dto.slotHoldMinutes,
        actor.id,
        tx,
      );
      await this.audit.record(
        {
          actor,
          action: 'setting.update',
          entity: 'setting',
          entityId: 'delivery',
          before: before as unknown as Prisma.InputJsonValue,
          after: { slots, closedDays, windowDays: dto.windowDays },
        },
        tx,
      );
    });
    this.settings.invalidate();
    return {
      slots,
      closedDays,
      windowDays: dto.windowDays,
      slotHoldMinutes: dto.slotHoldMinutes,
    };
  }

  @Put('settings/shop-mode')
  @Roles('OWNER', 'MANAGER')
  @ApiOperation({
    summary:
      'Open, busy (today only from a time) or closed, with a message (FR-ADM-12)',
  })
  @ApiOkResponse({ type: ShopModeDto })
  async shopMode(
    @CurrentUser() actor: AuthUser,
    @Body() dto: ShopModeDto,
  ): Promise<ShopModeDto> {
    if (dto.mode === 'busy' && !dto.acceptsFrom) {
      throw new AppError('VALIDATION_FAILED', {
        detail: 'busy mode needs acceptsFrom',
      });
    }
    const before = await this.settings.get('shop.mode');
    const message = dto.mode === 'open' ? null : (dto.message ?? null);
    const acceptsFrom = dto.mode === 'busy' ? dto.acceptsFrom! : null;
    await this.prisma.$transaction(async (tx) => {
      await this.settings.set('shop.mode', dto.mode, actor.id, tx);
      await this.settings.set(
        'shop.busyMessage',
        message ? { ar: message.ar, en: message.en } : null,
        actor.id,
        tx,
      );
      await this.settings.set(
        'shop.busyAcceptsFrom',
        acceptsFrom,
        actor.id,
        tx,
      );
      await this.audit.record(
        {
          actor,
          action: 'shop.mode.change',
          entity: 'setting',
          entityId: 'shop.mode',
          before: { mode: before },
          after: { mode: dto.mode, acceptsFrom },
        },
        tx,
      );
    });
    this.settings.invalidate();
    return {
      mode: dto.mode,
      ...(message ? { message } : {}),
      ...(acceptsFrom ? { acceptsFrom } : {}),
    };
  }
}

function toAdminZone(row: {
  id: string;
  slug: string;
  nameAr: string;
  nameEn: string;
  polygon: unknown;
  feeMinor: number;
  etaAr: string;
  etaEn: string;
  active: boolean;
  sortOrder: number;
}): AdminZoneDto {
  return Object.assign(toZoneDto(row as Parameters<typeof toZoneDto>[0]), {
    id: row.id,
    polygon: row.polygon as number[][],
    active: row.active,
    sortOrder: row.sortOrder,
  });
}

/** Corners must be [longitude, latitude] pairs on Earth. */
function checkPolygon(points: number[][]): LngLat[] {
  const ok = points.every(
    (p) =>
      Array.isArray(p) &&
      p.length === 2 &&
      p.every((n) => typeof n === 'number' && Number.isFinite(n)) &&
      Math.abs(p[0]!) <= 180 &&
      Math.abs(p[1]!) <= 90,
  );
  if (!ok) {
    throw new AppError('VALIDATION_FAILED', {
      detail: 'polygon must be [longitude, latitude] pairs',
    });
  }
  return points as LngLat[];
}
