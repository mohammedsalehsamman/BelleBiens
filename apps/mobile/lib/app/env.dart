import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Build environment (plan 3.8). Matches the Android product flavors.
enum AppFlavor { dev, stg, prod }

/// Values injected at build time with
/// `--dart-define-from-file=env/<flavor>.json`.
/// Nothing secret lives here: API keys stay on the server (NFR-SEC-05).
class AppEnv {
  const new({
    required this.flavor,
    required this.apiBaseUrl,
    this.sentryDsn,
    this.updateUrl,
  });

  factory fromDefines() {
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    // 10.0.2.2 is the host machine from the Android emulator.
    const api = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:3000',
    );
    const dsn = String.fromEnvironment('SENTRY_DSN');
    const update = String.fromEnvironment('UPDATE_URL');
    return AppEnv(
      flavor: AppFlavor.values.byName(flavor),
      apiBaseUrl: Uri.parse(api),
      sentryDsn: dsn.isEmpty ? null : dsn,
      updateUrl: update.isEmpty ? null : Uri.parse(update),
    );
  }

  final AppFlavor flavor;
  final Uri apiBaseUrl;
  final String? sentryDsn;

  /// Where the update screen sends people (NFR-CMP-01); see
  /// `updateLinkProvider`.
  final Uri? updateUrl;

  bool get isProduction => flavor == AppFlavor.prod;
}

/// Overridden in `main()` with the real values; tests override it too.
final appEnvProvider = Provider<AppEnv>(
  (ref) => throw UnimplementedError('appEnvProvider must be overridden'),
);
