import 'package:belle_biens/features/auth/data/auth_repository.dart';

/// What the code screen (04) needs after a code was sent.
class OtpChallenge {
  const new({
    required this.phone,
    required this.maskedPhone,
    required this.codeLength,
    required this.resendAfterSeconds,
    required this.whatsapp,
    this.account,
  });

  /// E.164, as normalized by the server.
  final String phone;

  /// "+963 944 *** 456".
  final String maskedPhone;
  final int codeLength;
  final int resendAfterSeconds;
  final bool whatsapp;

  /// Set when the customer came from the register screen (03).
  final NewAccountFields? account;

  OtpChallenge resent({
    required int resendAfterSeconds,
    required bool whatsapp,
  }) => OtpChallenge(
    phone: phone,
    maskedPhone: maskedPhone,
    codeLength: codeLength,
    resendAfterSeconds: resendAfterSeconds,
    whatsapp: whatsapp,
    account: account,
  );
}
