@Tags(['golden'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/features/designer/domain/bouquet_spec.dart';
import 'package:belle_biens/features/designer/domain/layout.dart';
import 'package:belle_biens/features/designer/presentation/bouquet_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The 2D preview of the layout vectors, drawn by the painter (FR-D2D-01..04).
/// The same spec must always give the same picture; update on purpose with
/// flutter test --update-goldens --tags golden.
void main() {
  final catalog = DesignerCatalogDto.fromJson(
    jsonDecode(File('test/fixtures/designer/catalog.json').readAsStringSync())
        as Map<String, Object?>,
  );
  final items = {for (final i in catalog.items) i.id: i};
  final vectors = jsonDecode(
    File('../../packages/contracts/vectors/layout.json').readAsStringSync(),
  ) as Map<String, Object?>;

  for (final name in [
    'readme-designed-bouquet',
    'luxury-100-stems-three-colors',
    'medium-few-greens-five-extras',
  ]) {
    testWidgets('bouquet preview: $name', (tester) async {
      final vector = (vectors['cases']! as List)
          .cast<Map<String, Object?>>()
          .firstWhere((c) => c['name'] == name);
      final spec = BouquetSpec.fromJson(
        Map<String, Object?>.from(vector['spec']! as Map),
      );
      final layout = catalog.layouts.sizes.firstWhere(
        (l) => l.size.toJson() == spec.size,
      );
      await tester.pumpWidget(
        Center(
          child: RepaintBoundary(
            child: SizedBox(
              width: 400,
              height: 500,
              child: ColoredBox(
                color: const Color(0xFFFBEFEC),
                child: CustomPaint(
                  painter: BouquetPainter(
                    layers: layoutBouquet(spec, layout),
                    items: items,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(RepaintBoundary).first,
        matchesGoldenFile('goldens/preview_$name.png'),
      );
    });
  }
}
