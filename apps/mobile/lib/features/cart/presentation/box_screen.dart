import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/cart/application/cart_controller.dart';
import 'package:belle_biens/features/cart/domain/cart_line.dart';
import 'package:belle_biens/features/cart/presentation/cart_screen.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:belle_biens/features/designer/presentation/designer_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Which item types each compartment takes (same as the server).
List<DesignerPart> partsFor(BoxPartKind kind) => switch (kind) {
  BoxPartKind.flower => const [DesignerPart.flower],
  BoxPartKind.sweet => const [DesignerPart.sweet],
  BoxPartKind.extra => const [DesignerPart.extra],
};

/// What the customer put in each compartment: index -> item id -> qty.
typedef BoxFill = Map<int, Map<String, int>>;

/// Screen 19 starts like the design: three quarters of the flowers in the
/// first flower that has enough today, and the sweets part full of the first
/// sweet.
BoxFill defaultFill(BoxTypeDto type, List<DesignerItemDto> items) {
  final fill = <int, Map<String, int>>{};
  for (final c in type.compartments) {
    if (c.kind == BoxPartKind.extra) continue;
    final count = c.kind == BoxPartKind.flower
        ? (c.capacity * 3) ~/ 4
        : c.capacity;
    final item = items
        .where(
          (i) =>
              partsFor(c.kind).contains(i.type2) &&
              (i.available == null || i.available! >= count),
        )
        .firstOrNull;
    if (item != null) fill[c.index] = {item.id: count};
  }
  return fill;
}

/// The BoxSpec v1 the cart sends (contracts/schemas/box-spec.v1.json).
Map<String, Object?> boxSpec(String boxType, BoxFill fill) => {
  'schemaVersion': 1,
  'boxType': boxType,
  'compartments': [
    for (final MapEntry(key: index, value: items) in fill.entries)
      if (items.values.any((q) => q > 0))
        {
          'index': index,
          'items': [
            for (final MapEntry(key: id, value: qty) in items.entries)
              if (qty > 0) {'id': id, 'qty': qty},
          ],
        },
  ],
};

class BoxScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<BoxScreen> createState() => _BoxScreenState();
}

class _BoxScreenState extends ConsumerState<BoxScreen> {
  String? _typeId;
  BoxFill _fill = {};

  void _choose(BoxTypeDto type, List<DesignerItemDto> items) => setState(() {
    _typeId = type.id;
    _fill = defaultFill(type, items);
  });

  int _filled(int index) =>
      (_fill[index]?.values ?? const <int>[]).fold(0, (s, q) => s + q);

