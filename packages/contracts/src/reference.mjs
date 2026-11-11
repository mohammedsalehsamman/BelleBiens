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
