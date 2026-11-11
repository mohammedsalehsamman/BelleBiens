import 'package:belle_biens/app/env.dart';
import 'package:belle_biens/core/api/api_providers.dart';
import 'package:belle_biens/core/storage/token_store.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/auth/domain/session.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

/// Answers the refresh endpoint with a fixed status.
class _RefreshServer implements HttpClientAdapter {
  new(this.status);

  final int? status;
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls += 1;
    if (status == null) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      );
    }
    final body = status == 200
        ? '{"accessToken":"access-2","accessTokenExpiresIn":900,'
              '"refreshToken":"refresh-2",'
              '"refreshTokenExpiresAt":"2026-12-11T00:00:00.000Z",'
              '"isNewUser":false,"user":${_userJson()}}'
        : '{"code":"TOKEN_INVALID","status":401,"title":"x","type":"t"}';
    return ResponseBody.fromString(
      body,
      status!,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  String _userJson() =>
      '{"id":"u1","name":"سارة","phone":"+963944123456","email":null,'
      '"role":"CUSTOMER","language":"ar","numerals":"western",'
      '"marketingOptIn":false,"homeArea":null,"termsAccepted":true,'
      '"profileComplete":true,"createdAt":"2026-11-11T00:00:00.000Z"}';

  @override
  void close({bool force = false}) {}
}

(ProviderContainer, MemoryTokenStore, _RefreshServer) _setUp({
  required int? refreshStatus,
}) {
  final store = MemoryTokenStore()
    ..value = Session.fromAuth(testSession()).toJson();
  final server = _RefreshServer(refreshStatus);
  final container = ProviderContainer(
    overrides: [
      appEnvProvider.overrideWithValue(testEnv),
      tokenStoreProvider.overrideWithValue(store),
      plainDioProvider.overrideWithValue(
        Dio(BaseOptions(baseUrl: 'http://api'))..httpClientAdapter = server,
      ),
    ],
  );
  addTearDown(container.dispose);
  return (container, store, server);
}

void main() {
  test('restores the saved session at start', () async {
    final (container, _, _) = _setUp(refreshStatus: 200);
    final session = await container.read(sessionControllerProvider.future);
    expect(session?.user.name, 'سارة');
  });

  test('refresh stores the new tokens', () async {
    final (container, store, _) = _setUp(refreshStatus: 200);
    await container.read(sessionControllerProvider.future);
    final token = await container
        .read(sessionControllerProvider.notifier)
        .refresh();
    expect(token, 'access-2');
    expect(Session.fromJson(store.value!).refreshToken, 'refresh-2');
  });

  test('a refused refresh signs out', () async {
    final (container, store, _) = _setUp(refreshStatus: 401);
    await container.read(sessionControllerProvider.future);
    final token = await container
        .read(sessionControllerProvider.notifier)
        .refresh();
    expect(token, isNull);
    expect(store.value, isNull);
    expect(container.read(sessionControllerProvider).value, isNull);
  });

  test('being offline keeps the session for the next try', () async {
    final (container, store, _) = _setUp(refreshStatus: null);
    await container.read(sessionControllerProvider.future);
    final token = await container
        .read(sessionControllerProvider.notifier)
        .refresh();
    expect(token, isNull);
    expect(store.value, isNotNull);
  });

  test('an unreadable stored session means signed out', () async {
    final store = MemoryTokenStore()..value = 'not json';
    final container = ProviderContainer(
      overrides: [tokenStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    expect(await container.read(sessionControllerProvider.future), isNull);
    expect(store.value, isNull);
  });
}
