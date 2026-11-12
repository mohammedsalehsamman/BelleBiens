import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:belle_biens/features/designer/application/designer_controller.dart';
import 'package:belle_biens/features/designer/domain/bouquet_spec.dart';
import 'package:belle_biens/features/designer/domain/designer_estimate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Which spec list an item type belongs to.
SpecList listFor(DesignerPart type) => switch (type) {
  DesignerPart.green => SpecList.greens,
  DesignerPart.extra => SpecList.extras,
  _ => SpecList.flowers,
};

/// Screen 37: a flower ran out (FR-DSG-03). Offers keeping what is left plus a
/// substitute, or a full substitute; applying one keeps the stem count.
Future<void> showSubstituteSheet(
  BuildContext context, {
  required DesignerItemDto item,
  required int qty,
  required List<DesignerItemDto> items,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  useSafeArea: true,
  builder: (context) => SubstituteSheet(item: item, qty: qty, items: items),
);

class SubstituteSheet extends ConsumerStatefulWidget {
  const new({
    required this.item,
    required this.qty,
    required this.items,
    super.key,
  });

  final DesignerItemDto item;
  final int qty;
  final List<DesignerItemDto> items;

  @override
  ConsumerState<SubstituteSheet> createState() => _SubstituteSheetState();
}

class _SubstituteSheetState extends ConsumerState<SubstituteSheet> {
  late final List<SubstituteOption> _options = substituteOptions(
    widget.item,
    widget.qty,
    widget.items,
  );
  int _chosen = 0;

  Map<String, DesignerItemDto> get _byId => {
    for (final i in widget.items) i.id: i,
  };

  String _label(SubstituteOption option) => option.lines
      .map((l) => '${_byId[l.id]?.name.of(context) ?? l.id} ${l.qty}')
      .join(' + ');

  /// Price difference against the missing item at the same quantity.
  int _change(SubstituteOption option) =>
      option.lines.fold<int>(
        0,
        (s, l) => s + (_byId[l.id]?.unitPriceMinor ?? 0) * l.qty,
      ) -
      widget.item.unitPriceMinor * widget.qty;

  Future<void> _apply() async {
    final option = _options[_chosen];
    final list = listFor(widget.item.type2);
    await ref.read(designerControllerProvider.notifier).edit((spec) {
      if (spec.qty(list, widget.item.id) > 0) {
        return spec.replace(list, widget.item.id, option.lines);
      }
      var next = spec;
      for (final l in option.lines) {
        next = next.withQty(list, l.id, next.qty(list, l.id) + l.qty);
      }
      return next;
    });
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final name = widget.item.name.of(context);
    final left = widget.item.available ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        BBSpacing.page,
        0,
        BBSpacing.page,
        BBSpacing.page,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: BBHeroIcon(BBIcons.warning)),
          const SizedBox(height: BBSpacing.md),
          Text(
            l10n.substituteTitle,
            style: BBText.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: BBSpacing.xs),
          Text(
            left > 0
                ? l10n.substituteBody(left, name, widget.qty)
                : l10n.substituteBodyNone(name, widget.qty),
            style: BBText.body.muted,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: BBSpacing.lg),
          if (_options.isEmpty)
            BBNotice(text: l10n.substituteNone, tone: BBNoticeTone.warn)
          else ...[
            Text(l10n.substituteChoose, style: BBText.label),
            const SizedBox(height: BBSpacing.sm),
            for (final (i, option) in _options.indexed) ...[
              BBOptionTile(
                title: _label(option),
                selected: _chosen == i,
                onTap: () => setState(() => _chosen = i),
                trailing: Text(
                  _change(option) == 0
                      ? l10n.substituteSamePrice
                      : money.change(_change(option)),
                  style: BBText.xs.muted.merge(BBText.numeric),
                ),
              ),
              const SizedBox(height: BBSpacing.sm),
            ],
            const SizedBox(height: BBSpacing.sm),
            BBButton(
              label: l10n.substituteApply,
              expand: true,
              onPressed: _apply,
            ),
          ],
          const SizedBox(height: BBSpacing.sm),
          BBButton(
            label: l10n.substituteManual,
            variant: BBButtonVariant.quiet,
            expand: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
