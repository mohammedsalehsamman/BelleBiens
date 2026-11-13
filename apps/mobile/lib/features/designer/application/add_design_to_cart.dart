import 'dart:async';

import 'package:belle_biens/core/analytics/analytics.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/features/cart/application/cart_controller.dart';
import 'package:belle_biens/features/cart/domain/cart_line.dart';
import 'package:belle_biens/features/designer/application/designer_controller.dart';
import 'package:belle_biens/features/designer/domain/bouquet_spec.dart';
import 'package:belle_biens/features/designer/domain/layout.dart';
import 'package:belle_biens/features/designer/presentation/bouquet_painter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Puts the design in the cart as one line (FR-CRT-02): the spec, and the
/// 2D preview once it is uploaded (FR-D2D-05). Editing a cart line puts it
/// back in its place. Returns true when it replaced an existing line.
Future<bool> addDesignToCart(
  WidgetRef ref,
  DesignerState state,
  DesignerCatalogDto catalog,
) async {
  final spec = state.withCard
      ? state.spec
      : state.spec.copyWith(cardMessage: () => null);
  final editing = state.editingLineId;
  final line = CartLine(
    id: editing ?? CartLine.newId(),
    kind: CartItemKind.design,
    qty: 1,
    spec: spec.toJson(),
  );
  final cart = ref.read(cartControllerProvider.notifier);
  ref.read(analyticsProvider).log(AnalyticsEvent.designerCompleted, {
    'stems': spec.flowers.fold<int>(0, (s, f) => s + f.qty),
  });
  if (editing != null) {
    await cart.replace(editing, line);
  } else {
    await cart.add(line);
  }
  await ref.read(designerControllerProvider.notifier).finishedAdding();
  unawaited(_attachPreview(ref, line, catalog));
  return editing != null;
}

/// Best effort: without a network the line simply has no picture yet.
Future<void> _attachPreview(
  WidgetRef ref,
  CartLine line,
  DesignerCatalogDto catalog,
) async {
  try {
    final spec = line.spec!;
    final layout = catalog.layouts.sizes.firstWhere(
      (l) => l.size.toJson() == spec['size'],
    );
    final items = {for (final i in catalog.items) i.id: i};
    final png = await renderBouquetPng(
      layoutBouquet(BouquetSpec.fromJson(spec), layout),
      items,
    );
    final url = await ref.read(designerRepositoryProvider).uploadPreview(png);
    await ref
        .read(cartControllerProvider.notifier)
        .replace(line.id, line.copyWith(previewUrl: () => url));
  } on Object {
    // The cart still works; the shop sees the spec.
  }
}
