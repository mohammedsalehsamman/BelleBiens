import 'dart:convert';
import 'dart:typed_data';

import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/core/network/interceptors.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Answers like the API: 401 TOKEN_INVALID unless the bearer is "fresh".
class _FakeServer implements HttpClientAdapter {
  /// Headers as they were when each request was sent (Dio edits the
  /// RequestOptions of a retried call in place).
  final requests = <({String path, Map<String, dynamic> headers})>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add((path: options.path, headers: Map.of(options.headers)));
    await Future<void>.delayed(const Duration(milliseconds: 5));
    final authorized = options.headers['Authorization'] == 'Bearer fresh';
    if (options.path.endsWith('/v1/me') && !authorized) {
      return _json(401, {
        'type': 'https://errors.bellebiens.local/TOKEN_INVALID',
        'title': 'انتهت جلستك. سجّل الدخول مرة أخرى.',
        'status': 401,
        'code': 'TOKEN_INVALID',
      });
    }
    return _json(200, {'ok': true});
  }

  ResponseBody _json(int status, Map<String, Object?> body) =>
      ResponseBody.fromString(
        jsonEncode(body),
        status,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );

  @override
  void close({bool force = false}) {}
}

class _FakeTokens implements TokenAccess {
  new({this.access = 'stale', this.refreshSucceeds = true});

  String? access;
  final bool refreshSucceeds;
  int refreshCalls = 0;

  @override
  String? get accessToken => access;

  @override
  String? get refreshToken => 'refresh';

  @override
  Future<String?> refresh() async {
    refreshCalls += 1;
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (!refreshSucceeds) {
      access = null;
      return null;
    }
    return access = 'fresh';
  }
}

(Dio, _FakeServer) _client(_FakeTokens tokens) {
  final server = _FakeServer();
  final plain = Dio(BaseOptions(baseUrl: 'http://api'))
    ..httpClientAdapter = server;
  final dio = Dio(BaseOptions(baseUrl: 'http://api'))
    ..httpClientAdapter = server
    ..interceptors.addAll([
      ContextHeadersInterceptor(language: () => 'ar', appVersion: '1.0.0+1'),
      AuthInterceptor(tokens: tokens, retry: plain.fetch),
    ]);
  return (dio, server);
}

void main() {
  group('AuthInterceptor', () {
    test('adds the bearer, the language and the app version', () async {
      final tokens = _FakeTokens(access: 'fresh');
      final (dio, server) = _client(tokens);
      await dio.get<dynamic>('/v1/me');
      final sent = server.requests.single.headers;
      expect(sent['Authorization'], 'Bearer fresh');
      expect(sent['Accept-Language'], 'ar');
      expect(sent['X-App-Version'], '1.0.0+1');
    });

    test('refreshes once for many expired calls, then retries each', () async {
      final tokens = _FakeTokens();
      final (dio, server) = _client(tokens);

      final results = await Future.wait([
        for (var i = 0; i < 3; i++) dio.get<dynamic>('/v1/me'),
      ]);

      expect(results.map((r) => r.statusCode), everyElement(200));
      // One refresh: the rotating refresh token is never used twice.
      expect(tokens.refreshCalls, 1);
      final retried = server.requests.where(
        (r) => r.headers['Authorization'] == 'Bearer fresh',
      );
      expect(retried, hasLength(3));
    });

    test('never refreshes for sign-in calls', () async {
      final tokens = _FakeTokens();
      final (dio, server) = _client(tokens);
      await dio.post<dynamic>('/v1/auth/otp/request');
      expect(server.requests.single.headers['Authorization'], isNull);
      expect(tokens.refreshCalls, 0);
    });

    test('passes the 401 on when the session cannot be refreshed', () async {
      final tokens = _FakeTokens(refreshSucceeds: false);
      final (dio, _) = _client(tokens);
      await expectLater(
        dio.get<dynamic>('/v1/me'),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            401,
          ),
        ),
      );
      expect(tokens.refreshCalls, 1);
    });
  });

  group('ApiError', () {
    test('reads problem+json: code, title and extra fields', () {
      final error = ApiError.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/v1/auth/otp/verify'),
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 400,
            data: {
              'type': 'https://errors.bellebiens.local/OTP_INVALID',
              'title': 'الرمز غير صحيح.',
              'status': 400,
              'code': 'OTP_INVALID',
              'instance': '/v1/auth/otp/verify',
              'attemptsLeft': 3,
            },
          ),
        ),
      );
      expect(error.code, 'OTP_INVALID');
      expect(error.status, 400);
      expect(error.title, 'الرمز غير صحيح.');
      expect(error.attemptsLeft, 3);
      expect(error.extra.keys, ['attemptsLeft']);
    });

    test('no answer means offline; slow answers mean timeout', () {
      final offline = ApiError.fromDio(
        DioException.connectionError(
          requestOptions: RequestOptions(),
          reason: 'refused',
        ),
      );
      expect(offline.code, ApiError.network);
      expect(offline.isOffline, isTrue);

      final slow = ApiError.fromDio(
        DioException.receiveTimeout(
          timeout: const Duration(seconds: 30),
          requestOptions: RequestOptions(),
        ),
      );
      expect(slow.code, ApiError.timeout);
    });
  });
}
