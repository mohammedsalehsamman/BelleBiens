import 'package:belle_biens/core/money/money.dart';

// The price pipeline of design diagram 9, the same arithmetic as the server
// (apps/api/src/modules/pricing/price-quote.ts) and the shared vectors
// (contracts/vectors/pricing.json). The app uses it for an instant estimate
// while the customer designs; the server's answer is the one that counts
// (ADR 0005, NFR-PERF-03).

class PriceLine {
  const new({
    required this.kind,
    required this.qty,
    required this.unitPriceMinor,
    this.optionChanges = const [],
    this.components = const [],
  });

  factory fromJson(Map<String, Object?> json) => PriceLine(
    kind: json['kind']! as String,
    qty: json['qty']! as int,
    unitPriceMinor: json['unitPriceMinor']! as int,
    optionChanges: [
      for (final o in (json['options'] as List<Object?>?) ?? const [])
        (o! as Map)['priceChangeMinor']! as int,
    ],
    components: [
      for (final c in (json['components'] as List<Object?>?) ?? const [])
        ((c! as Map)['unitPriceMinor']! as int, (c as Map)['qty']! as int),
    ],
  );

  /// 'design' or 'product'.
  final String kind;
  final int qty;
  final int unitPriceMinor;
  final List<int> optionChanges;

  /// (unit price, quantity) of each part of a designed bouquet.
  final List<(int, int)> components;

  int get totalMinor =>
      (unitPriceMinor +
          optionChanges.fold<int>(0, (s, c) => s + c) +
          components.fold<int>(0, (s, c) => s + c.$1 * c.$2)) *
      qty;
}

class PriceSettings {
  const new({
    required this.usdRate,
    this.assemblyFeeMinor = 0,
    this.roundingStepMinor,
  });

  final String usdRate;
  final int assemblyFeeMinor;

  /// Round the total to the nearest step (half up); null: no rounding.
  final int? roundingStepMinor;
}

class PriceCoupon {
  const new percent(int this.percent, {this.minOrderMinor = 0})
    : valueMinor = null;
  const new fixed(int this.valueMinor, {this.minOrderMinor = 0})
    : percent = null;

  final int? percent;
  final int? valueMinor;
  final int minOrderMinor;
}

class PriceQuote {
  const new({
    required this.currency,
    required this.itemsMinor,
    required this.assemblyFeeMinor,
    required this.discountMinor,
    required this.deliveryFeeMinor,
    required this.roundingAdjustmentMinor,
    required this.totalMinor,
  });

  final String currency;
  final int itemsMinor;
  final int assemblyFeeMinor;
  final int discountMinor;
  final int deliveryFeeMinor;
  final int roundingAdjustmentMinor;
  final int totalMinor;

  Map<String, Object?> toJson() => {
    'currency': currency,
    'itemsMinor': itemsMinor,
    'assemblyFeeMinor': assemblyFeeMinor,
    'discountMinor': discountMinor,
    'deliveryFeeMinor': deliveryFeeMinor,
    'roundingAdjustmentMinor': roundingAdjustmentMinor,
    'totalMinor': totalMinor,
  };
}

/// a / b rounded half up, for non-negative a and positive b.
int _divRoundHalfUp(int a, int b) {
  final q = BigInt.from(a) ~/ BigInt.from(b);
  final r = BigInt.from(a) % BigInt.from(b);
  return (r * BigInt.two >= BigInt.from(b) ? q + BigInt.one : q).toInt();
}

PriceQuote priceQuote({
  required List<PriceLine> lines,
  required PriceSettings settings,
  required int deliveryFeeMinor,
  required String displayCurrency,
  PriceCoupon? coupon,
}) {
  var items = 0;
  var designs = 0;
  for (final line in lines) {
    items += line.totalMinor;
    if (line.kind == 'design') designs += line.qty;
  }
  final assembly = settings.assemblyFeeMinor * designs;
  final subtotal = items + assembly;

  var discount = 0;
  if (coupon != null && subtotal >= coupon.minOrderMinor) {
    discount = coupon.percent != null
        ? _divRoundHalfUp(subtotal * coupon.percent!, 100)
        : coupon.valueMinor!;
    if (discount > subtotal) discount = subtotal;
  }

  int convert(int amount) => displayCurrency == 'SYP'
      ? amount
      : sypMinorToUsdCents(amount, settings.usdRate);
  final parts = (
    items: convert(items),
    assembly: convert(assembly),
    discount: convert(discount),
    delivery: convert(deliveryFeeMinor),
  );
  final before = parts.items + parts.assembly - parts.discount + parts.delivery;
  final step = settings.roundingStepMinor;
  final total = step == null ? before : _divRoundHalfUp(before, step) * step;
  return PriceQuote(
    currency: displayCurrency,
    itemsMinor: parts.items,
    assemblyFeeMinor: parts.assembly,
    discountMinor: parts.discount,
    deliveryFeeMinor: parts.delivery,
    roundingAdjustmentMinor: total - before,
    totalMinor: total,
  );
}
