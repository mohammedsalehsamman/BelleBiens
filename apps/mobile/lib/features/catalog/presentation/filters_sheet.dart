import 'dart:async';

import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/data/catalog_repository.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen 09 as a bottom sheet over the shop. Choices apply on "عرض N منتجات".
Future<void> showFiltersSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) => const FiltersSheet(),
    );

class FiltersSheet extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends ConsumerState<FiltersSheet> {
  late ProductQuery _draft = ref.read(shopQueryProvider);
  int? _count;
  int _countRequest = 0;
  final _debounce = Debouncer(const Duration(milliseconds: 300));

  @override
  void initState() {
    super.initState();
    unawaited(_recount());
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  void _update(ProductQuery next) {
    setState(() => _draft = next);
    _debounce.run(() => unawaited(_recount()));
  }

  /// Asks the server how many products match, for the button label.
  Future<void> _recount() async {
    final request = ++_countRequest;
    try {
      final count = await ref.read(catalogRepositoryProvider).count(_draft);
      if (mounted && request == _countRequest) setState(() => _count = count);
    } on Object {
      if (mounted && request == _countRequest) setState(() => _count = null);
    }
  }

  Set<String> _toggle(Set<String> set, String value) =>
      set.contains(value) ? ({...set}..remove(value)) : {...set, value};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filters = ref.watch(catalogFiltersProvider).value?.data;
    final money = ref.watch(moneyFormatProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: BBSpacing.page),
          child: Text(l10n.shopFilters, style: BBText.h2),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(BBSpacing.page),
            children: [
              if (filters == null)
                const Center(child: CircularProgressIndicator())
              else ...[
                _Section(
                  title: l10n.filtersOccasion,
                  children: [
                    for (final o in filters.occasions)
                      BBChip(
                        label: o.name.of(context),
                        selected: _draft.occasion == o.slug,
                        onTap: () => _update(
                          _draft.copyWith(
                            occasion: () =>
                                _draft.occasion == o.slug ? null : o.slug,
                          ),
                        ),
                      ),
                  ],
                ),
                _Section(
                  title: l10n.filtersColor,
                  children: [
                    for (final c in filters.colors)
                      BBChip(
                        label: c.name.of(context),
                        selected: _draft.colors.contains(c.slug),
                        onTap: () => _update(
                          _draft.copyWith(
                            colors: _toggle(_draft.colors, c.slug),
                          ),
                        ),
                      ),
                  ],
                ),
                _Section(
                  title: l10n.filtersFlowerType,
                  children: [
                    for (final f in filters.flowerTypes)
                      BBChip(
                        label: f.name.of(context),
                        selected: _draft.flowerTypes.contains(f.slug),
                        onTap: () => _update(
                          _draft.copyWith(
                            flowerTypes: _toggle(_draft.flowerTypes, f.slug),
                          ),
                        ),
                      ),
                  ],
                ),
                _PriceRange(
                  title: l10n.filtersPrice(l10n.currencySyp),
                  range: filters.price,
                  draft: _draft,
                  label: money.syp,
                  onChanged: (min, max) => _update(
                    _draft.copyWith(minPrice: () => min, maxPrice: () => max),
                  ),
                ),
                const SizedBox(height: BBSpacing.md),
                _ToggleRow(
                  label: l10n.filtersAvailableToday,
                  value: _draft.availableToday,
                  onChanged: (v) => _update(_draft.copyWith(availableToday: v)),
                ),
                _ToggleRow(
                  label: l10n.filtersDeliverableToday,
                  value: _draft.deliverableToday,
                  onChanged: (v) =>
                      _update(_draft.copyWith(deliverableToday: v)),
                ),
              ],
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(BBSpacing.page),
            child: Row(
              children: [
                BBButton(
                  label: l10n.filtersClearAll,
                  variant: BBButtonVariant.quiet,
                  onPressed: () => _update(_draft.clearFilters()),
                ),
                const SizedBox(width: BBSpacing.sm),
                Expanded(
                  child: BBButton(
                    label: _count == null
                        ? l10n.filtersShowResults
                        : l10n.filtersShowCount(_count!),
                    expand: true,
                    onPressed: _count == 0
                        ? null
                        : () {
                            ref.read(shopQueryProvider.notifier).set(_draft);
                            Navigator.of(context).pop();
                          },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const new({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: BBSpacing.section),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(header: true, child: Text(title, style: BBText.label)),
        const SizedBox(height: BBSpacing.sm),
        Wrap(
          spacing: BBSpacing.sm,
          runSpacing: BBSpacing.sm,
          children: children,
        ),
      ],
    ),
  );
}

class _PriceRange extends StatelessWidget {
  const new({
    required this.title,
    required this.range,
    required this.draft,
    required this.label,
    required this.onChanged,
  });

  final String title;
  final PriceRangeDto range;
  final ProductQuery draft;
  final String Function(int minor) label;
  final void Function(int? min, int? max) onChanged;

  /// Slider steps of 60 pounds keep the labels round.
  static const _step = 6000;

  @override
  Widget build(BuildContext context) {
    final lowest = (range.minMinor ~/ _step) * _step;
    final highest = ((range.maxMinor + _step - 1) ~/ _step) * _step;
    if (highest <= lowest) return const SizedBox.shrink();
    final start = (draft.minPrice ?? lowest).clamp(lowest, highest);
    final end = (draft.maxPrice ?? highest).clamp(start, highest);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: BBText.label),
        RangeSlider(
          min: lowest.toDouble(),
          max: highest.toDouble(),
          divisions: (highest - lowest) ~/ _step,
          values: RangeValues(start.toDouble(), end.toDouble()),
          labels: RangeLabels(label(start), label(end)),
          onChanged: (v) {
            final min = v.start.round();
            final max = v.end.round();
            onChanged(min <= lowest ? null : min, max >= highest ? null : max);
          },
        ),
        Row(
          children: [
            Text(label(start), style: BBText.xs.muted.merge(BBText.numeric)),
            const Spacer(),
            Text(label(end), style: BBText.xs.muted.merge(BBText.numeric)),
          ],
        ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: BBSizes.minTouch),
    child: Row(
      children: [
        Expanded(child: Text(label, style: BBText.body)),
        BBToggle(value: value, onChanged: onChanged, semanticLabel: label),
      ],
    ),
  );
}
