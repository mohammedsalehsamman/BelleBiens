import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/features/catalog/presentation/today_screen.dart';
import 'package:belle_biens/features/designer/domain/layout.dart';
import 'package:flutter/material.dart';

/// The layout canvas (contracts/layouts/bouquet-slots.v1.json).
const designCanvas = Size(1000, 1250);

/// Draws the 2D preview from the layout (FR-D2D-01..04). Each item is drawn
/// in its own color until the shop's cut-out photos arrive (R-02); a missing
/// item or color falls back to a neutral one, never an error (FR-D2D-06).
class BouquetPainter extends CustomPainter {
  new({required this.layers, required this.items});

  final List<PlacedLayer> layers;
  final Map<String, DesignerItemDto> items;

  static const _neutral = Color(0xFFE2D6D0);

  Color _color(String id, Color fallback) {
    final swatch = items[id]?.swatch;
    return swatch == null ? fallback : swatchColor(swatch);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / designCanvas.width);
    for (final layer in layers) {
      final at = Offset(layer.x.toDouble(), layer.y.toDouble());
      final s = layer.size.toDouble();
      switch (layer.layer) {
        case LayerKind.wrapBack:
          _wrapBack(canvas, at, s, layer.id);
        case LayerKind.green:
          _leaf(canvas, at, s, layer.rotation, _color(layer.id, _neutral));
        case LayerKind.flower:
          if (items[layer.id]?.type2 == DesignerPart.filler) {
            _filler(canvas, at, s, _color(layer.id, Colors.white));
          } else {
            _bloom(canvas, at, s, layer.rotation, _color(layer.id, _neutral));
          }
        case LayerKind.wrapFront:
          _wrapFront(canvas, at, s, layer.id);
        case LayerKind.ribbon:
          _bow(canvas, at, s, _color(layer.id, _neutral));
        case LayerKind.extra:
          _extra(canvas, at, s, layer.rotation, layer.id);
      }
    }
    canvas.restore();
  }

  static Color _shade(Color c, double amount) =>
      Color.lerp(c, const Color(0xFF2C2422), amount)!;

  static Color _tint(Color c, double amount) =>
      Color.lerp(c, Colors.white, amount)!;

  /// Light colors (white roses, gypsophila) get an outline so they show.
  static bool _isLight(Color c) => c.computeLuminance() > 0.75;

  bool _isClear(String id) => id == 'transparent';

  void _wrapBack(Canvas canvas, Offset at, double w, String id) {
    if (id.contains('box')) return; // a box has no back fold
    final color = _color(id, const Color(0xFFC8A97E));
    final path = Path()
      ..moveTo(at.dx - w * 0.5, at.dy - w * 0.42)
      ..quadraticBezierTo(
        at.dx,
        at.dy - w * 0.66,
        at.dx + w * 0.5,
        at.dy - w * 0.42,
      )
      ..lineTo(at.dx + w * 0.1, at.dy + w * 0.6)
      ..lineTo(at.dx - w * 0.1, at.dy + w * 0.6)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = _isClear(id)
            ? color.withValues(alpha: 0.45)
            : _shade(color, 0.18),
    );
  }

  void _wrapFront(Canvas canvas, Offset at, double w, String id) {
    final color = _color(id, const Color(0xFFC8A97E));
    if (id.contains('box')) {
      final box = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: at.translate(0, -w * 0.05),
          width: w * 0.9,
          height: w * 0.42,
        ),
        Radius.circular(w * 0.08),
      );
      canvas
        ..drawRRect(box, Paint()..color = color)
        ..drawRRect(
          box,
          Paint()
            ..color = _tint(color, 0.25)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 6,
        );
      return;
    }
    final path = Path()
      ..moveTo(at.dx - w * 0.5, at.dy - w * 0.34)
      ..quadraticBezierTo(
        at.dx,
        at.dy - w * 0.1,
        at.dx + w * 0.5,
        at.dy - w * 0.34,
      )
      ..lineTo(at.dx + w * 0.12, at.dy + w * 0.42)
      ..lineTo(at.dx - w * 0.12, at.dy + w * 0.42)
      ..close();
    canvas
      ..drawPath(
        path,
        Paint()..color = _isClear(id) ? color.withValues(alpha: 0.35) : color,
      )
      // A soft fold line down the middle.
      ..drawLine(
        at.translate(0, -w * 0.2),
        at.translate(0, w * 0.4),
        Paint()
          ..color = _shade(color, 0.12).withValues(alpha: 0.5)
          ..strokeWidth = 4,
      );
  }

  void _leaf(Canvas canvas, Offset at, double s, int rotation, Color color) {
    canvas
      ..save()
      ..translate(at.dx, at.dy)
      ..rotate(rotation * math.pi / 180);
    // Long leaves reaching in towards the flowers and out past them.
    final leaf = Rect.fromCenter(
      center: Offset(0, -s * 0.15),
      width: s * 0.4,
      height: s * 1.3,
    );
    canvas
      ..drawOval(leaf, Paint()..color = color)
      ..drawLine(
        Offset(0, s * 0.45),
        Offset(0, -s * 0.75),
        Paint()
          ..color = _shade(color, 0.25)
          ..strokeWidth = s * 0.03,
      )
      ..restore();
  }

  void _bloom(Canvas canvas, Offset at, double s, int rotation, Color color) {
    final r = s / 2;
    final outline = Paint()
      ..color = _shade(color, _isLight(color) ? 0.25 : 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.05;
    canvas
      ..save()
      ..translate(at.dx, at.dy)
      ..rotate(rotation * math.pi / 180);
    // Outer petals, then a smaller ring, then the curled centre.
    for (var k = 0; k < 6; k++) {
      canvas
        ..save()
        ..rotate(k * math.pi / 3);
      final petal = Rect.fromCenter(
        center: Offset(0, -r * 0.48),
        width: r * 0.82,
        height: r * 0.98,
      );
      canvas
        ..drawOval(petal, Paint()..color = _shade(color, 0.06))
        ..drawOval(petal, outline)
        ..restore();
    }
    for (var k = 0; k < 5; k++) {
      canvas
        ..save()
        ..rotate(k * 2 * math.pi / 5 + 0.3)
        ..drawOval(
          Rect.fromCenter(
            center: Offset(0, -r * 0.26),
            width: r * 0.6,
            height: r * 0.62,
          ),
          Paint()..color = _tint(color, 0.08),
        )
        ..restore();
    }
    canvas
      ..drawCircle(Offset.zero, r * 0.3, Paint()..color = _shade(color, 0.22))
      ..drawArc(
        Rect.fromCircle(center: Offset.zero, radius: r * 0.18),
        0,
        math.pi * 1.4,
        false,
        outline,
      )
      ..restore();
  }

  void _filler(Canvas canvas, Offset at, double s, Color color) {
    const dots = [
      Offset.zero,
      Offset(-0.22, -0.12),
      Offset(0.24, -0.08),
      Offset(-0.08, 0.24),
      Offset(0.18, 0.2),
      Offset(-0.26, 0.14),
      Offset(0.04, -0.28),
    ];
    final fill = Paint()..color = color;
    final edge = Paint()
      ..color = const Color(0xFFB9ADA9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.015;
    for (final d in dots) {
      final c = at + Offset(d.dx * s, d.dy * s);
      canvas
        ..drawCircle(c, s * 0.1, fill)
        ..drawCircle(c, s * 0.1, edge);
    }
  }

  void _bow(Canvas canvas, Offset at, double s, Color color) {
    final paint = Paint()..color = color;
    final edge = Paint()
      ..color = _shade(color, 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.025;
    for (final side in [-1, 1]) {
      canvas
        ..save()
        ..translate(at.dx + side * s * 0.22, at.dy)
        ..rotate(side * 0.5);
      final loop = Rect.fromCenter(
        center: Offset.zero,
        width: s * 0.42,
        height: s * 0.26,
      );
      canvas
        ..drawOval(loop, paint)
        ..drawOval(loop, edge)
        ..restore()
        ..drawLine(
          at,
          at.translate(side * s * 0.18, s * 0.5),
          Paint()
            ..color = color
            ..strokeWidth = s * 0.08
            ..strokeCap = StrokeCap.round,
        );
    }
    canvas
      ..drawCircle(at, s * 0.09, paint)
      ..drawCircle(at, s * 0.09, edge);
  }

  void _extra(Canvas canvas, Offset at, double s, int rotation, String id) {
    canvas
      ..save()
      ..translate(at.dx, at.dy)
      ..rotate(rotation * math.pi / 180);
    if (id.contains('teddy')) {
      final fur = Paint()..color = const Color(0xFFB07A4E);
      final dark = Paint()..color = const Color(0xFF6B4423);
      canvas
        ..drawCircle(Offset(0, s * 0.18), s * 0.3, fur)
        ..drawCircle(Offset(0, -s * 0.2), s * 0.22, fur)
        ..drawCircle(Offset(-s * 0.17, -s * 0.38), s * 0.09, fur)
        ..drawCircle(Offset(s * 0.17, -s * 0.38), s * 0.09, fur)
        ..drawCircle(Offset(-s * 0.07, -s * 0.24), s * 0.025, dark)
        ..drawCircle(Offset(s * 0.07, -s * 0.24), s * 0.025, dark)
        ..drawCircle(Offset(0, -s * 0.14), s * 0.035, dark);
    } else if (id.contains('balloon')) {
      canvas
        ..drawLine(
          Offset(0, s * 0.1),
          Offset(0, s * 0.5),
          Paint()
            ..color = const Color(0xFF887175)
            ..strokeWidth = s * 0.015,
        )
        ..drawOval(
          Rect.fromCenter(
            center: Offset(0, -s * 0.15),
            width: s * 0.5,
            height: s * 0.6,
          ),
          Paint()..color = const Color(0xFFE8A3B5),
        );
    } else if (id.contains('candle')) {
      canvas
        ..drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(0, s * 0.1),
              width: s * 0.36,
              height: s * 0.5,
            ),
            Radius.circular(s * 0.05),
          ),
          Paint()..color = const Color(0xFFF6EBDD),
        )
        ..drawOval(
          Rect.fromCenter(
            center: Offset(0, -s * 0.25),
            width: s * 0.1,
            height: s * 0.18,
          ),
          Paint()..color = const Color(0xFFF2C94C),
        );
    } else {
      // Chocolate box, gift card and anything else: a small wrapped box.
      final color = id.contains('chocolate')
          ? const Color(0xFF5C3A2E)
          : const Color(0xFFE9D8E4);
      final box = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: s * 0.6, height: s * 0.5),
        Radius.circular(s * 0.06),
      );
      final ribbon = Paint()
        ..color = const Color(0xFFC9A227)
        ..strokeWidth = s * 0.05;
      canvas
        ..drawRRect(box, Paint()..color = color)
        ..drawLine(Offset(0, -s * 0.25), Offset(0, s * 0.25), ribbon)
        ..drawLine(Offset(-s * 0.3, 0), Offset(s * 0.3, 0), ribbon);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(BouquetPainter oldDelegate) =>
      !_sameLayers(oldDelegate.layers, layers) ||
      !identical(oldDelegate.items, items);

  static bool _sameLayers(List<PlacedLayer> a, List<PlacedLayer> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// The preview as a 1080 x 1350 PNG (FR-D2D-05): for WhatsApp, the cart and
/// the florist's recipe. Fixed size, so it looks the same from every phone.
Future<Uint8List> renderBouquetPng(
  List<PlacedLayer> layers,
  Map<String, DesignerItemDto> items, {
  Color background = const Color(0xFFFBEFEC),
}) async {
  const size = Size(1080, 1350);
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)
    ..drawRect(Offset.zero & size, Paint()..color = background);
  BouquetPainter(layers: layers, items: items).paint(canvas, size);
  final image = await recorder.endRecording().toImage(
    size.width.toInt(),
    size.height.toInt(),
  );
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return bytes!.buffer.asUint8List();
}
