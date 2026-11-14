import 'dart:io';

import 'package:belle_biens/app/l10n/app_texts_delegate.dart';
import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/l10n/gen/digit_localizations.dart';
import 'package:belle_biens/core/text/digits.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../tool/gen_digit_localizations.dart' as tool;

void main() {
  test('the digit wrapper is up to date with the texts (run the tool)', () {
    // dart format moves lines and adds trailing commas; names and calls stay.
    String bare(String s) => s.replaceAll(RegExp(r'[\s,]+'), '');
    final expected = tool.digitLocalizationsSource(
      File(tool.source).readAsStringSync(),
    );
    expect(
      bare(File(tool.target).readAsStringSync()),
      bare(expected),
      reason: 'dart run tool/gen_digit_localizations.dart',
    );
  });

  group('Arabic-Indic digits inside messages (FR-LOC-02)', () {
    final ar = DigitLocalizations(
      lookupAppLocalizations(const Locale('ar')),
      Numerals.arabic,
    );

    test('counts, times and dates', () {
      expect(ar.shopResultsCount(20), '٢٠ منتجاً');
      expect(ar.shopUntil('24:00'), 'حتى ٢٤:٠٠');
      expect(ar.checkoutSlot('20:00', '22:00'), contains('٢٠:٠٠'));
    });

    test('identifiers and labels stay as written', () {
      expect(ar.orderTitle('BB-1002'), contains('BB-1002'));
      expect(ar.designerModeSoon, contains('2D'));
      expect(ar.localeName, 'ar');
    });
  });

  test('Western digits use the texts as they are', () async {
    final texts = await const AppTextsDelegate().load(const Locale('ar'));
    expect(texts, isNot(isA<DigitLocalizations>()));
    expect(texts.shopResultsCount(20), '20 منتجاً');
    final arabic = await const AppTextsDelegate(numerals: Numerals.arabic)
        .load(const Locale('ar'));
    expect(arabic.shopResultsCount(20), '٢٠ منتجاً');
    expect(
      const AppTextsDelegate(numerals: Numerals.arabic)
          .shouldReload(const AppTextsDelegate()),
      isTrue,
    );
  });
}
