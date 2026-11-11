import { createHash } from 'node:crypto';
import { Ajv2020 } from 'ajv/dist/2020.js';
import { BOUQUET_SPEC_SCHEMA } from '../../../common/contracts/contracts.js';

/** BouquetSpec v1 (SRS Appendix B, contracts/schemas/bouquet-spec.v1.json). */
export interface SpecLine {
  id: string;
  qty: number;
}

export interface BouquetSpec {
  schemaVersion: 1;
  occasion: string;
  size: 'small' | 'medium' | 'large' | 'luxury';
  palette?: 'pastel' | 'romantic_red' | 'luxury_white' | 'mixed';
  flowers: SpecLine[];
  greens?: SpecLine[];
  wrap: string;
  ribbon: string;
  extras?: SpecLine[];
  cardMessage?: string;
  previewMode?: '2d' | '3d' | 'ai';
}

const ajv = new Ajv2020({ allErrors: true, strict: true });
const validate = ajv.compile<BouquetSpec>(BOUQUET_SPEC_SCHEMA);

export interface SchemaProblem {
  path: string;
  message: string;
}

/**
 * NFR-SEC-07: every spec is checked against the shared schema first. Unknown
 * schema versions fail here (schemaVersion is a const). cardMessage is limited
 * in code points, as the schema says; JSON Schema's maxLength counts them too.
 */
export function checkSpecSchema(
  value: unknown,
): { ok: true; spec: BouquetSpec } | { ok: false; problems: SchemaProblem[] } {
  if (validate(value)) return { ok: true, spec: value };
  return {
    ok: false,
    problems: (validate.errors ?? []).slice(0, 10).map((e) => ({
      path: e.instancePath || '/',
      message: e.message ?? 'invalid',
    })),
  };
}

/** RFC 8785 canonical JSON for the spec subset: objects, arrays, strings, integers. */
export function canonicalize(value: unknown): string {
  if (value === null || typeof value !== 'object') return JSON.stringify(value);
  if (Array.isArray(value)) return `[${value.map(canonicalize).join(',')}]`;
  const object = value as Record<string, unknown>;
  return `{${Object.keys(object)
    .filter((k) => object[k] !== undefined)
    .sort()
    .map((k) => `${JSON.stringify(k)}:${canonicalize(object[k])}`)
    .join(',')}}`;
}

/**
 * FR-DAI-06: SHA-256 of the canonical spec without cardMessage and previewMode,
 * so the same bouquet always has the same hash (AI preview cache, R3).
 */
export function specHash(spec: BouquetSpec): string {
  const { cardMessage: _card, previewMode: _mode, ...rest } = spec;
  return createHash('sha256').update(canonicalize(rest), 'utf8').digest('hex');
}

/** Stems that count towards the size limits: everything in spec.flowers. */
export function stemCount(spec: BouquetSpec): number {
  return spec.flowers.reduce((s, l) => s + l.qty, 0);
}
