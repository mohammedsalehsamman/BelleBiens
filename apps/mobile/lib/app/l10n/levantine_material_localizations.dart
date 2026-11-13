import 'package:belle_biens/core/text/digits.dart';
import 'package:belle_biens/core/time/date_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

/// Material's own texts (date pickers, dialogs) for the app's languages.
///
/// Arabic keeps Flutter's translations but writes dates the way the rest of
/// the app does (FR-LOC-02/03): Levantine month names ("تشرين الثاني", not
/// "نوفمبر") and the customer's digits, Western by default.
class BBMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const new({this.numerals = Numerals.western});

  final Numerals numerals;

  @override
  bool isSupported(Locale locale) =>
      GlobalMaterialLocalizations.delegate.isSupported(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    // Also loads intl's date data for the locale.
    final base = await GlobalMaterialLocalizations.delegate.load(locale);
    if (locale.languageCode != 'ar') return base;
    return LevantineMaterialLocalizations(numerals);
  }

  @override
  bool shouldReload(BBMaterialLocalizationsDelegate old) =>
      old.numerals != numerals;
}

class LevantineMaterialLocalizations extends MaterialLocalizationAr {
  new(this.numerals)
    : super(
        fullYearFormat: intl.DateFormat.y('en'),
        // Typed dates in the picker's text mode: "2026/11/13".
        compactDateFormat: intl.DateFormat('yyyy/MM/dd', 'en'),
        shortDateFormat: intl.DateFormat('yyyy/MM/dd', 'en'),
        mediumDateFormat: intl.DateFormat.MMMEd('ar'),
        longDateFormat: intl.DateFormat.yMMMMEEEEd('ar'),
        yearMonthFormat: intl.DateFormat.yMMMM('ar'),
        shortMonthDayFormat: intl.DateFormat.MMMd('ar'),
        decimalFormat: intl.NumberFormat.decimalPattern('en'),
        twoDigitZeroPaddedFormat: intl.NumberFormat('00', 'en'),
      );

  final Numerals numerals;

  String _d(String text) => localizeDigits(text, numerals);
  String _month(DateTime date) => levantineMonths[date.month - 1];
  String _weekday(DateTime date) => intl.DateFormat.EEEE('ar').format(date);

  @override
  String formatYear(DateTime date) => _d('${date.year}');

  @override
  String formatMonthYear(DateTime date) => _d('${_month(date)} ${date.year}');

  @override
  String formatShortMonthDay(DateTime date) =>
      _d('${date.day} ${_month(date)}');

  /// The picker's header: the weekday too would cut "تشرين الثاني" short;
  /// the full date (read out by screen readers) keeps it.
  @override
  String formatMediumDate(DateTime date) => formatShortMonthDay(date);

  @override
  String formatFullDate(DateTime date) =>
      _d('${_weekday(date)}، ${date.day} ${_month(date)} ${date.year}');

  @override
  String formatDecimal(int number) => _d(super.formatDecimal(number));
}
