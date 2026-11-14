import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/l10n/gen/digit_localizations.dart';
import 'package:belle_biens/core/text/digits.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// The app's texts, with the numbers inside messages ("20 منتجاً") in the
/// customer's digits (FR-LOC-02), like prices and dates.
class AppTextsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const new({this.numerals = Numerals.western});

  final Numerals numerals;

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.delegate.isSupported(locale);

  @override
  Future<AppLocalizations> load(Locale locale) {
    final texts = lookupAppLocalizations(locale);
    return SynchronousFuture(
      numerals == Numerals.western
          ? texts
          : DigitLocalizations(texts, numerals),
    );
  }

  @override
  bool shouldReload(AppTextsDelegate old) => old.numerals != numerals;
}
