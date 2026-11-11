import 'package:belle_biens/app/env.dart';
import 'package:belle_biens/app/preferences.dart';
import 'package:belle_biens/core/api/api_providers.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Everything the app reads from the device before the first frame. Shared by
/// `main()` and the end-to-end tests in integration_test/.
Future<List<Override>> appOverrides(AppEnv env) async {
  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: AppPreferences.keys,
    ),
  );
  final package = await PackageInfo.fromPlatform();
  return [
    appEnvProvider.overrideWithValue(env),
    appPreferencesProvider.overrideWithValue(
      AppPreferences(SharedPreferencesBackend(prefs)),
    ),
    appVersionProvider.overrideWithValue(
      '${package.version}+${package.buildNumber}',
    ),
  ];
}

/// The bundled fonts are under the SIL Open Font License, which asks for the
/// license to ship with the app (LEG-04). They appear in the licenses page.
void registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (name, path) in const [
      ('IBM Plex Sans Arabic', 'assets/fonts/ibm_plex_sans_arabic/OFL.txt'),
      ('Playfair Display', 'assets/fonts/playfair_display/OFL.txt'),
    ]) {
      yield LicenseEntryWithLineBreaks([
        name,
      ], await rootBundle.loadString(path));
    }
  });
}

/// When a provider fails, try again only if the network dropped: three
/// times, waiting 1, 2 and 4 seconds. A server answer (404, 400) is final,
/// and screens offer their own retry button.
Duration? appRetry(int retryCount, Object error) {
  if (error is! ApiError || !error.isOffline || retryCount >= 3) return null;
  return Duration(seconds: 1 << retryCount);
}
