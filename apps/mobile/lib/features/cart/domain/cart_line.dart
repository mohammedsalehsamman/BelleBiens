import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

/// A product's choices in the cart: options, and for cakes a message and a
/// reference photo (FR-CRT-01, FR-CKE-03/04). Prices are never stored here;
/// the server prices every line (NFR-SEC-06).
@immutable
class ProductChoice {
  const new({
    required this.slug,
    this.options = const [],
    this.inscription,
    this.referenceImageUrl,
  });

  factory fromJson(Map<String, Object?> json) => ProductChoice(
    slug: json['slug']! as String,
    options: [
      for (final o in (json['options'] as List<Object?>?) ?? const [])
        ((o! as Map)['group']! as String, (o as Map)['option']! as String),
    ],
    inscription: json['inscription'] as String?,
    referenceImageUrl: json['referenceImageUrl'] as String?,
  );

  final String slug;

  /// (group key, option key) pairs.
  final List<(String, String)> options;
  final String? inscription;
  final String? referenceImageUrl;

  Map<String, Object?> toJson() => {
    'slug': slug,
    'options': [
      for (final (group, option) in options) {'group': group, 'option': option},
    ],
    if (inscription != null && inscription!.isNotEmpty)
      'inscription': inscription,
    'referenceImageUrl': ?referenceImageUrl,
  };

  /// Same product with the same choices: adding it again adds to its quantity.
  bool sameAs(ProductChoice other) =>
      jsonEncode(_sorted().toJson()) == jsonEncode(other._sorted().toJson());

  ProductChoice _sorted() => ProductChoice(
    slug: slug,
    options: [...options]
      ..sort((a, b) => '${a.$1}/${a.$2}'.compareTo('${b.$1}/${b.$2}')),
    inscription: inscription,
    referenceImageUrl: referenceImageUrl,
  );
}

enum CartItemKind { product, design, box }

/// One line of the cart, exactly as POST /v1/cart/quote takes it.
@immutable
class CartLine {
  const new({
    required this.id,
    required this.kind,
    required this.qty,
    this.product,
    this.spec,
    this.previewUrl,
  });

  factory fromJson(Map<String, Object?> json) => CartLine(
    id: json['id']! as String,
    kind: CartItemKind.values.byName(json['kind']! as String),
    qty: json['qty']! as int,
    product: json['product'] == null
        ? null
        : ProductChoice.fromJson(
            Map<String, Object?>.from(json['product']! as Map),
          ),
    spec: json['spec'] == null
        ? null
        : Map<String, Object?>.from(json['spec']! as Map),
    previewUrl: json['previewUrl'] as String?,
  );

  /// A random id for a new line; it stays while the line lives.
  static String newId() {
    final random = Random.secure();
    return List.generate(
      16,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  }

  final String id;
  final CartItemKind kind;
  final int qty;
  final ProductChoice? product;

  /// BouquetSpec v1 for a design, BoxSpec v1 for a box.
  final Map<String, Object?>? spec;
  final String? previewUrl;

  /// The server takes 1 to 50 of a line.
  static const maxQty = 50;

  CartLine copyWith({int? qty, String? Function()? previewUrl}) => CartLine(
    id: id,
    kind: kind,
    qty: qty ?? this.qty,
    product: product,
    spec: spec,
    previewUrl: previewUrl == null ? this.previewUrl : previewUrl(),
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'qty': qty,
    if (product != null) 'product': product!.toJson(),
    'spec': ?spec,
    'previewUrl': ?previewUrl,
  };

  @override
  bool operator ==(Object other) =>
      other is CartLine && jsonEncode(other.toJson()) == jsonEncode(toJson());

  @override
  int get hashCode => jsonEncode(toJson()).hashCode;
}

/// Adds [line] to [lines]: a product with the same choices adds to its
/// quantity (up to the maximum); anything else becomes a new line.
List<CartLine> addLine(List<CartLine> lines, CartLine line) {
  if (line.kind == CartItemKind.product) {
    final index = lines.indexWhere(
      (l) => l.kind == CartItemKind.product && l.product!.sameAs(line.product!),
    );
    if (index >= 0) {
      final merged = (lines[index].qty + line.qty).clamp(1, CartLine.maxQty);
      return [...lines]..[index] = lines[index].copyWith(qty: merged);
    }
  }
  return [...lines, line];
}

/// FR-CRT-03: the guest's cart joins the account's when they sign in. Lines
/// already on the account stay; the phone's are added (same products merge).
List<CartLine> mergeCarts(List<CartLine> account, List<CartLine> phone) {
  var merged = [...account];
  for (final line in phone) {
    if (merged.any((l) => l.id == line.id)) continue;
    merged = addLine(merged, line);
  }
  return merged;
}
