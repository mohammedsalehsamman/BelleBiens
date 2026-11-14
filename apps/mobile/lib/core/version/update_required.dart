import 'dart:io' show Platform;

import 'package:belle_biens/app/env.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// NFR-CMP-01: the server answers 426 UPGRADE_REQUIRED to app versions it no
/// longer serves. From then on the app shows only the update screen.
class UpdateRequired extends Notifier<bool> {
  @override
  bool build() => false;

  void require() => state = true;
}

final updateRequiredProvider = NotifierProvider<UpdateRequired, bool>(
  UpdateRequired.new,
);

/// Turns any 426 into [UpdateRequired]; the call still fails as usual.
class UpgradeInterceptor extends Interceptor {
  new(this.onUpgradeRequired);

  final void Function() onUpgradeRequired;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 426) onUpgradeRequired();
    handler.next(err);
  }
}

/// The installed app's id ("com.bellebiens.app"), for the store link.
final appPackageProvider = Provider<String>((ref) => 'com.bellebiens.app');

/// Whether this is an Android build; a provider so tests can choose.
final isAndroidProvider = Provider<bool>((ref) => Platform.isAndroid);

/// Where the new version is: `UPDATE_URL` when the build sets one (an APK on
/// the shop's site, or the App Store page once it exists), otherwise the
/// Play Store page on Android. Null when there is nowhere to send people.
final updateLinkProvider = Provider<Uri?>((ref) {
  final configured = ref.watch(appEnvProvider).updateUrl;
  if (configured != null) return configured;
  if (ref.watch(isAndroidProvider)) {
    return Uri.https('play.google.com', '/store/apps/details', {
      'id': ref.watch(appPackageProvider),
    });
  }
  return null;
});
