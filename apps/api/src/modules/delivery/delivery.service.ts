import { Injectable } from '@nestjs/common';
import { DateTime } from 'luxon';
import { Clock, SHOP_TIME_ZONE } from '../../common/clock/clock.js';
import { AppError } from '../../common/errors/app-error.js';
import type { DeliveryZone, Prisma } from '../../generated/prisma/client.js';
import { PrismaService } from '../../infra/prisma/prisma.service.js';
import { text } from '../catalog/catalog.mapper.js';
import { SettingsService } from '../settings/settings.service.js';
import {
  type CalendarSettings,
  daySlots,
  type LngLat,
  pointInPolygon,
  type SlotState,
} from './domain/delivery-rules.js';
import type {
  DaySlotsDto,
  DeliveryCalendarDto,
  FulfillmentValue,
  DeliverySlotDto,
  SlotHoldDto,
  ZoneDto,
  ZoneWithAreaDto,
} from './dto/delivery.dto.js';

/** A @db.Date value for a YYYY-MM-DD shop date. */
export function dateValue(date: string): Date {
  return new Date(`${date}T00:00:00.000Z`);
}

export function dateString(value: Date): string {
  return value.toISOString().slice(0, 10);
}

export function toZoneDto(zone: DeliveryZone): ZoneDto {
  return {
    slug: zone.slug,
    name: text(zone.nameAr, zone.nameEn),
    feeMinor: zone.feeMinor,
    eta: text(zone.etaAr, zone.etaEn),
  };
}

/** Orders that hold a place in a slot: every one not cancelled. */
const HOLDING: Prisma.OrderWhereInput = {
  fulfillment: 'DELIVERY',
  status: { not: 'CANCELLED' },
};

/**
 * Zones, the delivery calendar and slot holds (FR-DLV-01..05, 09).
 * Pickup uses the same calendar without slot capacity: the branch has no
 * driver to share.
 */
