import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_locale.g.dart';

/// Locales the app ships (EI-UI-01). Arabic is the default and is laid out
/// right to left (FR-LOC-01).
const supportedAppLocales = [Locale('ar'), Locale('en')];

/// The customer's chosen language. Switching it must keep the cart and the
/// bouquet in progress (EI-UI-01): both live in their own providers, so only
/// the widgets that read text rebuild. Persisted with the other settings in S1.
@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  @override
  Locale build() => const Locale('ar');

  void select(Locale locale) {
    assert(supportedAppLocales.contains(locale), 'Unsupported locale $locale');
    state = locale;
  }

  void toggle() => state = state.languageCode == 'ar'
      ? const Locale('en')
      : const Locale('ar');
}
