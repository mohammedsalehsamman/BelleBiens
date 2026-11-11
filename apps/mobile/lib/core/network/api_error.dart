import 'package:dio/dio.dart';

/// A failed API call, read from the server's problem+json body (plan 3.4,
/// rule 8). The server already writes [title] in the customer's language and
/// says what to do next (NFR-INT-05); [code] is stable for app logic.
class ApiError implements Exception {
  const new({
    required this.code,
    required this.status,
    this.title,
    this.extra = const {},
  });

  factory fromDio(DioException error) {
    final response = error.response;
    final data = response?.data;
    if (data is Map && data['code'] is String) {
      return ApiError(
        code: data['code'] as String,
        status: response?.statusCode ?? 0,
        title: data['title'] as String?,
        extra: {
          for (final MapEntry(:key, :value) in data.entries)
            if (key is String &&
                !const {
                  'type',
                  'title',
                  'status',
                  'code',
                  'instance',
                }.contains(key))
              key: value,
        },
      );
    }
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const ApiError(
        code: timeout,
        status: 0,
      ),
      DioExceptionType.connectionError ||
      DioExceptionType.unknown => const ApiError(code: network, status: 0),
      _ => ApiError(code: 'INTERNAL', status: response?.statusCode ?? 0),
    };
  }

  /// No answer from the server: offline, DNS, refused connection.
  static const network = 'NETWORK';

  /// The server took too long.
  static const timeout = 'TIMEOUT';

  final String code;
  final int status;
  final String? title;
  final Map<String, Object?> extra;

  int? get attemptsLeft => extra['attemptsLeft'] as int?;
  int? get retryAfterSeconds => extra['retryAfterSeconds'] as int?;
  bool get isOffline => code == network || code == timeout;

  @override
  String toString() => 'ApiError($status $code)';
}

/// Runs an API call and turns transport errors into [ApiError].
Future<T> guardApi<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (error) {
    throw ApiError.fromDio(error);
  }
}
