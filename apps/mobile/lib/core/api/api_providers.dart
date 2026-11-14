import 'package:belle_biens/app/env.dart';
import 'package:belle_biens/app/locale/app_locale.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/interceptors.dart';
import 'package:belle_biens/core/storage/token_store.dart';
import 'package:belle_biens/core/version/update_required.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The installed app version ("1.0.0+1"), sent as X-App-Version.
/// Overridden in `main()` from package_info_plus.
final appVersionProvider = Provider<String>((ref) => '0.0.0');

final tokenStoreProvider = Provider<TokenStore>((ref) => SecureTokenStore());

BaseOptions _options(AppEnv env) => BaseOptions(
  baseUrl: env.apiBaseUrl.toString(),
  // Mobile networks in Syria are often slow (2.4); generous but bounded.
  connectTimeout: const Duration(seconds: 15),
  sendTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
);

ContextHeadersInterceptor _contextHeaders(Ref ref) => ContextHeadersInterceptor(
  language: () => ref.read(appLocaleProvider).languageCode,
  appVersion: ref.read(appVersionProvider),
);

/// Without the auth interceptor: used for token refresh and for retries, so a
/// refresh can never trigger another refresh.
UpgradeInterceptor _upgrade(Ref ref) => UpgradeInterceptor(
  () => ref.read(updateRequiredProvider.notifier).require(),
);

final plainDioProvider = Provider<Dio>((ref) {
  final dio = Dio(_options(ref.watch(appEnvProvider)))
    ..interceptors.addAll([_contextHeaders(ref), _upgrade(ref)]);
  ref.onDispose(dio.close);
  return dio;
});

final dioProvider = Provider<Dio>((ref) {
  final plain = ref.watch(plainDioProvider);
  final dio = Dio(_options(ref.watch(appEnvProvider)))
    ..interceptors.addAll([
      _contextHeaders(ref),
      _upgrade(ref),
      AuthInterceptor(tokens: SessionTokenAccess(ref), retry: plain.fetch),
    ]);
  ref.onDispose(dio.close);
  return dio;
});

/// Every endpoint, generated from packages/contracts/openapi.yaml (ADR 0004).
final belleApiProvider = Provider<BelleApi>(
  (ref) => BelleApi(ref.watch(dioProvider)),
);

/// Same endpoints without automatic token handling (refresh, sign-out).
final plainBelleApiProvider = Provider<BelleApi>(
  (ref) => BelleApi(ref.watch(plainDioProvider)),
);
