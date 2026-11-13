import 'dart:async';

import 'package:belle_biens/core/api/api_providers.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Push notifications (EI-SW-09, FR-NTF-04). FCM needs the shop's Firebase
/// project files (google-services.json, the APNs key), which come with the
/// store accounts (plan section 8); until then the app has no token and
/// order news reaches the customer by WhatsApp or SMS.
abstract class PushService {
  /// This phone's token, or null when push is not available.
  Future<String?> token();

  /// The route a tapped notification opens, e.g. "/orders/BB-1001".
  Stream<String> get taps;
}

/// No Firebase project yet: no token, no taps.
class NoPushService implements PushService {
  @override
  Future<String?> token() async => null;

  @override
  Stream<String> get taps => const Stream.empty();
}

final pushServiceProvider = Provider<PushService>((ref) => NoPushService());

/// Registers this phone's token with the account (or as a guest phone) when
/// the session changes, so the server can push order news to it.
class PushRegistrar {
  new(this._ref);

  final Ref _ref;

  Future<void> register() async {
    final token = await _ref.read(pushServiceProvider).token();
    if (token == null) return;
    final session = _ref.read(sessionControllerProvider).value;
    try {
      await _ref
          .read(belleApiProvider)
          .me
          .meControllerRegisterDevice(
            body: RegisterDeviceDto(
              platform: defaultTargetPlatform == TargetPlatform.iOS
                  ? RegisterDeviceDtoPlatform.ios
                  : RegisterDeviceDtoPlatform.android,
              pushToken: token,
              appVersion: _ref.read(appVersionProvider),
              locale: session?.user.language == MeDtoLanguage.en
                  ? RegisterDeviceDtoLocale.en
                  : RegisterDeviceDtoLocale.ar,
            ),
          );
    } on Object {
      // Tried again at the next start or sign-in.
    }
  }
}

final pushRegistrarProvider = Provider<PushRegistrar>(PushRegistrar.new);

/// Keeps the token registered for whoever is signed in.
final pushSetupProvider = Provider<void>((ref) {
  ref.listen(sessionControllerProvider, (previous, next) {
    if (next.hasValue) unawaited(ref.read(pushRegistrarProvider).register());
  }, fireImmediately: true);
});

/// Routes from tapped notifications.
final StreamProvider<String> pushTapsProvider = StreamProvider<String>(
  (ref) => ref.watch(pushServiceProvider).taps,
);
