import {
  periodKey,
  periodsCsv,
  type ReportOrder,
  salesReport,
} from './sales-report.js';

const order = (
  at: string,
  totalMinor: number,
  extra: Partial<ReportOrder> = {},
): ReportOrder => ({
  createdAt: new Date(at),
  paymentMethod: 'CASH',
  zoneSlug: 'abu-rummaneh',
  couponCode: null,
  discountMinor: 0,
  totalMinor,
  totalUsdCents: Math.round(totalMinor / 120),
  lines: [
    {
      kind: 'product',
      titleAr: 'لاتيه',
      titleEn: 'Latte',
      qty: 2,
      totalMinor,
      slug: 'iced-rose-matcha-latte',
    },
  ],
  ...extra,
});

const categories = (slug: string) =>
  slug === 'iced-rose-matcha-latte'
    ? { key: 'coffee', ar: 'قهوة وماتشا', en: 'Coffee & matcha' }
    : null;

describe('periods (FR-RPT-01)', () => {
  it('days and months by Damascus time; weeks start on Saturday', () => {
    // 23:30 UTC on the 11th is 02:30 on the 12th in Damascus.
    expect(periodKey(new Date('2026-11-11T23:30:00Z'), 'day')).toBe(
      '2026-11-12',
    );
    expect(periodKey(new Date('2026-11-12T10:00:00Z'), 'month')).toBe(
      '2026-11',
    );
    // Thursday 12 November 2026 belongs to the week of Saturday the 7th.
    expect(periodKey(new Date('2026-11-12T10:00:00Z'), 'week')).toBe(
      '2026-11-07',
    );
    expect(periodKey(new Date('2026-11-07T10:00:00Z'), 'week')).toBe(
      '2026-11-07',
    );
    expect(periodKey(new Date('2026-11-13T10:00:00Z'), 'week')).toBe(
      '2026-11-07',
    );
    expect(periodKey(new Date('2026-11-14T10:00:00Z'), 'week')).toBe(
      '2026-11-14',
    );
  });
});

describe('salesReport (FR-RPT-01/03/04)', () => {
  it('totals by period, method, zone, category, product and coupon', () => {
    const report = salesReport(
      [
        order('2026-11-11T10:00:00Z', 108_000),
        order('2026-11-11T12:00:00Z', 726_600, {
          paymentMethod: 'SHAMCASH',
          couponCode: 'WELCOME10',
          discountMinor: 71_160,
          lines: [
            {
              kind: 'design',
              titleAr: 'باقتك المصمّمة',
              titleEn: 'Your designed bouquet',
              qty: 1,
              totalMinor: 267_600,
              slug: null,
            },
          ],
        }),
        order('2026-11-12T10:00:00Z', 54_000, { zoneSlug: null }),
      ],
      'day',
      categories,
    );
    expect(report).toMatchObject({ orders: 3, totalMinor: 888_600 });
    expect(report.periods.map((p) => [p.key, p.orders, p.totalMinor])).toEqual([
      ['2026-11-11', 2, 834_600],
      ['2026-11-12', 1, 54_000],
    ]);
    expect(report.byPaymentMethod.map((b) => b.key)).toEqual([
      'SHAMCASH',
      'CASH',
    ]);
    expect(report.byZone.map((b) => b.key)).toEqual(['abu-rummaneh', 'pickup']);
    expect(report.byCategory.map((b) => [b.key, b.qty])).toEqual([
      ['designs', 1],
      ['coffee', 4],
    ]);
    expect(report.coupons).toEqual([
      expect.objectContaining({
        key: 'WELCOME10',
        orders: 1,
        discountMinor: 71_160,
      }),
    ]);
  });

  it('as CSV, with a total row', () => {
    const csv = periodsCsv(
      salesReport([order('2026-11-11T10:00:00Z', 108_000)], 'day', categories),
    );
    expect(csv).toBe(
      'period,orders,total_syp,total_usd\n2026-11-11,1,1080.00,9.00\ntotal,1,1080.00,9.00\n',
    );
  });
});
