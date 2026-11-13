import { DateTime } from 'luxon';
import { SHOP_TIME_ZONE } from '../../common/clock/clock.js';

// FR-RPT-01/03/04: sales by period, category, product, payment method,
// zone and coupon, in SYP and USD. Pure, so it is tested without a database.

export type Period = 'day' | 'week' | 'month';

export interface ReportOrder {
  createdAt: Date;
  paymentMethod: string;
  zoneSlug: string | null;
  couponCode: string | null;
  discountMinor: number;
  totalMinor: number;
  totalUsdCents: number;
  lines: {
    kind: string;
    titleAr: string;
    titleEn: string;
    qty: number;
    totalMinor: number;
    /** The product slug for product lines. */
    slug: string | null;
  }[];
}

export interface Bucket {
  key: string;
  orders: number;
  totalMinor: number;
  totalUsdCents: number;
}

export interface LineBucket {
  key: string;
  titleAr: string;
  titleEn: string;
  qty: number;
  totalMinor: number;
}

export interface SalesReport {
  orders: number;
  totalMinor: number;
  totalUsdCents: number;
  periods: Bucket[];
  byPaymentMethod: Bucket[];
  byZone: Bucket[];
  byCategory: LineBucket[];
  byProduct: LineBucket[];
  coupons: (Bucket & { discountMinor: number })[];
}

/**
 * The period an order falls in, by the shop's calendar. Weeks start on
 * Saturday, as Syrian business weeks do.
 */
export function periodKey(at: Date, period: Period): string {
  const local = DateTime.fromJSDate(at, { zone: SHOP_TIME_ZONE });
  if (period === 'day') return local.toISODate()!;
  if (period === 'month') return local.toFormat('yyyy-MM');
  // luxon weekday: Monday 1 ... Saturday 6, Sunday 7.
  const back = (local.weekday + 1) % 7;
  return local.minus({ days: back }).toISODate()!;
}

function add(map: Map<string, Bucket>, key: string, o: ReportOrder): void {
  const b = map.get(key) ?? { key, orders: 0, totalMinor: 0, totalUsdCents: 0 };
  b.orders += 1;
  b.totalMinor += o.totalMinor;
  b.totalUsdCents += o.totalUsdCents;
  map.set(key, b);
}

const byTotal = <T extends { totalMinor: number; key: string }>(a: T, b: T) =>
  b.totalMinor - a.totalMinor || a.key.localeCompare(b.key);

export function salesReport(
  orders: ReportOrder[],
  period: Period,
  categoryOf: (slug: string) => { key: string; ar: string; en: string } | null,
): SalesReport {
  const periods = new Map<string, Bucket>();
  const methods = new Map<string, Bucket>();
  const zones = new Map<string, Bucket>();
  const coupons = new Map<string, Bucket & { discountMinor: number }>();
  const categories = new Map<string, LineBucket>();
  const products = new Map<string, LineBucket>();

  const line = (
    map: Map<string, LineBucket>,
    key: string,
    ar: string,
    en: string,
    qty: number,
    totalMinor: number,
  ) => {
    const b = map.get(key) ?? {
      key,
      titleAr: ar,
      titleEn: en,
      qty: 0,
      totalMinor: 0,
    };
    b.qty += qty;
    b.totalMinor += totalMinor;
    map.set(key, b);
  };

  for (const o of orders) {
    add(periods, periodKey(o.createdAt, period), o);
    add(methods, o.paymentMethod, o);
    add(zones, o.zoneSlug ?? 'pickup', o);
    if (o.couponCode) {
      const c = coupons.get(o.couponCode) ?? {
        key: o.couponCode,
        orders: 0,
        totalMinor: 0,
        totalUsdCents: 0,
        discountMinor: 0,
      };
      c.orders += 1;
      c.totalMinor += o.totalMinor;
      c.totalUsdCents += o.totalUsdCents;
      c.discountMinor += o.discountMinor;
      coupons.set(o.couponCode, c);
    }
    for (const l of o.lines) {
      if (l.kind === 'design') {
        line(
          categories,
          'designs',
          'باقات مصمّمة',
          'Designed bouquets',
          l.qty,
          l.totalMinor,
        );
        line(
          products,
          'design',
          'باقتك المصمّمة',
          'Designed bouquet',
          l.qty,
          l.totalMinor,
        );
        continue;
      }
      if (l.kind === 'box') {
        line(categories, 'boxes', 'صناديق', 'Boxes', l.qty, l.totalMinor);
        line(
          products,
          `box:${l.titleEn}`,
          l.titleAr,
          l.titleEn,
          l.qty,
          l.totalMinor,
        );
        continue;
      }
      const category = l.slug ? categoryOf(l.slug) : null;
      if (category) {
        line(
          categories,
          category.key,
          category.ar,
          category.en,
          l.qty,
          l.totalMinor,
        );
      } else {
        line(categories, 'other', 'أخرى', 'Other', l.qty, l.totalMinor);
      }
      line(
        products,
        l.slug ?? l.titleEn,
        l.titleAr,
        l.titleEn,
        l.qty,
        l.totalMinor,
      );
    }
  }

  return {
    orders: orders.length,
    totalMinor: orders.reduce((s, o) => s + o.totalMinor, 0),
    totalUsdCents: orders.reduce((s, o) => s + o.totalUsdCents, 0),
    periods: [...periods.values()].sort((a, b) => a.key.localeCompare(b.key)),
    byPaymentMethod: [...methods.values()].sort(byTotal),
    byZone: [...zones.values()].sort(byTotal),
    byCategory: [...categories.values()].sort(byTotal),
    byProduct: [...products.values()].sort(byTotal).slice(0, 20),
    coupons: [...coupons.values()].sort(byTotal),
  };
}

/** The periods as CSV for a spreadsheet (FR-RPT-01). */
export function periodsCsv(report: SalesReport): string {
  const rows = [
    'period,orders,total_syp,total_usd',
    ...report.periods.map(
      (p) =>
        `${p.key},${p.orders},${(p.totalMinor / 100).toFixed(2)},${(p.totalUsdCents / 100).toFixed(2)}`,
    ),
    `total,${report.orders},${(report.totalMinor / 100).toFixed(2)},${(report.totalUsdCents / 100).toFixed(2)}`,
  ];
  return `${rows.join('\n')}\n`;
}
