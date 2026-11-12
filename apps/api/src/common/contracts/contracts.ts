import { createRequire } from 'node:module';

/**
 * Reads files from packages/contracts (the single source shared with the app,
 * NFR-MNT-03). They are plain JSON, loaded once.
 */
const require = createRequire(import.meta.url);

export function contractFile<T>(path: string): T {
  return require(`@belle/contracts/${path}`) as T;
}

export interface Slot {
  x: number;
  y: number;
  size: number;
  rotation: number;
}

export interface SizeLayout {
  size: string;
  flowers: Slot[];
  greens: Slot[];
  wrapBack: Slot;
  wrapFront: Slot;
  ribbon: Slot;
  extras: Slot[];
}

export interface SlotLayouts {
  version: number;
  canvas: { width: number; height: number };
  layouts: Record<string, SizeLayout>;
}

export const SLOT_LAYOUTS = contractFile<SlotLayouts>(
  'layouts/bouquet-slots.v1.json',
);

export const BOUQUET_SPEC_SCHEMA = contractFile<object>(
  'schemas/bouquet-spec.v1.json',
);

export const BOX_SPEC_SCHEMA = contractFile<object>('schemas/box-spec.v1.json');
