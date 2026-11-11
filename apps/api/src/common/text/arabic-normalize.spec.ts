import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { normalizeArabic, searchTokens } from './arabic-normalize.js';

const vectors = JSON.parse(
  readFileSync(
    resolve(
      import.meta.dirname,
      '../../../../../packages/contracts/vectors/arabic-normalize.json',
    ),
    'utf8',
  ),
) as { cases: { in: string; out: string }[] };

describe('normalizeArabic (contracts/vectors/arabic-normalize.json, FR-CAT-04)', () => {
  it('has vectors to run', () => {
    expect(vectors.cases.length).toBeGreaterThan(10);
  });

  it.each(vectors.cases.map((c) => [c.in, c.out] as const))(
    '%j -> %j',
    (input, output) => {
      expect(normalizeArabic(input)).toBe(output);
    },
  );
});

describe('searchTokens', () => {
  it('splits a normalized query into words', () => {
    expect(searchTokens('  باقةُ   الجوري ')).toEqual(['باقه', 'الجوري']);
  });

  it('gives no words for an empty query', () => {
    expect(searchTokens('   ')).toEqual([]);
  });
});