  void _set(int index, String id, int qty) => setState(() {
    _fill = {
      ..._fill,
      index: {...?_fill[index], id: qty},
    };
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catalog = ref.watch(boxCatalogProvider);
    return Scaffold(
      appBar: BBTopBar(
        title: l10n.boxTitle,
        onBack: () => Navigator.of(context).maybePop(),
        action: const CartButton(),
      ),
      body: switch (catalog) {
        AsyncData(:final value) => _body(context, value),
        AsyncError(:final error) => ErrorRetry(
          error: error,
          onRetry: () => ref.invalidate(boxCatalogProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
      bottomNavigationBar: catalog.value == null
          ? null
          : _bottom(context, catalog.value!),
    );
  }

  BoxTypeDto _type(BoxCatalogDto catalog) {
    final type = catalog.types.where((t) => t.id == _typeId).firstOrNull;
    if (type != null) return type;
    final first = catalog.types.first;
    // First build: start from the design's default fill.
    _typeId = first.id;
    _fill = defaultFill(first, catalog.items);
    return first;
  }

  int _total(BoxCatalogDto catalog) {
    final type = _type(catalog);
    final prices = {for (final i in catalog.items) i.id: i.unitPriceMinor};
    var total = type.basePriceMinor;
    for (final items in _fill.values) {
      for (final MapEntry(key: id, value: qty) in items.entries) {
        total += (prices[id] ?? 0) * qty;
      }
    }
    return total;
  }

  Widget _body(BuildContext context, BoxCatalogDto catalog) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final type = _type(catalog);

    return ListView(
      padding: const EdgeInsets.all(BBSpacing.page),
      children: [
        Text(l10n.boxType, style: BBText.h3),
        const SizedBox(height: BBSpacing.sm),
        for (final t in catalog.types) ...[
          BBOptionTile(
            title: t.name.of(context),
            subtitle: t.detail.of(context),
            selected: t.id == type.id,
            onTap: () => _choose(t, catalog.items),
            trailing: Text(
              l10n.priceFrom(money.syp(t.fromPriceMinor)),
              style: BBText.small.bold.merge(BBText.numeric),
            ),
          ),
          const SizedBox(height: BBSpacing.sm),
        ],
        for (final c in type.compartments) ...[
          const SizedBox(height: BBSpacing.md),
          Row(
            children: [
              Expanded(child: Text(c.name.of(context), style: BBText.h3)),
              Text(
                c.kind == BoxPartKind.flower
                    ? l10n.boxUpTo(c.capacity)
                    : l10n.boxFilled(_filled(c.index), c.capacity),
                style: BBText.xs.muted.merge(BBText.numeric),
              ),
            ],
          ),
          const SizedBox(height: BBSpacing.sm),
          for (final item in catalog.items.where(
            (i) => partsFor(c.kind).contains(i.type2),
          ))
            Padding(
              padding: const EdgeInsets.only(bottom: BBSpacing.sm),
              child: _CompartmentRow(
                item: item,
                qty: _fill[c.index]?[item.id] ?? 0,
                room: c.capacity - _filled(c.index),
                onChanged: (v) => _set(c.index, item.id, v),
              ),
            ),
        ],
        const SizedBox(height: BBSpacing.sm),
        BBNotice(text: l10n.boxLeadNote, icon: BBIcons.clock),
      ],
    );
  }

  Widget _bottom(BuildContext context, BoxCatalogDto catalog) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final type = _type(catalog);
    final spec = boxSpec(type.id, _fill);
    final empty = (spec['compartments']! as List).isEmpty;
    return BBBottomCta(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.productTotal, style: BBText.xs.muted),
            Text(
              money.primary(_total(catalog)),
              style: BBText.price.merge(BBText.numeric),
            ),
          ],
        ),
        Expanded(
          child: BBButton(
            label: l10n.productAddToCart,
            leading: BBIcons.bag,
            expand: true,
            onPressed: empty
                ? null
                : () async {
                    await ref
                        .read(cartControllerProvider.notifier)
                        .add(
                          CartLine(
                            id: CartLine.newId(),
                            kind: CartItemKind.box,
                            qty: 1,
                            spec: spec,
                          ),
                        );
                    if (context.mounted) {
                      showAddedToCart(
                        context,
                        l10n.productAdded(type.name.of(context)),
                      );
                    }
                  },
          ),
        ),
      ],
    );
  }
}

/// An item in a compartment; the stepper stops at the compartment's room and
/// today's stock (FR-BOX-02).
class _CompartmentRow extends ConsumerWidget {
  const new({
    required this.item,
    required this.qty,
    required this.room,
    required this.onChanged,
  });

  final DesignerItemDto item;
  final int qty;
  final int room;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final stock = item.available;
    final max = [qty + room, ?stock].reduce((a, b) => a < b ? a : b);
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
                  stock == 0
                      ? l10n.designerUnavailable
                      : item.type2 == DesignerPart.flower
                      ? money.syp(item.unitPriceMinor)
                      : '${money.syp(item.unitPriceMinor)} · ${l10n.boxPiece}',
                  style: BBText.xs.muted.merge(BBText.numeric),
                ),
              ],
            ),
          ),
          BBQtyStepper(
            value: qty,
            max: max < qty ? qty : max,
            itemLabel: item.name.of(context),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
