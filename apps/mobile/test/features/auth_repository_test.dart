import 'dart:convert';

import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/features/auth/data/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records what the repository sends and answers like the API would.
class _Server implements HttpClientAdapter {
  new(this.reply);

  final (int, Object) Function(String path, Map<String, dynamic> body) reply;
  final sent = <(String, String, Map<String, dynamic>)>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    // Dio hands the encoded body to the adapter as a byte stream.
    final bytes = <int>[
      if (requestStream != null)
        ...await requestStream.expand((c) => c).toList(),
    ];
    final body = bytes.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    sent.add((options.method, options.path, body));
    final (status, data) = reply(options.path, body);
    return ResponseBody.fromString(
      jsonEncode(data),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

const Map<String, Object?> _user = {
  'id': 'u1',
  'name': 'لين',
  'phone': '+963944123456',
  'email': null,
  'role': 'CUSTOMER',
  'language': 'ar',
  'numerals': 'western',
  'marketingOptIn': true,
  'homeArea': 'المزة',
  'termsAccepted': true,
  'profileComplete': true,
  'createdAt': '2026-11-11T12:00:00.000Z',
};

const Map<String, Object?> _session = {
  'accessToken': 'a',
  'accessTokenExpiresIn': 900,
  'refreshToken': 'r',
  'refreshTokenExpiresAt': '2026-12-11T12:00:00.000Z',
  'isNewUser': true,
  'user': _user,
};

(AuthRepository, _Server) _repo(
  (int, Object) Function(String, Map<String, dynamic>) reply,
) {
  final server = _Server(reply);
  final dio = Dio(BaseOptions(baseUrl: 'http://api'))
    ..httpClientAdapter = server;
  return (AuthRepository(BelleApi(dio)), server);
}

void main() {
  test('requestOtp sends the phone and the channel (screens 02, 04)', () async {
    final (repo, server) = _repo(
      (_, _) => (
        202,
        {
          'phone': '+963944123456',
          'maskedPhone': '+963 944 *** 456',
          'channel': 'whatsapp',
          'codeLength': 4,
          'expiresInSeconds': 300,
          'resendAfterSeconds': 60,
        },
      ),
    );

    final sent = await repo.requestOtp('+963944123456', whatsapp: true);

    expect(server.sent.single.$1, 'POST');
    expect(server.sent.single.$2, '/v1/auth/otp/request');
    expect(server.sent.single.$3, {
      'phone': '+963944123456',
      'channel': 'whatsapp',
    });
    expect(sent.maskedPhone, '+963 944 *** 456');
    expect(sent.channel, OtpRequestedDtoChannel.whatsapp);
  });

  test('verifyOtp sends the register fields only for a new account', () async {
    final (repo, server) = _repo((_, _) => (200, _session));

    final session = await repo.verifyOtp(
      phone: '+963944123456',
      code: '4827',
      account: const NewAccountFields(
        name: 'لين',
        homeArea: 'المزة',
        acceptTerms: true,
        marketingOptIn: true,
      ),
    );
    await repo.verifyOtp(phone: '+963944123456', code: '1111');

    expect(server.sent[0].$3, {
      'phone': '+963944123456',
      'code': '4827',
      'name': 'لين',
      'homeArea': 'المزة',
      'acceptTerms': true,
      'marketingOptIn': true,
    });
    // No account fields: nothing but the phone and the code goes out.
    expect(server.sent[1].$3, {'phone': '+963944123456', 'code': '1111'});
    expect(session.isNewUser, isTrue);
    expect(session.user.homeArea, 'المزة');
  });

  test('login and completeProfile hit their endpoints', () async {
    final (repo, server) = _repo(
      (path, _) => (200, path.endsWith('/me') ? _user : _session),
    );
    await repo.login('sara@example.com', 'jasmine-courtyard');
    final user = await repo.completeProfile(name: 'لين', homeArea: 'المزة');

    expect(server.sent[0].$2, '/v1/auth/login');
    expect(server.sent[1].$1, 'PATCH');
    expect(server.sent[1].$2, '/v1/me');
    expect(server.sent[1].$3, {
      'name': 'لين',
      'homeArea': 'المزة',
      'acceptTerms': true,
    });
    expect(user.name, 'لين');
  });

  test('server errors arrive as ApiError with their code', () async {
    final (repo, _) = _repo(
      (_, _) => (
        429,
        {
          'type': 'https://errors.bellebiens.local/OTP_RESEND_TOO_SOON',
          'title': 'انتظر قليلاً قبل طلب رمز جديد.',
          'status': 429,
          'code': 'OTP_RESEND_TOO_SOON',
          'retryAfterSeconds': 42,
        },
      ),
    );
    await expectLater(
      repo.requestOtp('+963944123456'),
      throwsA(
        isA<ApiError>()
            .having((e) => e.code, 'code', 'OTP_RESEND_TOO_SOON')
            .having((e) => e.retryAfterSeconds, 'retry', 42),
      ),
    );
  });
}
