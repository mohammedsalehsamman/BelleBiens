import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { maskPhone, normalizePhone } from './phone.js';

interface PhoneVector {
  in: string;
  out: string | null;
}

const vectors = JSON.parse(
  readFileSync(
    resolve(
      import.meta.dirname,
      '../../../../../packages/contracts/vectors/phone.json',
    ),
    'utf8',
  ),
) as { cases: PhoneVector[] };

describe('normalizePhone (contracts/vectors/phone.json, FR-CRT-09)', () => {
  it('has vectors to run', () => {
    expect(vectors.cases.length).toBeGreaterThan(10);
  });

  it.each(vectors.cases.map((c) => [c.in, c.out] as const))(
    '%j -> %j',
    (input, output) => {
      expect(normalizePhone(input)).toBe(output);
    },
  );
});

describe('maskPhone', () => {
  it('masks a Syrian mobile like screen 04', () => {
    expect(maskPhone('+963944123456')).toBe('+963 944 *** 456');
  });

  it('keeps only the last digits of other numbers', () => {
    const masked = maskPhone('+4915112345678');
    expect(masked.endsWith('678')).toBe(true);
    expect(masked).not.toContain('15112345');
  });
});
