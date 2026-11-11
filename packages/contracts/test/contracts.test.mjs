import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';
import Ajv2020 from 'ajv/dist/2020.js';
import { priceQuote, normalizeSearch, normalizePhone, specHash, canonicalize } from '../src/reference.mjs';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const load = (p) => JSON.parse(readFileSync(join(root, p), 'utf8'));

const ajv = new Ajv2020({ allErrors: true, strict: true });
const bouquet = ajv.compile(load('schemas/bouquet-spec.v1.json'));
const box = ajv.compile(load('schemas/box-spec.v1.json'));
const examples = load('examples/specs.json');

const expand = (spec) =>
  JSON.parse(JSON.stringify(spec).replace('"__201__"', JSON.stringify('م'.repeat(201))));

test('bouquet schema accepts every valid example', () => {
  for (const { name, spec } of examples.bouquet.valid) {
    assert.ok(bouquet(spec), `${name}: ${ajv.errorsText(bouquet.errors)}`);
  }
});

test('bouquet schema rejects every invalid example', () => {
  for (const { name, spec } of examples.bouquet.invalid) {
    assert.equal(bouquet(expand(spec)), false, `${name} should be rejected`);
  }
});

test('box schema accepts valid and rejects invalid examples', () => {
  for (const { name, spec } of examples.box.valid) assert.ok(box(spec), name);
  for (const { name, spec } of examples.box.invalid) assert.equal(box(spec), false, name);
});

test('pricing vectors are self-consistent', () => {
  const { cases } = load('vectors/pricing.json');
  assert.ok(cases.length >= 10);
  for (const c of cases) {
    assert.deepEqual(priceQuote(c.input), c.expected, c.id);
    const e = c.expected;
    assert.equal(
      e.itemsMinor + e.assemblyFeeMinor - e.discountMinor + e.deliveryFeeMinor + e.roundingAdjustmentMinor,
      e.totalMinor,
      `${c.id}: breakdown must add up to the total`,
    );
  }
});

test('README sample cart totals 7,266 SYP and $60.55', () => {
  const { cases } = load('vectors/pricing.json');
  assert.equal(cases.find((c) => c.id === 'readme-cart-syp').expected.totalMinor, 726600);
  assert.equal(cases.find((c) => c.id === 'readme-cart-usd').expected.totalMinor, 6055);
});

test('arabic normalization vectors', () => {
  for (const c of load('vectors/arabic-normalize.json').cases) {
    assert.equal(normalizeSearch(c.in), c.out, JSON.stringify(c.in));
  }
});

test('phone vectors', () => {
  for (const c of load('vectors/phone.json').cases) {
    assert.equal(normalizePhone(c.in), c.out, JSON.stringify(c.in));
  }
});

test('spec-hash vectors', () => {
  const path = join(root, 'vectors/spec-hash.json');
  const fresh = {
    version: 1,
    description:
      'SHA-256 (hex) of the RFC 8785 canonical JSON of a bouquet spec without cardMessage and previewMode (FR-DAI-06). Arrays keep their order. Regenerate with UPDATE_VECTORS=1 node --test.',
    cases: examples.bouquet.valid.map(({ name, spec }) => {
      const { cardMessage, previewMode, ...rest } = spec;
      return { name, spec, canonical: canonicalize(rest), sha256: specHash(spec) };
    }),
  };
  if (process.env.UPDATE_VECTORS === '1') {
    writeFileSync(path, JSON.stringify(fresh, null, 2) + '\n');
  }
  const stored = load('vectors/spec-hash.json');
  for (const c of stored.cases) {
    assert.equal(specHash(c.spec), c.sha256, c.name);
  }
  // Card message and preview mode never change the hash.
  const base = examples.bouquet.valid[0].spec;
  assert.equal(specHash(base), specHash({ ...base, cardMessage: 'other', previewMode: 'ai' }));
});
