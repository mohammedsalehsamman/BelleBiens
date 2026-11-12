import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/features/designer/domain/bouquet_spec.dart';
import 'package:flutter/foundation.dart';

// The 2D preview layout (FR-D2D-02/03). Same rules and integer maths as the
// server (contracts/vectors/layout.json), so the picture is the same on every
// phone and in the florist's recipe.

enum LayerKind { wrapBack, green, flower, wrapFront, ribbon, extra }

/// One drawn layer on the 1000 x 1250 canvas.
@immutable
class PlacedLayer {
  const new({
    required this.layer,
    required this.id,
    required this.x,
    required this.y,
    required this.size,
    required this.rotation,
  });

  factory fromJson(Map<String, Object?> json) => PlacedLayer(
    layer: LayerKind.values.byName(json['layer']! as String),
    id: json['id']! as String,
    x: json['x']! as int,
    y: json['y']! as int,
    size: json['size']! as int,
    rotation: json['rotation']! as int,
  );

  final LayerKind layer;
  final String id;
  final int x;
  final int y;
  final int size;
  final int rotation;

  Map<String, Object?> toJson() => {
    'layer': layer.name,
    'id': id,
    'x': x,
    'y': y,
    'size': size,
    'rotation': rotation,
  };

  @override
  bool operator ==(Object other) =>
      other is PlacedLayer &&
      other.layer == layer &&
      other.id == id &&
      other.x == x &&
      other.y == y &&
      other.size == size &&
      other.rotation == rotation;

  @override
  int get hashCode => Object.hash(layer, id, x, y, size, rotation);

  @override
  String toString() => 'PlacedLayer(${toJson()})';
}

/// Shares [shown] places between lines by largest remainder; ties go to the
/// earlier line.
List<int> allocate(List<int> qtys, int shown) {
  final total = qtys.fold(0, (s, q) => s + q);
  if (total == 0 || shown == 0) return List.filled(qtys.length, 0);
  final base = [for (final q in qtys) (q * shown) ~/ total];
  final rem = [for (final q in qtys) (q * shown) % total];
  var left = shown - base.fold(0, (s, b) => s + b);
  final order = List.generate(qtys.length, (i) => i)
    ..sort((a, b) {
      final byRem = rem[b].compareTo(rem[a]);
      return byRem != 0 ? byRem : a.compareTo(b);
    });
  for (final i in order) {
    if (left == 0) break;
    base[i] += 1;
    left -= 1;
  }
  return base;
}

/// Line indexes spread evenly: the line with the largest share still to place
/// goes next, compared by cross-multiplying; ties go to the earlier line.
List<int> interleave(List<int> alloc) {
  final placed = List.filled(alloc.length, 0);
  final sequence = <int>[];
  final n = alloc.fold(0, (s, a) => s + a);
  for (var step = 0; step < n; step++) {
    var best = -1;
    for (var k = 0; k < alloc.length; k++) {
      if (placed[k] >= alloc[k]) continue;
      if (best == -1) {
        best = k;
        continue;
      }
      final left = (alloc[k] - placed[k]) * alloc[best];
      final right = (alloc[best] - placed[best]) * alloc[k];
      if (left > right) best = k;
    }
    placed[best] += 1;
    sequence.add(best);
  }
  return sequence;
}

PlacedLayer _place(LayerKind layer, String id, SlotDto slot) => PlacedLayer(
  layer: layer,
  id: id,
  x: slot.x,
  y: slot.y,
  size: slot.size,
  rotation: slot.rotation,
);

/// Layers back to front: wrap back, greens, flowers (outside in), wrap front,
/// ribbon, extras.
List<PlacedLayer> layoutBouquet(BouquetSpec spec, SizeLayoutDto layout) {
  final out = [_place(LayerKind.wrapBack, spec.wrap, layout.wrapBack)];

  final greens = spec.greens;
  final greenShown = [
    greens.fold(0, (s, l) => s + l.qty),
    layout.greens.length,
  ].reduce((a, b) => a < b ? a : b);
  final greenSeq = interleave(
    allocate([for (final l in greens) l.qty], greenShown),
  );
  for (var j = 0; j < greenSeq.length; j++) {
    final at = (j * layout.greens.length) ~/ greenShown;
    out.add(_place(LayerKind.green, greens[greenSeq[j]].id, layout.greens[at]));
  }

  final flowers = spec.flowers;
  final flowerShown = [
    spec.stems,
    layout.flowers.length,
  ].reduce((a, b) => a < b ? a : b);
  final flowerSeq = interleave(
    allocate([for (final l in flowers) l.qty], flowerShown),
  );
  for (var i = flowerShown - 1; i >= 0; i--) {
    out.add(
      _place(LayerKind.flower, flowers[flowerSeq[i]].id, layout.flowers[i]),
    );
  }

  out
    ..add(_place(LayerKind.wrapFront, spec.wrap, layout.wrapFront))
    ..add(_place(LayerKind.ribbon, spec.ribbon, layout.ribbon));
  final extras = spec.extras.take(layout.extras.length).toList();
  for (var i = 0; i < extras.length; i++) {
    out.add(_place(LayerKind.extra, extras[i].id, layout.extras[i]));
  }
  return out;
}
