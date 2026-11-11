import { Injectable } from '@nestjs/common';
import { DateTime } from 'luxon';

/** The shop's time zone (FR-LOC-03). Times are stored as instants and shown in this zone. */
export const SHOP_TIME_ZONE = 'Asia/Damascus';

/**
 * The only way business code may read the current time. Lead times, slots, daily
 * flower expiry and unpaid-order timeouts all depend on "now", so tests replace
 * this with FixedClock (plan 3.4, rule 5).
 */
export abstract class Clock {
  abstract now(): Date;

  /** Current time in Damascus as a luxon DateTime, for calendar rules. */
  nowInShopZone(): DateTime {
    return DateTime.fromJSDate(this.now(), { zone: SHOP_TIME_ZONE });
  }
}

@Injectable()
export class SystemClock extends Clock {
  now(): Date {
    return new Date();
  }
}

/** Test clock. Accepts an ISO string with offset, e.g. '2026-11-10T15:00:00+03:00'. */
export class FixedClock extends Clock {
  private current: Date;

  constructor(iso: string) {
    super();
    this.current = FixedClock.parse(iso);
  }

  now(): Date {
    return new Date(this.current.getTime());
  }

  set(iso: string): void {
    this.current = FixedClock.parse(iso);
  }

  advance(duration: {
    seconds?: number;
    minutes?: number;
    hours?: number;
    days?: number;
  }): void {
    this.current = DateTime.fromJSDate(this.current).plus(duration).toJSDate();
  }

  private static parse(iso: string): Date {
    const parsed = DateTime.fromISO(iso, { setZone: true });
    if (!parsed.isValid) throw new Error(`Invalid ISO time: ${iso}`);
    return parsed.toJSDate();
  }
}
