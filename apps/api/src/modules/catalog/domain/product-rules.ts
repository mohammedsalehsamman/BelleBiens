import { DateTime } from 'luxon';
import { normalizeArabic } from '../../../common/text/arabic-normalize.js';
import { SHOP_TIME_ZONE } from '../../../common/clock/clock.js';

// Pure rules shared by the catalog service and the admin writes. No database here.

export interface PricedOption {
  priceChangeMinor: number;
  isDefault: boolean;
}

export interface PricedGroup {
  key: string;
  selection: 'SINGLE' | 'MULTIPLE';
  required: boolean;
  options: PricedOption[];
}

/**
 * The price shown on cards and the product page before the customer picks anything:
 * the base price plus the default option of each group. It reads "from" when the
 * default size is the cheapest and a bigger size costs more: the cake on screen 06
 * reads "من 2,280", while the bouquet whose default is the medium size reads "2,400".
 * Only the size counts; modifiers such as oat milk (+60) keep the plain price (screen 32).
 */
export function displayPrice(
  basePriceMinor: number,
  groups: PricedGroup[],
): { displayPriceMinor: number; priceFrom: boolean } {
  let price = basePriceMinor;
  let defaultsAreCheapest = true;
  let hasDearerChoice = false;
  for (const group of groups) {
    const defaults = group.options.filter((o) => o.isDefault);
    price += defaults.reduce((sum, o) => sum + o.priceChangeMinor, 0);
    if (group.key !== 'size' || group.selection !== 'SINGLE') continue;
    if (group.options.length === 0) continue;
    const changes = group.options.map((o) => o.priceChangeMinor);
    const cheapest = Math.min(...changes);
    const chosen = defaults[0]?.priceChangeMinor ?? cheapest;
    if (chosen !== cheapest) defaultsAreCheapest = false;
    if (Math.max(...changes) > chosen) hasDearerChoice = true;
  }
  return {
    displayPriceMinor: price,
    priceFrom: defaultsAreCheapest && hasDearerChoice,
  };
}

/** Everything a customer might type to find the product, in both languages, normalized. */
export function buildSearchText(parts: (string | null | undefined)[]): string {
  return normalizeArabic(
    parts
      .filter((p): p is string => typeof p === 'string' && p !== '')
      .join(' '),
  );
}

export type ProductBadge =
  'bestSeller' | 'seasonal' | 'today' | 'todayOnly' | 'limited' | 'unavailable';

export interface AvailabilityInput {
  status: 'ACTIVE' | 'HIDDEN';
  stockQuantity: number | null;
  dailyDate: Date | null;
  dailyOnly: boolean;
  limited: boolean;
  seasonal: boolean;
  bestSeller: boolean;
}

/** The shop's calendar date for an instant, as the Date Prisma uses for @db.Date. */
export function shopDate(now: Date): Date {
  const iso = DateTime.fromJSDate(now, { zone: SHOP_TIME_ZONE }).toISODate();
  return new Date(`${iso}T00:00:00.000Z`);
}

export function isSameDate(a: Date | null, b: Date): boolean {
  return (
    a !== null && a.toISOString().slice(0, 10) === b.toISOString().slice(0, 10)
  );
}

/**
 * Can it be ordered today, and which badges does the card show (screens 06, 07, 10, 32)?
 * A product on today's list counts only on that date, so "available today only"
 * products become unavailable at midnight with no job running (FR-DLY-05).
 */
export function availability(
  product: AvailabilityInput,
  today: Date,
): { available: boolean; badges: ProductBadge[] } {
  const onTodayList = isSameDate(product.dailyDate, today);
  const inStock = product.stockQuantity === null || product.stockQuantity > 0;
  const available =
    product.status === 'ACTIVE' &&
    inStock &&
    (!product.dailyOnly || onTodayList);

  const badges: ProductBadge[] = [];
  if (!available) {
    badges.push('unavailable');
    return { available, badges };
  }
  if (product.dailyOnly) badges.push('todayOnly');
  else if (onTodayList) badges.push('today');
  if (product.limited) badges.push('limited');
  if (product.bestSeller) badges.push('bestSeller');
  if (product.seasonal) badges.push('seasonal');
  return { available, badges };
}

export interface WorkingHours {
  open: string;
  close: string;
}

function minutesOf(hhmm: string): number {
  const [h, m] = hhmm.split(':').map(Number);
  return (h ?? 0) * 60 + (m ?? 0);
}

/**
 * Earliest delivery date (shop calendar) for a product made in `leadTimeHours`
 * (FR-DLV-05, screen 12 "أقرب توصيل"). Ready when now + lead time; if that is after
 * closing, the next day. Closed days and slot capacity come with the delivery
 * module (S5), which replaces this estimate at checkout.
 */
export function earliestDeliveryDate(
  now: Date,
  leadTimeHours: number,
  hours: WorkingHours,
): string {
  const ready = DateTime.fromJSDate(now, { zone: SHOP_TIME_ZONE }).plus({
    hours: leadTimeHours,
  });
  const minuteOfDay = ready.hour * 60 + ready.minute;
  const close = minutesOf(hours.close);
  const day = minuteOfDay >= close ? ready.plus({ days: 1 }) : ready;
  return day.toISODate() ?? '';
}

/** Open right now (FR-ADM-12 mode plus working hours)? "24:00" means midnight. */
export function isOpenNow(
  now: Date,
  mode: 'open' | 'busy' | 'closed',
  hours: WorkingHours,
): boolean {
  if (mode === 'closed') return false;
  const local = DateTime.fromJSDate(now, { zone: SHOP_TIME_ZONE });
  const minute = local.hour * 60 + local.minute;
  const open = minutesOf(hours.open);
  const close = minutesOf(hours.close);
  return close > open
    ? minute >= open && minute < close
    : minute >= open || minute < close;
}

/**
 * FR-DLV-05: the earliest time a whole cart can be ready: now plus the longest
 * lead time, moved inside working hours and rounded up to the next half hour.
 * Closed days and slot capacity come with the delivery module (S5).
 */
export function earliestReadyAt(
  now: Date,
  leadTimeHours: number,
  hours: WorkingHours,
): DateTime {
  let ready = DateTime.fromJSDate(now, { zone: SHOP_TIME_ZONE }).plus({
    hours: leadTimeHours,
  });
  const minutes = ready.minute + ready.second / 60;
  if (minutes > 0 && minutes !== 30) {
    ready = ready
      .set({ second: 0, millisecond: 0 })
      .plus({ minutes: minutes < 30 ? 30 - ready.minute : 60 - ready.minute });
  } else {
    ready = ready.set({ second: 0, millisecond: 0 });
  }
  const open = minutesOf(hours.open);
  const close = minutesOf(hours.close);
  const at = ready.hour * 60 + ready.minute;
  if (at < open) return ready.startOf('day').plus({ minutes: open });
  if (at >= close)
    return ready.plus({ days: 1 }).startOf('day').plus({ minutes: open });
  return ready;
}
