import 'package:belle_biens/core/text/digits.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The few key-value operations the app needs, so tests can use memory.
abstract class PreferencesBackend {
  bool? getBool(String key);
  String? getString(String key);
  Future<void> setBool(String key, {required bool value});
  Future<void> setString(String key, String value);
}

class SharedPreferencesBackend implements PreferencesBackend {
  new(this._prefs);

  final SharedPreferencesWithCache _prefs;

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<void> setBool(String key, {required bool value}) =>
      _prefs.setBool(key, value);

  @override
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);
}

class MemoryPreferencesBackend implements PreferencesBackend {
  new([Map<String, Object>? initial]) : values = {...?initial};

  final Map<String, Object> values;

  @override
  bool? getBool(String key) => values[key] as bool?;

  @override
  String? getString(String key) => values[key] as String?;

  @override
  Future<void> setBool(String key, {required bool value}) async =>
      values[key] = value;

  @override
  Future<void> setString(String key, String value) async => values[key] = value;
}

/// Small, non-secret settings kept on the device. Tokens never go here
/// (see SecureTokenStore).
class AppPreferences {
  new(this._backend);

  final PreferencesBackend _backend;

  static const onboardingSeenKey = 'onboarding.seen';
  static const notificationsAskedKey = 'notifications.asked';
  static const languageKey = 'locale.language';
  static const numeralsKey = 'locale.numerals';
  static const displayCurrencyKey = 'display.currency';
  static const recentSearchesKey = 'search.recent';

  static const Set<String> keys = {
    onboardingSeenKey,
    notificationsAskedKey,
    languageKey,
    numeralsKey,
    displayCurrencyKey,
    recentSearchesKey,
  };

  bool get onboardingSeen => _backend.getBool(onboardingSeenKey) ?? false;
  Future<void> setOnboardingSeen() =>
      _backend.setBool(onboardingSeenKey, value: true);

  bool get notificationsAsked =>
      _backend.getBool(notificationsAskedKey) ?? false;
  Future<void> setNotificationsAsked() =>
      _backend.setBool(notificationsAskedKey, value: true);

  /// 'ar' or 'en'; null until the customer picks one.
  String? get language => _backend.getString(languageKey);
  Future<void> setLanguage(String code) =>
      _backend.setString(languageKey, code);

  Numerals get numerals =>
      Numerals.values.asNameMap()[_backend.getString(numeralsKey)] ??
      Numerals.western;
  Future<void> setNumerals(Numerals value) =>
      _backend.setString(numeralsKey, value.name);

  /// 'syp' or 'usd' (screens 06, 07).
  String? get displayCurrency => _backend.getString(displayCurrencyKey);
  Future<void> setDisplayCurrency(String value) =>
      _backend.setString(displayCurrencyKey, value);

  /// JSON list of the latest searches (screen 08).
  String? get recentSearches => _backend.getString(recentSearchesKey);
  Future<void> setRecentSearches(String json) =>
      _backend.setString(recentSearchesKey, json);
}

/// Overridden in `main()` once the preferences are loaded.
final appPreferencesProvider = Provider<AppPreferences>(
  (ref) =>
      throw UnimplementedError('appPreferencesProvider must be overridden'),
);
