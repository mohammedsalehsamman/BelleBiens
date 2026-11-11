import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';
import Ajv2020 from 'ajv/dist/2020.js';
import {
  priceQuote,
  normalizeSearch,
  normalizePhone,
  specHash,
  canonicalize,
  layoutBouquet,
  allocate,
  interleave,
} from '../src/reference.mjs';

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

// Extra layout cases beyond the schema examples: crowded, sparse, many extras.
const LAYOUT_EXTRA = [
  {
    name: 'luxury-100-stems-three-colors',
    spec: {
      schemaVersion: 1,
      occasion: 'love',
      size: 'luxury',
      flowers: [
        { id: 'red_rose', qty: 50 },
        { id: 'pink_rose', qty: 30 },
        { id: 'white_rose', qty: 20 },
      ],
      greens: [{ id: 'eucalyptus', qty: 10 }, { id: 'ruscus', qty: 10 }],
      wrap: 'satin_bordeaux',
      ribbon: 'satin_white',
    },
  },
  {
    name: 'medium-few-greens-five-extras',
    spec: {
      schemaVersion: 1,
      occasion: 'birthday',
      size: 'medium',
      flowers: [{ id: 'peony', qty: 15 }],
      greens: [{ id: 'eucalyptus', qty: 3 }],
      wrap: 'kraft_beige',
      ribbon: 'satin_pink',
      extras: [
        { id: 'teddy_bear_small', qty: 2 },
        { id: 'chocolate_box', qty: 1 },
        { id: 'balloon', qty: 1 },
        { id: 'scented_candle', qty: 1 },
        { id: 'gift_card', qty: 1 },
      ],
    },
  },
];

test('layout helpers', () => {
  assert.deepEqual(allocate([12, 6], 18), [12, 6]);
  assert.deepEqual(allocate([50, 30, 20], 60), [30, 18, 12]);
  assert.deepEqual(allocate([1, 1, 1], 2), [1, 1, 0]);
  assert.equal(interleave([4, 2]).join(''), '010010');
});

test('layout vectors (FR-D2D-02/03)', () => {
  const path = join(root, 'vectors/layout.json');
  const slots = load('layouts/bouquet-slots.v1.json');
  const fresh = {
    version: 1,
    description:
      'Where each layer of the 2D preview goes, for a spec and the slots in layouts/bouquet-slots.v1.json. The API and the app must produce exactly these items, in this order (back to front). Regenerate with UPDATE_VECTORS=1 node --test.',
    rules: [
      '1. Layers back to front: wrapBack, greens, flowers, wrapFront, ribbon, extras. wrapBack and wrapFront use spec.wrap; ribbon uses spec.ribbon.',
      '2. Shown flowers = min(sum of flowers qty, number of flower slots). Shown greens likewise with green slots.',
      '3. allocate(qtys, shown): base_k = floor(qty_k * shown / total); the places left go one each to lines with the largest (qty_k * shown) mod total, ties to the earlier line.',
      '4. interleave(alloc): repeat shown times: pick the line with places left whose (alloc_k - placed_k) / alloc_k is largest (compare by cross-multiplying), ties to the earlier line.',
      '5. Flower i of the interleaved sequence takes flower slot i (slots run centre outwards). Flowers are drawn from the last slot to the first, so the centre is on top.',
      '6. Green j takes green slot floor(j * slotCount / shownGreens), in sequence order.',
      '7. Extras: one item per line, in line order, up to the number of extra slots; qty does not add items.',
      '8. Every item copies x, y, size and rotation from its slot. All values are integers.',
    ],
    cases: [...examples.bouquet.valid, ...LAYOUT_EXTRA].map(({ name, spec }) => ({
      name,
      spec,
      items: layoutBouquet(spec, slots.layouts[spec.size]),
    })),
  };
  if (process.env.UPDATE_VECTORS === '1') {
    writeFileSync(path, JSON.stringify(fresh, null, 2) + '\n');
  }
  const stored = load('vectors/layout.json');
  assert.ok(stored.cases.length >= 5);
  for (const c of stored.cases) {
    assert.deepEqual(layoutBouquet(c.spec, slots.layouts[c.spec.size]), c.items, c.name);
  }
  // The README bouquet shows all 18 stems, red and white spread out, the centre red.
  const readme = stored.cases.find((c) => c.name === 'readme-designed-bouquet');
  const flowers = readme.items.filter((i) => i.layer === 'flower');
  assert.equal(flowers.length, 18);
  assert.equal(flowers.at(-1).id, 'red_rose');
  // Luxury with 100 stems shows the 60 slots in the 50/30/20 proportion.
  const lux = stored.cases.find((c) => c.name === 'luxury-100-stems-three-colors');
  const count = (id) => lux.items.filter((i) => i.id === id).length;
  assert.deepEqual([count('red_rose'), count('pink_rose'), count('white_rose')], [30, 18, 12]);
});
