import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/money/price_quote.dart';
import 'package:belle_biens/features/designer/domain/bouquet_spec.dart';

/// One row of the bouquet summary (screen 18).
class EstimateLine {
  const new({required this.item, required this.qty});

  final DesignerItemDto item;
  final int qty;

  int get totalMinor => item.unitPriceMinor * qty;
}

/// The price shown the moment the customer taps (NFR-PERF-03), from the
/// catalog's unit prices and the shared pipeline. The server's quote replaces
/// it when it arrives.
class DesignerEstimate {
  const new({
    required this.lines,
    required this.stems,
    required this.itemsMinor,
  });

  factory of(BouquetSpec spec, Map<String, DesignerItemDto> items) {
    final lines = <EstimateLine>[
      for (final l in [
        ...spec.flowers,
        ...spec.greens,
        SpecLine(spec.wrap, 1),
        SpecLine(spec.ribbon, 1),
        ...spec.extras,
      ])
        if (items[l.id] case final item?) EstimateLine(item: item, qty: l.qty),
    ];
    final quote = priceQuote(
      lines: [
        PriceLine(
          kind: 'design',
          qty: 1,
          unitPriceMinor: 0,
          components: [for (final l in lines) (l.item.unitPriceMinor, l.qty)],
        ),
      ],
      settings: const PriceSettings(usdRate: '1'),
      deliveryFeeMinor: 0,
      displayCurrency: 'SYP',
    );
    return DesignerEstimate(
      lines: lines,
      stems: spec.stems,
      itemsMinor: quote.itemsMinor,
    );
  }

  final List<EstimateLine> lines;
  final int stems;
  final int itemsMinor;
}

/// A way to replace a missing flower (screen 37): one or two items.
class SubstituteOption {
  const new(this.lines);

  final List<SpecLine> lines;
}

int? _available(DesignerItemDto i) => i.available;

bool _hasAny(DesignerItemDto i) => _available(i) == null || _available(i)! > 0;

bool _hasEnough(DesignerItemDto i, int qty) =>
    _available(i) == null || _available(i)! >= qty;

/// Same kind, in stock, other than [missing]: same color first, then those
/// with enough for [qty], then the closest price (the server's order too).
List<DesignerItemDto> substitutes(
  DesignerItemDto missing,
  int qty,
  Iterable<DesignerItemDto> items,
) {
  final colors = missing.colorTags.toSet();
  final candidates = items
      .where(
        (i) => i.id != missing.id && i.type2 == missing.type2 && _hasAny(i),
      )
      .toList();
  int score(DesignerItemDto i) => i.colorTags.any(colors.contains) ? 0 : 1;
  candidates.sort((a, b) {
    final byColor = score(a).compareTo(score(b));
    if (byColor != 0) return byColor;
    final byEnough = (_hasEnough(a, qty) ? 0 : 1).compareTo(
      _hasEnough(b, qty) ? 0 : 1,
    );
    if (byEnough != 0) return byEnough;
    return (a.unitPriceMinor - missing.unitPriceMinor).abs().compareTo(
      (b.unitPriceMinor - missing.unitPriceMinor).abs(),
    );
  });
  return candidates;
}

/// Options for screen 37, best first: keep what is left of [missing] and add
/// the best substitute for the rest; or replace it all with one substitute.
List<SubstituteOption> substituteOptions(
  DesignerItemDto missing,
  int qty,
  Iterable<DesignerItemDto> items,
) {
  final left = _available(missing) ?? qty;
  final ranked = substitutes(missing, qty, items);
  final options = <SubstituteOption>[];
  if (left > 0 && left < qty) {
    final rest = qty - left;
    final partner = ranked.where((i) => _hasEnough(i, rest)).firstOrNull;
    if (partner != null) {
      options.add(
        SubstituteOption([
          SpecLine(missing.id, left),
          SpecLine(partner.id, rest),
        ]),
      );
    }
  }
  for (final i in ranked.where((i) => _hasEnough(i, qty)).take(2)) {
    options.add(SubstituteOption([SpecLine(i.id, qty)]));
  }
  return options;
}
