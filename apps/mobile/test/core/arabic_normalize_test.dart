import 'dart:convert';
import 'dart:io';

import 'package:belle_biens/core/text/arabic_normalize.dart';
import 'package:flutter_test/flutter_test.dart';

/// Same vectors as the API (packages/contracts/vectors/arabic-normalize.json),
/// so offline search on the phone finds what server search finds (FR-CAT-04).
void main() {
  final vectors = jsonDecode(
    File('../../packages/contracts/vectors/arabic-normalize.json')
        .readAsStringSync(),
  ) as Map<String, Object?>;
  final cases = (vectors['cases']! as List).cast<Map<String, Object?>>();

  test('has vectors to run', () => expect(cases.length, greaterThan(10)));

  for (final c in cases) {
    final input = c['in']! as String;
    final output = c['out']! as String;
    test('${jsonEncode(input)} -> ${jsonEncode(output)}', () {
      expect(normalizeArabic(input), output);
    });
  }

  group('matchesQuery', () {
    test('every word must appear, in any field', () {
      expect(matchesQuery('باقه جوري', ['باقة الجوري الأحمر']), isTrue);
      expect(matchesQuery('جوري فاخرة', ['باقة الجوري الأحمر']), isFalse);
      expect(matchesQuery('red ROSE', ['باقة', 'Red rose bouquet']), isTrue);
    });

    test('an empty query matches nothing', () {
      expect(matchesQuery('  ', ['anything']), isFalse);
    });
  });
}
