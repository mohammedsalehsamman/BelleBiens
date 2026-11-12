import 'dart:convert';
import 'dart:io';

import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/money/price_quote.dart';
import 'package:belle_biens/features/designer/domain/bouquet_spec.dart';
import 'package:belle_biens/features/designer/domain/layout.dart';
import 'package:flutter_test/flutter_test.dart';

/// The app must give exactly the server's answers for every shared vector
/// (NFR-FUN-01, NFR-MNT-03): pricing, spec hash, 2D layout.
Map<String, Object?> _contract(String path) =>
    jsonDecode(File('../../packages/contracts/$path').readAsStringSync())
        as Map<String, Object?>;

List<Map<String, Object?>> _cases(String path) =>
    (_contract(path)['cases']! as List).cast<Map<String, Object?>>();

void main() {
  group('pricing (vectors/pricing.json)', () {
    final cases = _cases('vectors/pricing.json');
    test('has vectors', () => expect(cases.length, greaterThanOrEqualTo(10)));

    for (final c in cases) {
      test(c['id']! as String, () {
        final input = c['input']! as Map<String, Object?>;
        final settings = input['settings']! as Map<String, Object?>;
        final rounding = settings['rounding']! as Map<String, Object?>;
        final coupon = input['coupon'] as Map<String, Object?>?;
        final quote = priceQuote(
          lines: [
            for (final l in input['lines']! as List)
              PriceLine.fromJson(Map<String, Object?>.from(l as Map)),
          ],
          settings: PriceSettings(
            usdRate: settings['usdRate']! as String,
            assemblyFeeMinor: settings['assemblyFeeMinor']! as int,
            roundingStepMinor: rounding['mode'] == 'nearest'
                ? rounding['stepMinor']! as int
                : null,
          ),
          coupon: coupon == null
              ? null
              : coupon['type'] == 'percent'
              ? PriceCoupon.percent(
                  coupon['value']! as int,
                  minOrderMinor: (coupon['minOrderMinor'] as int?) ?? 0,
                )
              : PriceCoupon.fixed(
                  coupon['valueMinor']! as int,
                  minOrderMinor: (coupon['minOrderMinor'] as int?) ?? 0,
                ),
          deliveryFeeMinor: input['deliveryFeeMinor']! as int,
          displayCurrency: input['displayCurrency']! as String,
        );
        expect(quote.toJson(), c['expected']);
      });
    }
  });

  group('spec hash (vectors/spec-hash.json, FR-DAI-06)', () {
    for (final c in _cases('vectors/spec-hash.json')) {
      test(c['name']! as String, () {
        final json = Map<String, Object?>.from(c['spec']! as Map);
        final spec = BouquetSpec.fromJson(json);
        // The app writes the spec exactly as it read it.
        expect(spec.toJson(), json);
        final rest = Map<String, Object?>.from(json)
          ..remove('cardMessage')
          ..remove('previewMode');
        expect(canonicalJson(rest), c['canonical']);
        expect(spec.hash, c['sha256']);
      });
    }

    test('card message and preview mode do not change the hash', () {
      final spec = BouquetSpec.fromJson(
        Map<String, Object?>.from(
          _cases('vectors/spec-hash.json').first['spec']! as Map,
        ),
      );
      expect(
        spec.copyWith(cardMessage: () => 'x', previewMode: () => 'ai').hash,
        spec.hash,
      );
    });

    test('an unknown schema version is refused', () {
      expect(
        () => BouquetSpec.fromJson(const {'schemaVersion': 2}),
        throwsFormatException,
      );
    });
  });

  group('2D layout (vectors/layout.json, FR-D2D-03)', () {
    final slots = _contract('layouts/bouquet-slots.v1.json');
    final layouts = (slots['layouts']! as Map).map(
      (k, v) => MapEntry(
        k as String,
        SizeLayoutDto.fromJson(Map<String, Object?>.from(v as Map)),
      ),
    );
    final cases = _cases('vectors/layout.json');
    test('has vectors', () => expect(cases.length, greaterThanOrEqualTo(5)));

    for (final c in cases) {
      test(c['name']! as String, () {
        final spec = BouquetSpec.fromJson(
          Map<String, Object?>.from(c['spec']! as Map),
        );
        final expected = [
          for (final i in c['items']! as List)
            PlacedLayer.fromJson(Map<String, Object?>.from(i as Map)),
        ];
        expect(layoutBouquet(spec, layouts[spec.size]!), expected);
      });
    }

    test('helpers', () {
      expect(allocate([50, 30, 20], 60), [30, 18, 12]);
      expect(allocate([1, 1, 1], 2), [1, 1, 0]);
      expect(interleave([4, 2]).join(), '010010');
    });

    test('lays out 100 stems fast enough to redraw on every tap '
        '(NFR-PERF-03)', () {
      final spec = BouquetSpec.fromJson(
        Map<String, Object?>.from(
          cases.firstWhere(
                (c) => c['name'] == 'luxury-100-stems-three-colors',
              )['spec']!
              as Map,
        ),
      );
      final watch = Stopwatch()..start();
      for (var i = 0; i < 1000; i++) {
        layoutBouquet(spec, layouts['luxury']!);
      }
      watch.stop();
      // Under 1 ms per layout: far inside the 200 ms budget.
      expect(watch.elapsedMicroseconds / 1000, lessThan(1000));
    });
  });

  group('BouquetSpec edits', () {
    const base = BouquetSpec(
      occasion: 'birthday',
      size: 'medium',
      flowers: [SpecLine('red_rose', 12), SpecLine('pink_rose', 8)],
      wrap: 'kraft_beige',
      ribbon: 'satin_pink',
    );

    test('withQty adds at the end, changes in place, removes at 0', () {
      final a = base.withQty(SpecList.flowers, 'white_rose', 4);
      expect(a.flowers.map((l) => l.id), [
        'red_rose',
        'pink_rose',
        'white_rose',
      ]);
      expect(a.withQty(SpecList.flowers, 'red_rose', 5).flowers.first.qty, 5);
      expect(
        a.withQty(SpecList.flowers, 'pink_rose', 0).flowers.map((l) => l.id),
        ['red_rose', 'white_rose'],
      );
      expect(a.stems, 24);
    });

    test('replace keeps the place and merges into existing lines '
        '(screen 37)', () {
      final split = base.replace(SpecList.flowers, 'pink_rose', const [
        SpecLine('white_rose', 4),
        SpecLine('red_rose', 4),
      ]);
      expect(split.flowers, const [
        SpecLine('red_rose', 16),
        SpecLine('white_rose', 4),
      ]);
      expect(split.stems, base.stems);
    });

    test('empty optional lists stay out of the JSON', () {
      final json = base.toJson();
      expect(json.containsKey('greens'), isFalse);
      expect(json.containsKey('extras'), isFalse);
      expect(json['schemaVersion'], 1);
    });
  });
}
