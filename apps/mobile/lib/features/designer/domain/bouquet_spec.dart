import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

/// One kind of item and how many (SRS Appendix B `line`).
@immutable
class SpecLine {
  const new(this.id, this.qty);

  factory fromJson(Map<String, Object?> json) =>
      SpecLine(json['id']! as String, json['qty']! as int);

  final String id;
  final int qty;

  Map<String, Object?> toJson() => {'id': id, 'qty': qty};

  @override
  bool operator ==(Object other) =>
      other is SpecLine && other.id == id && other.qty == qty;

  @override
  int get hashCode => Object.hash(id, qty);
}

/// Lists of the spec that hold several items with quantities.
enum SpecList { flowers, greens, extras }

/// BouquetSpec v1 (contracts/schemas/bouquet-spec.v1.json). It records what the
/// customer chose, never prices or drawing (D-07). Immutable, so every change
/// is a new value and undo is a list of old values (FR-DSG-10).
@immutable
class BouquetSpec {
  const new({
    required this.occasion,
    required this.size,
    required this.flowers,
    required this.wrap,
    required this.ribbon,
    this.palette,
    this.greens = const [],
    this.extras = const [],
    this.cardMessage,
    this.previewMode,
  });

  factory fromJson(Map<String, Object?> json) {
    List<SpecLine> lines(String key) => [
      for (final l in (json[key] as List<Object?>?) ?? const [])
        SpecLine.fromJson(Map<String, Object?>.from(l! as Map)),
    ];
    if (json['schemaVersion'] != schemaVersion) {
      throw FormatException('Unknown schemaVersion ${json['schemaVersion']}');
    }
    return BouquetSpec(
      occasion: json['occasion']! as String,
      size: json['size']! as String,
      palette: json['palette'] as String?,
      flowers: lines('flowers'),
      greens: lines('greens'),
      wrap: json['wrap']! as String,
      ribbon: json['ribbon']! as String,
      extras: lines('extras'),
      cardMessage: json['cardMessage'] as String?,
      previewMode: json['previewMode'] as String?,
    );
  }

  static const schemaVersion = 1;

  /// FR-DSG-14: up to 200 characters, counted as Unicode code points.
  static const maxCardMessage = 200;

  final String occasion;
  final String size;
  final String? palette;
  final List<SpecLine> flowers;
  final List<SpecLine> greens;
  final String wrap;
  final String ribbon;
  final List<SpecLine> extras;
  final String? cardMessage;
  final String? previewMode;

  /// Stems that count towards the size limits: everything in [flowers].
  int get stems => flowers.fold(0, (s, l) => s + l.qty);

  List<SpecLine> list(SpecList which) => switch (which) {
    SpecList.flowers => flowers,
    SpecList.greens => greens,
    SpecList.extras => extras,
  };

  int qty(SpecList which, String id) {
    for (final l in list(which)) {
      if (l.id == id) return l.qty;
    }
    return 0;
  }

  /// Sets how many of [id]; 0 removes the line. A new item goes at the end,
  /// so the order the customer added things in is kept.
  BouquetSpec withQty(SpecList which, String id, int qty) {
    final next = [...list(which)];
    final index = next.indexWhere((l) => l.id == id);
    if (qty <= 0) {
      if (index >= 0) next.removeAt(index);
    } else if (index >= 0) {
      next[index] = SpecLine(id, qty);
    } else {
      next.add(SpecLine(id, qty));
    }
    return _withList(which, next);
  }

  /// Replaces [id] by other items in its place (screen 37). An item that is
  /// already in the list gets the extra quantity on its own line.
  BouquetSpec replace(SpecList which, String id, List<SpecLine> by) {
    final others = {
      for (final l in list(which))
        if (l.id != id) l.id,
    };
    final next = <SpecLine>[];
    for (final line in list(which)) {
      if (line.id == id) {
        next.addAll(by.where((b) => b.qty > 0 && !others.contains(b.id)));
      } else {
        final extra = by
            .where((b) => b.id == line.id)
            .fold<int>(0, (s, b) => s + b.qty);
        next.add(SpecLine(line.id, line.qty + extra));
      }
    }
    return _withList(which, next);
  }

  BouquetSpec _withList(SpecList which, List<SpecLine> lines) =>
      switch (which) {
        SpecList.flowers => copyWith(flowers: lines),
        SpecList.greens => copyWith(greens: lines),
        SpecList.extras => copyWith(extras: lines),
      };

  BouquetSpec copyWith({
    String? occasion,
    String? size,
    String? Function()? palette,
    List<SpecLine>? flowers,
    List<SpecLine>? greens,
    String? wrap,
    String? ribbon,
    List<SpecLine>? extras,
    String? Function()? cardMessage,
    String? Function()? previewMode,
  }) => BouquetSpec(
    occasion: occasion ?? this.occasion,
    size: size ?? this.size,
    palette: palette == null ? this.palette : palette(),
    flowers: flowers ?? this.flowers,
    greens: greens ?? this.greens,
    wrap: wrap ?? this.wrap,
    ribbon: ribbon ?? this.ribbon,
    extras: extras ?? this.extras,
    cardMessage: cardMessage == null ? this.cardMessage : cardMessage(),
    previewMode: previewMode == null ? this.previewMode : previewMode(),
  );

  /// The spec as the API and the schema expect it. Empty optional lists and
  /// unset fields are left out.
  Map<String, Object?> toJson() => {
    'schemaVersion': schemaVersion,
    'occasion': occasion,
    'size': size,
    'palette': ?palette,
    'flowers': [for (final l in flowers) l.toJson()],
    if (greens.isNotEmpty) 'greens': [for (final l in greens) l.toJson()],
    'wrap': wrap,
    'ribbon': ribbon,
    if (extras.isNotEmpty) 'extras': [for (final l in extras) l.toJson()],
    'cardMessage': ?cardMessage,
    'previewMode': ?previewMode,
  };

  /// FR-DAI-06: SHA-256 of the canonical JSON without the card message and the
  /// preview mode; the same as the server (contracts/vectors/spec-hash.json).
  String get hash {
    final json = toJson()
      ..remove('cardMessage')
      ..remove('previewMode');
    return sha256.convert(utf8.encode(canonicalJson(json))).toString();
  }

  @override
  bool operator ==(Object other) =>
      other is BouquetSpec &&
      jsonEncode(other.toJson()) == jsonEncode(toJson());

  @override
  int get hashCode => jsonEncode(toJson()).hashCode;
}

/// RFC 8785 canonical JSON for the spec subset (objects, arrays, strings,
/// integers): keys sorted, no spaces, arrays in order.
String canonicalJson(Object? value) {
  if (value is Map) {
    final keys =
        value.keys.cast<String>().where((k) => value[k] != null).toList()
          ..sort();
    final members = keys.map(
      (k) => '${jsonEncode(k)}:${canonicalJson(value[k])}',
    );
    return '{${members.join(',')}}';
  }
  if (value is List) return '[${value.map(canonicalJson).join(',')}]';
  return jsonEncode(value);
}
