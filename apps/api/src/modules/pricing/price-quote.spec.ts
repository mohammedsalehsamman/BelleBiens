import { contractFile } from '../../common/contracts/contracts.js';
import {
  type PriceInput,
  type PriceQuote,
  priceQuote,
  sypToUsdCents,
} from './price-quote.js';

const vectors = contractFile<{
  cases: { id: string; input: PriceInput; expected: PriceQuote }[];
}>('vectors/pricing.json');

describe('priceQuote (contracts/vectors/pricing.json, NFR-FUN-01)', () => {
  it('has vectors to run', () => {
    expect(vectors.cases.length).toBeGreaterThanOrEqual(10);
  });

  it.each(vectors.cases.map((c) => [c.id, c] as const))('%s', (_, c) => {
    expect(priceQuote(c.input)).toEqual(c.expected);
  });

  it('README cart: 7,266 SYP and $60.55', () => {
    const syp = vectors.cases.find((c) => c.id === 'readme-cart-syp')!;
    const usd = vectors.cases.find((c) => c.id === 'readme-cart-usd')!;
    expect(priceQuote(syp.input).totalMinor).toBe(726_600);
    expect(priceQuote(usd.input).totalMinor).toBe(6055);
  });
});

describe('sypToUsdCents', () => {
  it('handles decimal rates and refuses zero', () => {
    expect(sypToUsdCents(23_900, '119.5')).toBe(200);
    expect(() => sypToUsdCents(100, '0')).toThrow('Invalid USD rate');
  });
});
