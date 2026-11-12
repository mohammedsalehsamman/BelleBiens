import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/today_screen.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:belle_biens/features/designer/application/designer_controller.dart';
import 'package:belle_biens/features/designer/domain/bouquet_spec.dart';
import 'package:belle_biens/features/designer/domain/designer_estimate.dart';
import 'package:belle_biens/features/designer/domain/layout.dart';
import 'package:belle_biens/features/designer/presentation/bouquet_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Items by spec id, for lookups while drawing and pricing.
Map<String, DesignerItemDto> itemsById(DesignerCatalogDto catalog) => {
  for (final i in catalog.items) i.id: i,
};

/// The total to show: the server's quote for exactly this spec when it has
/// arrived, else the instant estimate (plan 4.4).
({int totalMinor, DesignerQuoteDto? quote}) designerTotal(
  WidgetRef ref,
  BouquetSpec spec,
  DesignerEstimate estimate,
) {
  final quote = ref.watch(designerQuoteProvider(quoteKey(spec))).value;
  return (totalMinor: quote?.totalMinor ?? estimate.itemsMinor, quote: quote);
}

/// The live 2D preview (screens 15-18): drawn from the shared layout on every
/// change, with the stem count and the price.
class BouquetPreviewCard extends ConsumerWidget {
  const new({
    required this.spec,
    required this.catalog,
    required this.estimate,
    super.key,
  });

  final BouquetSpec spec;
  final DesignerCatalogDto catalog;
  final DesignerEstimate estimate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final layout = catalog.layouts.sizes
        .where((l) => l.size.toJson() == spec.size)
        .firstOrNull;
    final layers = layout == null || spec.flowers.isEmpty
        ? const <PlacedLayer>[]
        : layoutBouquet(spec, layout);
    final total = designerTotal(ref, spec, estimate).totalMinor;

    return BBCard(
      padding: const EdgeInsets.all(BBSpacing.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            image: true,
            label:
                '${l10n.designerPreviewLabel}: '
                '${l10n.designerStems(estimate.stems)}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(BBRadius.card),
              child: ColoredBox(
                color: BBColors.previewWash,
                child: SizedBox(
                  height: 230,
                  child: Stack(
                    children: [
                      Center(
                        child: AspectRatio(
                          aspectRatio: designCanvas.width / designCanvas.height,
                          child: layers.isEmpty
                              ? const Center(
                                  child: BBIcon(
                                    BBIcons.flower,
                                    size: 44,
                                    color: BBColors.onBlush,
                                  ),
                                )
                              : CustomPaint(
                                  painter: BouquetPainter(
                                    layers: layers,
                                    items: itemsById(catalog),
                                  ),
                                ),
                        ),
                      ),
                      PositionedDirectional(
                        top: BBSpacing.sm,
                        start: BBSpacing.sm,
                        child: BBBadge(
                          label: '● ${l10n.designerLive}',
                          tone: BBBadgeTone.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: BBSpacing.gutter),
          // Wraps at large text sizes instead of overflowing.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: BBSpacing.sm,
            spacing: BBSpacing.sm,
            children: [
              BBBadge(
                label: l10n.designerStems(estimate.stems),
                icon: BBIcons.flower,
              ),
              if (spec.flowers.isEmpty)
                Text(l10n.designerPickFlowers, style: BBText.small.muted)
              else
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      money.primary(total),
                      style: BBText.price
                          .copyWith(fontSize: 20)
                          .merge(BBText.numeric),
                    ),
                    Text(
                      l10n.priceApprox(money.secondary(total)),
                      style: BBText.xs.muted.merge(BBText.numeric),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A small color dot for an item (flower, wrap, ribbon).
class Swatch extends StatelessWidget {
  const new(this.hex, {this.size = 28, this.selected = false, super.key});

  final String? hex;
  final double size;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: hex == null ? BBColors.surfaceMuted : swatchColor(hex!),
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
      boxShadow: [
        BoxShadow(
          color: selected ? BBColors.primary : BBColors.toggleOff,
          spreadRadius: selected ? 2 : 1,
        ),
      ],
    ),
  );
}

/// One designer item with a quantity stepper (screens 16, 17). The stepper
/// stops at what the shop has today (FR-DSG-03).
class ItemQtyRow extends ConsumerWidget {
  const new({
    required this.item,
    required this.qty,
    required this.onChanged,
    this.onSuggest,
    this.perSprig = false,
    this.fitsPalette = false,
    super.key,
  });

  final DesignerItemDto item;
  final int qty;
  final ValueChanged<int> onChanged;
  final VoidCallback? onSuggest;
  final bool perSprig;
  final bool fitsPalette;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final available = item.available;
    final none = available == 0;
    final price = money.syp(item.unitPriceMinor);
    final detail = none
        ? l10n.designerUnavailable
        : perSprig
        ? l10n.designerPerSprig(price)
        : available == null
        ? l10n.designerAvailable(price)
        : l10n.designerAvailableCount(price, money.count(available));

    return BBCard(
      padding: const EdgeInsets.all(BBSpacing.gutter),
      child: Row(
        children: [
          Swatch(item.swatch),
          const SizedBox(width: BBSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name.of(context), style: BBText.small.bold),
                Text(
                  detail,
                  style:
                      (none
                              ? BBText.xs.copyWith(color: BBColors.onRed)
                              : BBText.xs.muted)
                          .merge(BBText.numeric),
                ),
                if (fitsPalette)
                  Padding(
                    padding: const EdgeInsets.only(top: BBSpacing.xs),
                    child: BBBadge(
                      label: l10n.designerFitsPalette,
                      tone: BBBadgeTone.sage,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: BBSpacing.sm),
          if (none && qty == 0 && onSuggest != null)
            Flexible(
              child: TextButton(
                onPressed: onSuggest,
                child: Text(l10n.designerSuggest, textAlign: TextAlign.center),
              ),
            )
          else
            BBQtyStepper(
              value: qty,
              max: available == null
                  ? 200
                  : (qty > available ? qty : available),
              itemLabel: item.name.of(context),
              onChanged: onChanged,
            ),
        ],
      ),
    );
  }
}
