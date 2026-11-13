import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/l10n/levantine_material_localizations.dart';
import 'package:belle_biens/app/locale/app_locale.dart';
import 'package:belle_biens/app/router/router.dart';
import 'package:belle_biens/app/theme/bb_theme.dart';
import 'package:belle_biens/core/push/push_service.dart';
import 'package:belle_biens/features/account/application/account_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BelleApp extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Push: keep this phone's token registered, open what a tap points to.
    ref
      ..watch(pushSetupProvider)
      ..listen(pushTapsProvider, (previous, next) {
        final route = next.value;
        if (route != null) ref.read(routerProvider).push(route).ignore();
      });
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: BBTheme.light(),
      locale: ref.watch(appLocaleProvider),
      supportedLocales: supportedAppLocales,
      localizationsDelegates: [
        AppLocalizations.delegate,
        BBMaterialLocalizationsDelegate(numerals: ref.watch(numeralsProvider)),
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: ref.watch(routerProvider),
    );
  }
}
