import {
  availability,
  buildSearchText,
  displayPrice,
  earliestDeliveryDate,
  isOpenNow,
  shopDate,
  type AvailabilityInput,
} from './product-rules.js';

const size = (changes: number[], defaultIndex: number, key = 'size') => ({
  key,
  selection: 'SINGLE' as const,
  required: true,
  options: changes.map((priceChangeMinor, i) => ({
    priceChangeMinor,
    isDefault: i === defaultIndex,
  })),
});

describe('displayPrice', () => {
  it('adds the default options: medium bouquet 1,800 + 600 = 2,400 (screen 12)', () => {
    expect(displayPrice(180_000, [size([0, 60_000, 156_000], 1)])).toEqual({
      displayPriceMinor: 240_000,
      priceFrom: false,
    });
  });

  it('reads "from" when the default is the cheapest and others cost more (cake, screen 06)', () => {
    expect(displayPrice(228_000, [size([0, 72_000], 0)])).toEqual({
      displayPriceMinor: 228_000,
      priceFrom: true,
    });
  });

  it('keeps the plain price for modifiers and optional groups (drink, screen 32)', () => {
    const giftCard = {
      key: 'gift-card',
      selection: 'MULTIPLE' as const,
      required: false,
      options: [{ priceChangeMinor: 12_000, isDefault: false }],
    };
    const milk = size([0, 6_000, 6_000], 0, 'milk');
    expect(displayPrice(54_000, [milk, giftCard])).toEqual({
      displayPriceMinor: 54_000,
      priceFrom: false,
    });
  });

  it('treats a size group with no default as its cheapest choice', () => {
    expect(displayPrice(100, [size([0, 50], -1)])).toEqual({
      displayPriceMinor: 100,
      priceFrom: true,
    });
  });
});

describe('buildSearchText', () => {
  it('joins both languages and normalizes them', () => {
    expect(buildSearchText(['باقةُ الجوري', null, 'Red Roses', ''])).toBe(
      'باقه الجوري red roses',
    );
  });
});

const today = shopDate(new Date('2026-11-11T15:00:00+03:00'));
const base: AvailabilityInput = {
  status: 'ACTIVE',
  stockQuantity: null,
  dailyDate: null,
  dailyOnly: false,
  limited: false,
  seasonal: false,
  bestSeller: false,
};

describe('shopDate', () => {
  it('uses the Damascus calendar: 23:30 UTC on the 10th is already the 11th', () => {
    expect(shopDate(new Date('2026-11-10T23:30:00Z')).toISOString()).toBe(
      '2026-11-11T00:00:00.000Z',
    );
  });
});

describe('availability (FR-DLY-02/05, FR-INV-01)', () => {
  it('made-to-order products are available', () => {
    expect(availability({ ...base, bestSeller: true }, today)).toEqual({
      available: true,
      badges: ['bestSeller'],
    });
  });

  it('"today only" products need today\'s date', () => {
    const onList = { ...base, dailyOnly: true, dailyDate: today };
    expect(availability(onList, today)).toEqual({
      available: true,
      badges: ['todayOnly'],
    });
    const yesterday = new Date('2026-11-10T00:00:00.000Z');
    expect(availability({ ...onList, dailyDate: yesterday }, today)).toEqual({
      available: false,
      badges: ['unavailable'],
    });
  });

  it('shows "today" and "limited" for listed products that are not daily-only', () => {
    expect(
      availability(
        { ...base, dailyDate: today, limited: true, seasonal: true },
        today,
      ),
    ).toEqual({ available: true, badges: ['today', 'limited', 'seasonal'] });
  });

  it('sold out or hidden means unavailable', () => {
    expect(availability({ ...base, stockQuantity: 0 }, today).available).toBe(
      false,
    );
    expect(availability({ ...base, status: 'HIDDEN' }, today).available).toBe(
      false,
    );
    expect(availability({ ...base, stockQuantity: 3 }, today).available).toBe(
      true,
    );
  });
});

describe('earliestDeliveryDate (FR-DLV-05)', () => {
  const hours = { open: '10:00', close: '24:00' };

  it('no lead time at 15:00 is today', () => {
    expect(
      earliestDeliveryDate(new Date('2026-11-11T15:00:00+03:00'), 0, hours),
    ).toBe('2026-11-11');
  });

  it('a 24 hour cake at 15:00 is tomorrow', () => {
    expect(
      earliestDeliveryDate(new Date('2026-11-11T15:00:00+03:00'), 24, hours),
    ).toBe('2026-11-12');
  });

  it('ready after closing moves to the next day', () => {
    const shortDay = { open: '10:00', close: '22:00' };
    expect(
      earliestDeliveryDate(new Date('2026-11-11T21:00:00+03:00'), 2, shortDay),
    ).toBe('2026-11-12');
  });
});

describe('isOpenNow (FR-ADM-12)', () => {
  const hours = { open: '10:00', close: '24:00' };
  const at = (time: string) => new Date(`2026-11-11T${time}:00+03:00`);

  it('open between opening and midnight', () => {
    expect(isOpenNow(at('15:00'), 'open', hours)).toBe(true);
    expect(isOpenNow(at('09:59'), 'open', hours)).toBe(false);
    expect(isOpenNow(at('23:59'), 'busy', hours)).toBe(true);
  });

  it('closed mode wins over the hours', () => {
    expect(isOpenNow(at('15:00'), 'closed', hours)).toBe(false);
  });

  it('handles hours past midnight', () => {
    const late = { open: '18:00', close: '02:00' };
    expect(isOpenNow(at('01:00'), 'open', late)).toBe(true);
    expect(isOpenNow(at('03:00'), 'open', late)).toBe(false);
  });
});
