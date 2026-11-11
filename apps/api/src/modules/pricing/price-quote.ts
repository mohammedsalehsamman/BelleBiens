// The price pipeline of design diagram 9 (FR-DSG-08, FR-CRT-07/08, FR-PAY-05).
// Rules and test cases: packages/contracts/vectors/pricing.json. The app runs the
// same arithmetic for an instant estimate; the server's answer is the one that
// counts (ADR 0005, NFR-SEC-06). All amounts are integers in minor units.

export interface PriceLine {
  kind: 'design' | 'product';
  qty: number;
  unitPriceMinor: number;
  options?: { priceChangeMinor: number }[];
  components?: { unitPriceMinor: number; qty: number }[];
}

export interface PriceSettings {
  assemblyFeeMinor: number;
  rounding: { mode: 'none' } | { mode: 'nearest'; stepMinor: number };
  /** SYP per 1 USD, as a decimal string. */
  usdRate: string;
}

export type Coupon =
  | { type: 'percent'; value: number; minOrderMinor?: number }
  | { type: 'fixed'; valueMinor: number; minOrderMinor?: number };

export interface PriceInput {
  lines: PriceLine[];
  settings: PriceSettings;
  coupon: Coupon | null;
  deliveryFeeMinor: number;
  displayCurrency: 'SYP' | 'USD';
}

export interface PriceQuote {
  currency: 'SYP' | 'USD';
  itemsMinor: number;
  assemblyFeeMinor: number;
  discountMinor: number;
  deliveryFeeMinor: number;
  roundingAdjustmentMinor: number;
  totalMinor: number;
}

/** a / b rounded half up, for non-negative a and positive b. */
function divRoundHalfUp(a: bigint, b: bigint): bigint {
  const q = a / b;
  return (a % b) * 2n >= b ? q + 1n : q;
}

/** SYP minor units to US cents with a decimal rate, exactly. */
export function sypToUsdCents(sypMinor: number, usdRate: string): number {
  const [whole, fraction = ''] = usdRate.trim().split('.');
  const rate = BigInt(`${whole}${fraction}`);
  if (rate <= 0n) throw new Error(`Invalid USD rate: ${usdRate}`);
  const scale = 10n ** BigInt(fraction.length);
  return Number(divRoundHalfUp(BigInt(sypMinor) * scale, rate));
}

export function lineTotalMinor(line: PriceLine): number {
  const options = (line.options ?? []).reduce(
    (s, o) => s + o.priceChangeMinor,
    0,
  );
  const components = (line.components ?? []).reduce(
    (s, c) => s + c.unitPriceMinor * c.qty,
    0,
  );
  return (line.unitPriceMinor + options + components) * line.qty;
}

export function priceQuote(input: PriceInput): PriceQuote {
  const { lines, settings, coupon, displayCurrency } = input;
  let items = 0;
  let designs = 0;
  for (const line of lines) {
    items += lineTotalMinor(line);
    if (line.kind === 'design') designs += line.qty;
  }
  const assembly = settings.assemblyFeeMinor * designs;
  const subtotal = items + assembly;

  // The coupon applies before the delivery fee (proposal to confirm, pricing.json).
  let discount = 0;
  if (coupon && subtotal >= (coupon.minOrderMinor ?? 0)) {
    discount =
      coupon.type === 'percent'
        ? Number(divRoundHalfUp(BigInt(subtotal) * BigInt(coupon.value), 100n))
        : coupon.valueMinor;
    discount = Math.min(discount, subtotal);
  }

  // Each part is converted on its own; the total is the sum of converted parts.
  const convert = (amount: number) =>
    displayCurrency === 'SYP'
      ? amount
      : sypToUsdCents(amount, settings.usdRate);
  const parts = {
    itemsMinor: convert(items),
    assemblyFeeMinor: convert(assembly),
    discountMinor: convert(discount),
    deliveryFeeMinor: convert(input.deliveryFeeMinor),
  };
  const before =
    parts.itemsMinor +
    parts.assemblyFeeMinor -
    parts.discountMinor +
    parts.deliveryFeeMinor;
  const total =
    settings.rounding.mode === 'nearest'
      ? Number(
          divRoundHalfUp(BigInt(before), BigInt(settings.rounding.stepMinor)) *
            BigInt(settings.rounding.stepMinor),
        )
      : before;
  return {
    currency: displayCurrency,
    ...parts,
    roundingAdjustmentMinor: total - before,
    totalMinor: total,
  };
}
