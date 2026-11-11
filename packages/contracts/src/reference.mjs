// Reference implementations used ONLY to prove that the vectors are self-consistent.
// The API (TypeScript) and the app (Dart) each have their own implementation and must
// produce the same outputs for every vector (NFR-MNT-03). Keep these small and literal.

import { createHash } from 'node:crypto';
import { parsePhoneNumberFromString } from 'libphonenumber-js/max';

// ---------- money ----------

/** Round a non-negative rational a/b half up (away from zero) using BigInt. */
function divRoundHalfUp(a, b) {
  const q = a / b;
  const r = a % b;
  return r * 2n >= b ? q + 1n : q;
}

/** "120" or "119.5" -> { num, den } as BigInt fraction. */
function parseDecimal(s) {
  const [int, frac = ''] = String(s).split('.');
  const den = 10n ** BigInt(frac.length);
  return { num: BigInt(int + frac), den };
}

function convert(amountMinorSyp, currency, usdRate) {
  if (currency === 'SYP') return amountMinorSyp;
  // SYP minor -> USD minor: amount / 100 SYP / rate USD-per... rate is SYP per 1 USD,
  // and both currencies use 2 decimals, so cents = sypMinor / rate.
  const { num, den } = parseDecimal(usdRate);
  return Number(divRoundHalfUp(BigInt(amountMinorSyp) * den, num));
}

export function priceQuote(input) {
  const { lines, settings, coupon, deliveryFeeMinor, displayCurrency } = input;
  let items = 0;
  let designCount = 0;
  for (const line of lines) {
    const options = (line.options ?? []).reduce((s, o) => s + o.priceChangeMinor, 0);
    const components = (line.components ?? []).reduce((s, c) => s + c.unitPriceMinor * c.qty, 0);
    items += (line.unitPriceMinor + options + components) * line.qty;
    if (line.kind === 'design') designCount += line.qty;
  }
  const assembly = settings.assemblyFeeMinor * designCount;
  const subtotal = items + assembly;

  let discount = 0;
  if (coupon && subtotal >= (coupon.minOrderMinor ?? 0)) {
    if (coupon.type === 'percent') {
      discount = Number(divRoundHalfUp(BigInt(subtotal) * BigInt(coupon.value), 100n));
    } else {
      discount = coupon.valueMinor;
    }
    discount = Math.min(discount, subtotal);
  }

  const cur = displayCurrency;
  const out = {
    currency: cur,
    itemsMinor: convert(items, cur, settings.usdRate),
    assemblyFeeMinor: convert(assembly, cur, settings.usdRate),
    discountMinor: convert(discount, cur, settings.usdRate),
    deliveryFeeMinor: convert(deliveryFeeMinor, cur, settings.usdRate),
  };
  const before = out.itemsMinor + out.assemblyFeeMinor - out.discountMinor + out.deliveryFeeMinor;
  let total = before;
  if (settings.rounding?.mode === 'nearest') {
    const step = BigInt(settings.rounding.stepMinor);
    total = Number(divRoundHalfUp(BigInt(before), step) * step);
  }
  out.roundingAdjustmentMinor = total - before;
  out.totalMinor = total;
  return out;
}

// ---------- Arabic search normalization ----------

export function normalizeSearch(input) {
  return input
    .replace(/[ً-ٰٟـ]/g, '')
    .replace(/[أإآٱ]/g, 'ا')
    .replace(/ة/g, 'ه')
    .replace(/ى/g, 'ي')
    .replace(/[٠-٩]/g, (d) => String(d.charCodeAt(0) - 0x0660))
    .replace(/[۰-۹]/g, (d) => String(d.charCodeAt(0) - 0x06f0))
    .toLowerCase()
    .replace(/\s+/g, ' ')
    .trim();
}

// ---------- phone ----------

export function normalizePhone(input) {
  let s = input
    .replace(/[٠-٩]/g, (d) => String(d.charCodeAt(0) - 0x0660))
    .replace(/[۰-۹]/g, (d) => String(d.charCodeAt(0) - 0x06f0))
    .replace(/[\s\-.()]/g, '');
  if (s.startsWith('00')) s = '+' + s.slice(2);
  if (!/^\+?\d+$/.test(s)) return null;
  const p = parsePhoneNumberFromString(s, 'SY');
  if (!p || !p.isValid()) return null;
  const e164 = p.number;
  if (e164.startsWith('+963') && !/^\+9639\d{8}$/.test(e164)) return null;
  return e164;
}