@Injectable()
export class DeliveryService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
    private readonly settings: SettingsService,
  ) {}

  // ---------- zones ----------

  async zones(): Promise<ZoneWithAreaDto[]> {
    const rows = await this.prisma.deliveryZone.findMany({
      where: { active: true },
      orderBy: [{ sortOrder: 'asc' }, { slug: 'asc' }],
    });
    return rows.map((z) =>
      Object.assign(toZoneDto(z), { polygon: z.polygon as number[][] }),
    );
  }

  /** FR-DLV-01: the active zone the pin falls in; the first by sort order wins. */
  async zoneAt(
    latitude: number,
    longitude: number,
  ): Promise<DeliveryZone | null> {
    const rows = await this.prisma.deliveryZone.findMany({
      where: { active: true },
      orderBy: [{ sortOrder: 'asc' }, { slug: 'asc' }],
    });
    return (
      rows.find((z) =>
        pointInPolygon([longitude, latitude], z.polygon as LngLat[]),
      ) ?? null
    );
  }

  // ---------- the calendar ----------

  async calendarSettings(): Promise<
    CalendarSettings & { holdMinutes: number }
  > {
    const [
      hours,
      slots,
      closedDays,
      windowDays,
      mode,
      busyAcceptsFrom,
      holdMinutes,
    ] = await Promise.all([
      this.settings.get('shop.workingHours'),
      this.settings.get('delivery.slots'),
      this.settings.get('delivery.closedDays'),
      this.settings.get('delivery.windowDays'),
      this.settings.get('shop.mode'),
      this.settings.get('shop.busyAcceptsFrom'),
      this.settings.get('delivery.slotHoldMinutes'),
    ]);
    return {
      hours,
      slots,
      closedDays,
      windowDays,
      mode,
      busyAcceptsFrom,
      holdMinutes,
    };
  }

  /**
   * Places taken per "date start": orders, and other customers' holds that
   * have not run out. `exceptHold` is the caller's own hold.
   */
  async taken(
    from: string,
    to: string,
    exceptHold?: string,
    tx: Prisma.TransactionClient = this.prisma,
  ): Promise<Map<string, number>> {
    const range = { gte: dateValue(from), lte: dateValue(to) };
    const [orders, holds] = await Promise.all([
      tx.order.groupBy({
        by: ['slotDate', 'slotStart'],
        where: { ...HOLDING, slotDate: range },
        _count: { _all: true },
      }),
      tx.slotHold.groupBy({
        by: ['date', 'start'],
        where: {
          date: range,
          expiresAt: { gt: this.clock.now() },
          ...(exceptHold ? { id: { not: exceptHold } } : {}),
        },
        _count: { _all: true },
      }),
    ]);
    const counts = new Map<string, number>();
    const add = (date: Date, start: string, n: number) => {
      const key = `${dateString(date)} ${start}`;
      counts.set(key, (counts.get(key) ?? 0) + n);
    };
    for (const o of orders) add(o.slotDate, o.slotStart, o._count._all);
    for (const h of holds) add(h.date, h.start, h._count._all);
    return counts;
  }

  private today(): DateTime {
    return this.clock.nowInShopZone().startOf('day');
  }

  /** FR-DLV-03: today to the end of the booking window, and which days have a slot. */
  async calendar(
    leadTimeHours: number,
    fulfillment: FulfillmentValue,
  ): Promise<DeliveryCalendarDto> {
    const settings = await this.calendarSettings();
    const today = this.today();
    const last = today.plus({ days: settings.windowDays });
    const taken = await this.taken(today.toISODate()!, last.toISODate()!);
    const days = [];
    for (let i = 0; i <= settings.windowDays; i += 1) {
      const date = today.plus({ days: i }).toISODate()!;
      const slots = this.slotsOf(
        date,
        leadTimeHours,
        fulfillment,
        settings,
        taken,
      );
      const open = slots.some((s) => s.problem === null);
      days.push({
        date,
        inDays: i,
        available: open,
        ...(open ? {} : { problem: firstProblem(slots) }),
      });
    }
    return { leadTimeHours, windowDays: settings.windowDays, days };
  }

  async slots(
    date: string,
    leadTimeHours: number,
    fulfillment: FulfillmentValue,
  ): Promise<DaySlotsDto> {
    const settings = await this.calendarSettings();
    const taken = await this.taken(date, date);
    return {
      date,
      slots: this.slotsOf(
        date,
        leadTimeHours,
        fulfillment,
        settings,
        taken,
      ).map(toSlotDto),
    };
  }

  slotsOf(
    date: string,
    leadTimeHours: number,
    fulfillment: FulfillmentValue,
    settings: CalendarSettings,
    taken: Map<string, number>,
  ): SlotState[] {
    return daySlots(
      date,
      this.clock.now(),
      leadTimeHours,
      settings,
      (start) => taken.get(`${date} ${start}`) ?? 0,
      fulfillment === 'DELIVERY',
    );
  }

  /**
   * FR-DLV-04: keeps one place in a slot for a few minutes while the customer
   * pays. The slot's lock makes two holds for the last place take turns.
   */
  async hold(
    date: string,
    start: string,
    leadTimeHours: number,
  ): Promise<SlotHoldDto> {
    const settings = await this.calendarSettings();
    return this.prisma.$transaction(async (tx) => {
      await lockSlot(tx, date, start);
      // Expired holds are only noise from here on.
      await tx.slotHold.deleteMany({
        where: { expiresAt: { lte: this.clock.now() } },
      });
      const taken = await this.taken(date, date, undefined, tx);
      const slot = this.slotsOf(
        date,
        leadTimeHours,
        'DELIVERY',
        settings,
        taken,
      ).find((s) => s.start === start);
      assertSlot(slot);
      const row = await tx.slotHold.create({
        data: {
          date: dateValue(date),
          start,
          expiresAt: DateTime.fromJSDate(this.clock.now())
            .plus({ minutes: settings.holdMinutes })
            .toJSDate(),
        },
      });
      return { id: row.id, date, start, expiresAt: row.expiresAt };
    });
  }

  /** The shop's date for an instant, e.g. "2026-11-12". */
  shopDateOf(at: Date): string {
    return DateTime.fromJSDate(at, { zone: SHOP_TIME_ZONE }).toISODate()!;
  }
}

/** Serializes everything that counts places in one slot, until the transaction ends. */
export async function lockSlot(
  tx: Prisma.TransactionClient,
  date: string,
  start: string,
): Promise<void> {
  await tx.$executeRaw`SELECT pg_advisory_xact_lock(hashtext(${`slot ${date} ${start}`}))`;
}

/** Refuses a slot that does not exist or cannot be chosen now. */
export function assertSlot(
  slot: SlotState | undefined,
): asserts slot is SlotState {
  if (!slot) {
    throw new AppError('SLOT_UNAVAILABLE', {
      extra: { reason: 'NO_SUCH_SLOT' },
    });
  }
  if (slot.problem === 'FULL') throw new AppError('SLOT_FULL');
  if (slot.problem !== null) {
    throw new AppError('SLOT_UNAVAILABLE', { extra: { reason: slot.problem } });
  }
}

function toSlotDto(s: SlotState): DeliverySlotDto {
  return {
    start: s.start,
    end: s.end,
    available: s.problem === null,
    ...(s.problem === null ? {} : { problem: s.problem }),
  };
}

/** Why a day has no slot: the whole-day reasons first, then full, busy, too soon. */
const DAY_REASONS = [
  'CLOSED',
  'OUT_OF_RANGE',
  'FULL',
  'BUSY',
  'TOO_SOON',
] as const;

function firstProblem(slots: SlotState[]): DeliverySlotDto['problem'] {
  return (
    DAY_REASONS.find((r) => slots.some((s) => s.problem === r)) ?? 'CLOSED'
  );
}
