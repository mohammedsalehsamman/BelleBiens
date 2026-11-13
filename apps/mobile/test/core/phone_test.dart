import 'dart:convert';
import 'dart:io';

import 'package:belle_biens/core/text/digits.dart';
import 'package:belle_biens/core/validation/phone.dart';
import 'package:flutter_test/flutter_test.dart';

/// The same vectors the API passes (ADR 0004, NFR-MNT-03).
List<({String input, String? output})> _vectors() {
  final file = File('../../packages/contracts/vectors/phone.json');
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return [
    for (final c in json['cases'] as List<dynamic>)
      (
        input: (c as Map<String, dynamic>)['in'] as String,
        output: c['out'] as String?,
      ),
  ];
}

void main() {
  group('normalizePhone matches contracts/vectors/phone.json (FR-CRT-09)', () {
    final vectors = _vectors();

    test('has vectors to run', () {
      expect(vectors.length, greaterThan(10));
    });

    for (final v in vectors) {
      test('${jsonEncode(v.input)} -> ${v.output}', () {
        expect(normalizePhone(v.input), v.output);
      });
    }
  });

  group('digits (FR-LOC-02)', () {
    test('localizeDigits keeps Western digits by default', () {
      expect(localizeDigits('7,266 ل.س', Numerals.western), '7,266 ل.س');
    });

    test('localizeDigits writes Arabic-Indic digits on request', () {
      expect(localizeDigits('7,266 ل.س', Numerals.arabic), '٧٬٢٦٦ ل.س');
      expect(localizeDigits(r'$60.55', Numerals.arabic), r'$٦٠٫٥٥');
      // Only between digits: the "ل.س" point and a trailing comma stay.
      expect(localizeDigits('3, 4.', Numerals.arabic), '٣, ٤.');
      expect(localizeDigits('00:42', Numerals.arabic), '٠٠:٤٢');
    });

    test('westernizeDigits reads both Arabic digit sets', () {
      expect(westernizeDigits('٠٩٤٤ ۱۲۳'), '0944 123');
    });
  });
}
