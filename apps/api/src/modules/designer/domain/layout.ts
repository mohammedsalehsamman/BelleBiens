import type { SizeLayout, Slot } from '../../../common/contracts/contracts.js';
import type { BouquetSpec } from './spec.js';

// The 2D preview layout (FR-D2D-02/03): rules in contracts/vectors/layout.json.
// Integer maths only, so the app (Dart) and the server agree exactly. The server
// uses it for the florist's recipe picture and to prove the vectors.

export type LayerKind =
  'wrapBack' | 'green' | 'flower' | 'wrapFront' | 'ribbon' | 'extra';

export interface PlacedLayer extends Slot {
  layer: LayerKind;
  id: string;
}

/** Shares `shown` places between lines by largest remainder; ties to the earlier line. */
export function allocate(qtys: number[], shown: number): number[] {
  const total = qtys.reduce((s, q) => s + q, 0);
  if (total === 0 || shown === 0) return qtys.map(() => 0);
  const base = qtys.map((q) => Math.floor((q * shown) / total));
  const rem = qtys.map((q) => (q * shown) % total);
  let left = shown - base.reduce((s, b) => s + b, 0);
  const order = qtys
    .map((_, i) => i)
    .sort((a, b) => rem[b]! - rem[a]! || a - b);
  for (const i of order) {
    if (left === 0) break;
    base[i]! += 1;
    left -= 1;
  }
  return base;
}

/** Evenly spread sequence of line indexes (largest share left goes next). */
export function interleave(alloc: number[]): number[] {
  const placed = alloc.map(() => 0);
  const sequence: number[] = [];
  const n = alloc.reduce((s, a) => s + a, 0);
  for (let step = 0; step < n; step++) {
    let best = -1;
    for (let k = 0; k < alloc.length; k++) {
      if (placed[k]! >= alloc[k]!) continue;
      if (best === -1) {
        best = k;
        continue;
      }
      const left = (alloc[k]! - placed[k]!) * alloc[best]!;
      const right = (alloc[best]! - placed[best]!) * alloc[k]!;
      if (left > right) best = k;
    }
    placed[best]! += 1;
    sequence.push(best);
  }
  return sequence;
}

const place = (layer: LayerKind, id: string, slot: Slot): PlacedLayer => ({
  layer,
  id,
  x: slot.x,
  y: slot.y,
  size: slot.size,
  rotation: slot.rotation,
});

/** Layers back to front for a spec on one size's slots. */
export function layoutBouquet(
  spec: BouquetSpec,
  layout: SizeLayout,
): PlacedLayer[] {
  const out: PlacedLayer[] = [place('wrapBack', spec.wrap, layout.wrapBack)];

  const greens = spec.greens ?? [];
  const greenShown = Math.min(
    greens.reduce((s, l) => s + l.qty, 0),
    layout.greens.length,
  );
  const greenSeq = interleave(
    allocate(
      greens.map((l) => l.qty),
      greenShown,
    ),
  );
  greenSeq.forEach((k, j) => {
    const at = Math.floor((j * layout.greens.length) / greenShown);
    out.push(place('green', greens[k]!.id, layout.greens[at]!));
  });

  const flowers = spec.flowers;
  const flowerShown = Math.min(
    flowers.reduce((s, l) => s + l.qty, 0),
    layout.flowers.length,
  );
  const flowerSeq = interleave(
    allocate(
      flowers.map((l) => l.qty),
      flowerShown,
    ),
  );
  for (let i = flowerShown - 1; i >= 0; i--) {
    out.push(place('flower', flowers[flowerSeq[i]!]!.id, layout.flowers[i]!));
  }

  out.push(place('wrapFront', spec.wrap, layout.wrapFront));
  out.push(place('ribbon', spec.ribbon, layout.ribbon));
  (spec.extras ?? [])
    .slice(0, layout.extras.length)
    .forEach((line, i) => out.push(place('extra', line.id, layout.extras[i]!)));
  return out;
}
