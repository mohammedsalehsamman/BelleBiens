import { FixedClock, SHOP_TIME_ZONE, SystemClock } from './clock.js';

describe('Clock', () => {
  it('FixedClock returns the given instant and reports it in Damascus time', () => {
    const clock = new FixedClock('2026-11-10T15:00:00+03:00');
    expect(clock.now().toISOString()).toBe('2026-11-10T12:00:00.000Z');

    const local = clock.nowInShopZone();
    expect(local.zoneName).toBe(SHOP_TIME_ZONE);
    expect(local.toFormat('yyyy-MM-dd HH:mm')).toBe('2026-11-10 15:00');
  });

  it('FixedClock.advance moves time forward, e.g. a 24 h cake lead time (FR-DLV-05)', () => {
    const clock = new FixedClock('2026-11-10T15:00:00+03:00');
    clock.advance({ hours: 24 });
    expect(clock.nowInShopZone().toFormat('yyyy-MM-dd HH:mm')).toBe(
      '2026-11-11 15:00',
    );
  });

  it('crossing local midnight changes the business day (FR-DLY-05 expiry at 00:00)', () => {
    const clock = new FixedClock('2026-11-10T23:59:00+03:00');
    expect(clock.nowInShopZone().toISODate()).toBe('2026-11-10');
    clock.advance({ minutes: 1 });
    expect(clock.nowInShopZone().toISODate()).toBe('2026-11-11');
  });

  it('FixedClock returns a copy, so callers cannot mutate it', () => {
    const clock = new FixedClock('2026-11-10T15:00:00+03:00');
    clock.now().setFullYear(2000);
    expect(clock.now().getUTCFullYear()).toBe(2026);
  });

  it('rejects invalid input', () => {
    expect(() => new FixedClock('not a date')).toThrow('Invalid ISO time');
  });

  it('SystemClock follows the real time', () => {
    const before = Date.now();
    const now = new SystemClock().now().getTime();
    expect(now).toBeGreaterThanOrEqual(before);
    expect(now - before).toBeLessThan(1000);
  });
});
