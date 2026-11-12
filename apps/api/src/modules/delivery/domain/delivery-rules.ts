import { DateTime } from 'luxon';
import { SHOP_TIME_ZONE } from '../../../common/clock/clock.js';
import {
  earliestReadyAt,
  type WorkingHours,
} from '../../catalog/domain/product-rules.js';

// Pure delivery rules: zones, the calendar and slots (FR-DLV-01..09).

/** [lng, lat] as in GeoJSON. */
export type LngLat = [number, number];

/**
 * Is the point inside the ring? Ray casting, enough for city areas drawn by
 * the shop (a few dozen corners). Points exactly on an edge count as inside
 * on one side only, which is fine at street scale.
 */
export function pointInPolygon(point: LngLat, ring: LngLat[]): boolean {
  const [x, y] = point;
  let inside = false;
  for (let i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    const [xi, yi] = ring[i]!;
    const [xj, yj] = ring[j]!;
    const crosses =
      yi > y !== yj > y && x < ((xj - xi) * (y - yi)) / (yj - yi) + xi;
    if (crosses) inside = !inside;
  }
  return inside;
}

export interface SlotTemplate {
  start: string;
  end: string;
  capacity: number;
}

export type SlotProblem =
  'TOO_SOON' | 'FULL' | 'CLOSED' | 'BUSY' | 'OUT_OF_RANGE';

export interface CalendarSettings {
  hours: WorkingHours;
  slots: SlotTemplate[];
  closedDays: string[];
  windowDays: number;
  mode: 'open' | 'busy' | 'closed';
  busyAcceptsFrom: string | null;
}

export interface SlotState {
  start: string;
  end: string;
  capacity: number;
  taken: number;
  problem: SlotProblem | null;
}

/** "14:00" on a shop date, as an instant in Damascus. */
export function slotStartAt(date: string, start: string): DateTime {
  return DateTime.fromISO(`${date}T${start}`, { zone: SHOP_TIME_ZONE });
}

/**
 * The slots of one day and why each cannot be chosen (FR-DLV-03/04/05/09):
 * - CLOSED: a closed day (or the shop is closed);
 * - OUT_OF_RANGE: before today or past the booking window;
 * - TOO_SOON: starts before now plus the longest lead time in the cart;
 * - BUSY: busy mode, today, before the time the shop takes orders from;
 * - FULL: as many orders as the slot takes (pickup ignores capacity).
 */
export function daySlots(
  date: string,
  now: Date,
  leadTimeHours: number,
  settings: CalendarSettings,
  taken: (start: string) => number,
  countCapacity: boolean,
): SlotState[] {
  const today = DateTime.fromJSDate(now, { zone: SHOP_TIME_ZONE }).startOf(
    'day',
  );
  const day = DateTime.fromISO(date, { zone: SHOP_TIME_ZONE }).startOf('day');
  const daysAhead = Math.round(day.diff(today, 'days').days);
  const ready = earliestReadyAt(now, leadTimeHours, settings.hours);

  return settings.slots.map((slot) => {
    const used = countCapacity ? taken(slot.start) : 0;
    const state = (problem: SlotProblem | null): SlotState => ({
      start: slot.start,
      end: slot.end,
      capacity: slot.capacity,
      taken: used,
      problem,
    });
    if (settings.mode === 'closed' || settings.closedDays.includes(date)) {
      return state('CLOSED');
    }
    if (daysAhead < 0 || daysAhead > settings.windowDays)
      return state('OUT_OF_RANGE');
    if (slotStartAt(date, slot.start) < ready) return state('TOO_SOON');
    if (
      settings.mode === 'busy' &&
      daysAhead === 0 &&
      settings.busyAcceptsFrom !== null &&
      slot.start < settings.busyAcceptsFrom
    ) {
      return state('BUSY');
    }
    if (countCapacity && used >= slot.capacity) return state('FULL');
    return state(null);
  });
}
