import 'dart:async';

import 'package:belle_biens/app/app.dart';
import 'package:belle_biens/app/bootstrap.dart';
import 'package:belle_biens/app/env.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Run with a flavor and its env file, for example:
///   flutter run --flavor dev --dart-define-from-file=env/dev.json
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final env = AppEnv.fromDefines();
  registerFontLicenses();
  final overrides = await appOverrides(env);

  void run() => runApp(
    ProviderScope(
      overrides: overrides,
      retry: appRetry,
      child: const BelleApp(),
    ),
  );

  final dsn = env.sentryDsn;
  if (dsn == null) {
    run();
    return;
  }

  await SentryFlutter.init((options) {
    options
      ..dsn = dsn
      ..environment = env.flavor.name
      // No names, phones or addresses in crash reports (NFR-SEC-09).
      ..sendDefaultPii = false
      ..tracesSampleRate = env.isProduction ? 0.1 : 1.0;
  }, appRunner: run);
}
