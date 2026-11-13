import 'package:belle_biens/app/l10n/levantine_material_localizations.dart';
import 'package:belle_biens/core/text/digits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final day = DateTime(2026, 11, 13);

  test('Arabic date pickers use Levantine months and Western digits', () async {
    final l = await const BBMaterialLocalizationsDelegate().load(
      const Locale('ar'),
    );
    expect(l.formatMediumDate(day), '13 تشرين الثاني');
    expect(l.formatMonthYear(day), 'تشرين الثاني 2026');
    expect(l.formatFullDate(day), 'الجمعة، 13 تشرين الثاني 2026');
    expect(l.formatShortMonthDay(day), '13 تشرين الثاني');
    expect(l.formatYear(day), '2026');
    expect(l.formatDecimal(13), '13');
    // Flutter's Arabic strings stay.
    expect(l.cancelButtonLabel, 'الإلغاء');
    // Typed dates follow the help text, yyyy/mm/dd.
    expect(l.parseCompactDate('2026/11/13'), day);
  });

  test(
    "the customer's Arabic-Indic digits reach the picker (FR-LOC-02)",
    () async {
      final l = await const BBMaterialLocalizationsDelegate(
        numerals: Numerals.arabic,
      ).load(const Locale('ar'));
      expect(l.formatMonthYear(day), 'تشرين الثاني ٢٠٢٦');
      expect(l.formatDecimal(13), '١٣');
    },
  );

  test('English is left as Flutter writes it', () async {
    final l = await const BBMaterialLocalizationsDelegate().load(
      const Locale('en'),
    );
    expect(l.formatMonthYear(day), 'November 2026');
  });

  test('a change of digits reloads the texts', () {
    const western = BBMaterialLocalizationsDelegate();
    expect(
      const BBMaterialLocalizationsDelegate(numerals: Numerals.arabic)
          .shouldReload(western),
      isTrue,
    );
    expect(
      const BBMaterialLocalizationsDelegate().shouldReload(western),
      isFalse,
    );
  });
}
