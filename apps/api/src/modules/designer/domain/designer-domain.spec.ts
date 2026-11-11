import {
  contractFile,
  SLOT_LAYOUTS,
} from '../../../common/contracts/contracts.js';
import {
  allocate,
  interleave,
  layoutBouquet,
  type PlacedLayer,
} from './layout.js';
import {
  type BouquetSpec,
  canonicalize,
  checkSpecSchema,
  specHash,
  stemCount,
} from './spec.js';

interface Named {
  name: string;
  spec: unknown;
}

const examples = contractFile<{
  bouquet: { valid: Named[]; invalid: Named[] };
}>('examples/specs.json');
const hashes = contractFile<{
  cases: {
    name: string;
    spec: BouquetSpec;
    canonical: string;
    sha256: string;
  }[];
}>('vectors/spec-hash.json');
const layouts = contractFile<{
  cases: { name: string; spec: BouquetSpec; items: PlacedLayer[] }[];
}>('vectors/layout.json');

/** The invalid examples use "__201__" for a 201-character message. */
const expand = (spec: unknown): unknown =>
  JSON.parse(
    JSON.stringify(spec).replace('"__201__"', JSON.stringify('م'.repeat(201))),
  );

describe('spec schema (contracts/examples/specs.json, NFR-SEC-07)', () => {
  it.each(examples.bouquet.valid.map((e) => [e.name, e.spec] as const))(
    'accepts %s',
    (_, spec) => {
      expect(checkSpecSchema(spec).ok).toBe(true);
    },
  );

  it.each(examples.bouquet.invalid.map((e) => [e.name, e.spec] as const))(
    'rejects %s',
    (_, spec) => {
      const result = checkSpecSchema(expand(spec));
      expect(result.ok).toBe(false);
      if (!result.ok) expect(result.problems.length).toBeGreaterThan(0);
    },
  );
});

describe('specHash (contracts/vectors/spec-hash.json, FR-DAI-06)', () => {
  it.each(hashes.cases.map((c) => [c.name, c] as const))('%s', (_, c) => {
    const { cardMessage: _m, previewMode: _p, ...rest } = c.spec;
    expect(canonicalize(rest)).toBe(c.canonical);
    expect(specHash(c.spec)).toBe(c.sha256);
  });

  it('ignores the card message and the preview mode', () => {
    const spec = hashes.cases[0]!.spec;
    expect(specHash({ ...spec, cardMessage: 'x', previewMode: 'ai' })).toBe(
      specHash(spec),
    );
  });

  it('counts stems in spec.flowers only', () => {
    expect(stemCount(hashes.cases[1]!.spec)).toBe(18);
  });
});

describe('layoutBouquet (contracts/vectors/layout.json, FR-D2D-03)', () => {
  it('has vectors to run', () => {
    expect(layouts.cases.length).toBeGreaterThanOrEqual(5);
  });

  it.each(layouts.cases.map((c) => [c.name, c] as const))('%s', (_, c) => {
    expect(layoutBouquet(c.spec, SLOT_LAYOUTS.layouts[c.spec.size]!)).toEqual(
      c.items,
    );
  });

  it('helpers', () => {
    expect(allocate([50, 30, 20], 60)).toEqual([30, 18, 12]);
    expect(allocate([], 0)).toEqual([]);
    expect(interleave([4, 2]).join('')).toBe('010010');
  });
});
