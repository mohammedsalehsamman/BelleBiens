import { Ajv2020 } from 'ajv/dist/2020.js';
import { BOX_SPEC_SCHEMA } from '../../../common/contracts/contracts.js';
import type { SchemaProblem } from '../../designer/domain/spec.js';

/** BoxSpec v1 (contracts/schemas/box-spec.v1.json), FR-BOX-03. */
export interface BoxSpec {
  schemaVersion: 1;
  boxType: string;
  compartments: { index: number; items: { id: string; qty: number }[] }[];
  wrap?: string;
  ribbon?: string;
  cardMessage?: string;
  previewMode?: '2d' | '3d' | 'ai';
}

/** What each compartment of a box type holds (BoxType.compartments). */
export interface Compartment {
  index: number;
  kind: 'FLOWER' | 'SWEET' | 'EXTRA';
  nameAr: string;
  nameEn: string;
  capacity: number;
}

const ajv = new Ajv2020({ allErrors: true, strict: true });
const validate = ajv.compile<BoxSpec>(BOX_SPEC_SCHEMA);

export function checkBoxSchema(
  value: unknown,
): { ok: true; spec: BoxSpec } | { ok: false; problems: SchemaProblem[] } {
  if (validate(value)) return { ok: true, spec: value };
  return {
    ok: false,
    problems: (validate.errors ?? []).slice(0, 10).map((e) => ({
      path: e.instancePath || '/',
      message: e.message ?? 'invalid',
    })),
  };
}

/** Count of items in a compartment (pieces or stems). */
export const filled = (items: { qty: number }[]): number =>
  items.reduce((s, i) => s + i.qty, 0);