// ---------- spec hash ----------

/** RFC 8785 (JCS) for the JSON subset used by specs: objects, arrays, strings, integers. */
export function canonicalize(v) {
  if (v === null || typeof v !== 'object') return JSON.stringify(v);
  if (Array.isArray(v)) return '[' + v.map(canonicalize).join(',') + ']';
  return (
    '{' +
    Object.keys(v)
      .filter((k) => v[k] !== undefined)
      .sort()
      .map((k) => JSON.stringify(k) + ':' + canonicalize(v[k]))
      .join(',') +
    '}'
  );
}

/** SHA-256 of the canonical spec without cardMessage and previewMode (FR-DAI-06). */
export function specHash(spec) {
  const { cardMessage: _c, previewMode: _p, ...rest } = spec;
  return createHash('sha256').update(canonicalize(rest), 'utf8').digest('hex');
}

// ---------- 2D layout (FR-D2D-02/03) ----------

/**
 * Shares `shown` places between lines in proportion to their qty (largest
 * remainder; ties go to the earlier line). Integer maths only.
 */
export function allocate(qtys, shown) {
  const total = qtys.reduce((s, q) => s + q, 0);
  if (total === 0 || shown === 0) return qtys.map(() => 0);
  const base = qtys.map((q) => Math.floor((q * shown) / total));
  const rem = qtys.map((q) => (q * shown) % total);
  let left = shown - base.reduce((s, b) => s + b, 0);
  const order = qtys.map((_, i) => i).sort((a, b) => rem[b] - rem[a] || a - b);
  for (const i of order) {
    if (left === 0) break;
    base[i] += 1;
    left -= 1;
  }
  return base;
}

/**
 * Spreads lines evenly: at each step the line with the largest share still to
 * place goes next (compare (alloc - placed) / alloc by cross-multiplying);
 * ties go to the earlier line.
 */
export function interleave(alloc) {
  const placed = alloc.map(() => 0);
  const seq = [];
  const n = alloc.reduce((s, a) => s + a, 0);
  for (let step = 0; step < n; step++) {
    let best = -1;
    for (let k = 0; k < alloc.length; k++) {
      if (placed[k] >= alloc[k]) continue;
      if (best === -1) {
        best = k;
        continue;
      }
      const left = (alloc[k] - placed[k]) * alloc[best];
      const right = (alloc[best] - placed[best]) * alloc[k];
      if (left > right) best = k;
    }
    placed[best] += 1;
    seq.push(best);
  }
  return seq;
}

/** Positions of `count` items spread over `length` slots: floor(j * length / count). */
function spread(count, length) {
  return Array.from({ length: count }, (_, j) => Math.floor((j * length) / count));
}

function place(layer, id, slot) {
  return { layer, id, x: slot.x, y: slot.y, size: slot.size, rotation: slot.rotation };
}

/** Layers in draw order (back to front): wrap back, greens, flowers (outside in), wrap front, ribbon, extras. */
export function layoutBouquet(spec, layout) {
  const out = [place('wrapBack', spec.wrap, layout.wrapBack)];

  const greens = spec.greens ?? [];
  const greenShown = Math.min(
    greens.reduce((s, l) => s + l.qty, 0),
    layout.greens.length,
  );
  const greenSeq = interleave(allocate(greens.map((l) => l.qty), greenShown));
  const greenAt = spread(greenShown, layout.greens.length);
  greenSeq.forEach((k, j) => out.push(place('green', greens[k].id, layout.greens[greenAt[j]])));

  const flowers = spec.flowers;
  const flowerShown = Math.min(
    flowers.reduce((s, l) => s + l.qty, 0),
    layout.flowers.length,
  );
  const flowerSeq = interleave(allocate(flowers.map((l) => l.qty), flowerShown));
  for (let i = flowerShown - 1; i >= 0; i--) {
    out.push(place('flower', flowers[flowerSeq[i]].id, layout.flowers[i]));
  }

  out.push(place('wrapFront', spec.wrap, layout.wrapFront));
  out.push(place('ribbon', spec.ribbon, layout.ribbon));
  (spec.extras ?? [])
    .slice(0, layout.extras.length)
    .forEach((line, i) => out.push(place('extra', line.id, layout.extras[i])));
  return out;
}
