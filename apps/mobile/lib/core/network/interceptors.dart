import 'package:dio/dio.dart';

/// Sends the customer's language and the app version on every call, so the
/// server answers in the right language and can ask old apps to update
/// (NFR-INT-05, NFR-CMP-01).
class ContextHeadersInterceptor extends Interceptor {
  new({required this.language, required this.appVersion});

  final String Function() language;
  final String appVersion;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = language();
    options.headers['X-App-Version'] = appVersion;
    handler.next(options);
  }
}

/// What the auth interceptor needs from the session, kept abstract for tests.
abstract class TokenAccess {
  String? get accessToken;
  String? get refreshToken;

  /// Exchanges the refresh token; returns the new access token, or null when
  /// the session is over (the caller is then signed out).
  Future<String?> refresh();
}

/// Adds the bearer token and, when it has expired, refreshes it once and
/// retries. Calls are queued while a refresh runs, so the rotating refresh
/// token is never used twice (which the server treats as theft).
class AuthInterceptor extends QueuedInterceptor {
  new({required this.tokens, required this.retry});

  final TokenAccess tokens;

  /// Sends a request again, without this interceptor's error handling.
  final Future<Response<dynamic>> Function(RequestOptions) retry;

  static const _retried = 'auth.retried';

  bool _isAuthCall(RequestOptions options) =>
      options.path.contains('/v1/auth/');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokens.accessToken;
    if (token != null && !_isAuthCall(options)) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final sentToken = options.headers['Authorization'];
    final expired =
        err.response?.statusCode == 401 &&
        sentToken != null &&
        options.extra[_retried] != true &&
        !_isAuthCall(options);
    if (!expired) return handler.next(err);

    // Another queued call may already have refreshed the token.
    var fresh = tokens.accessToken;
    if (fresh == null || 'Bearer $fresh' == sentToken) {
      fresh = await tokens.refresh();
    }
    if (fresh == null) return handler.next(err);

    options
      ..headers['Authorization'] = 'Bearer $fresh'
      ..extra[_retried] = true;
    try {
      handler.resolve(await retry(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}
