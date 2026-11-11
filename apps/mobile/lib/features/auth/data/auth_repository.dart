import 'package:belle_biens/core/api/api_providers.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Profile fields from the register screen (03), sent with the code.
class NewAccountFields {
  const new({
    required this.name,
    required this.acceptTerms,
    required this.marketingOptIn,
    this.email,
    this.homeArea,
  });

  final String name;
  final String? email;
  final String? homeArea;
  final bool acceptTerms;
  final bool marketingOptIn;
}

/// Sign-in calls (screens 02 to 04). Every method throws [ApiError].
class AuthRepository {
  new(this._api);

  final BelleApi _api;

  Future<OtpRequestedDto> requestOtp(String phone, {bool whatsapp = false}) =>
      guardApi(
        () => _api.auth.authControllerRequestOtp(
          body: RequestOtpDto(
            phone: phone,
            channel: whatsapp
                ? RequestOtpDtoChannel.whatsapp
                : RequestOtpDtoChannel.sms,
          ),
        ),
      );

  Future<AuthSessionDto> verifyOtp({
    required String phone,
    required String code,
    NewAccountFields? account,
  }) => guardApi(
    () => _api.auth.authControllerVerifyOtp(
      body: VerifyOtpDto(
        phone: phone,
        code: code,
        name: account?.name,
        email: account?.email,
        homeArea: account?.homeArea,
        acceptTerms: account?.acceptTerms,
        marketingOptIn: account?.marketingOptIn,
      ),
    ),
  );

  Future<AuthSessionDto> login(String email, String password) => guardApi(
    () => _api.auth.authControllerLogin(
      body: LoginDto(email: email, password: password),
    ),
  );

  Future<MeDto> completeProfile({
    required String name,
    String? homeArea,
    bool? marketingOptIn,
  }) => guardApi(
    () => _api.me.meControllerUpdate(
      body: UpdateMeDto(
        name: name,
        homeArea: homeArea,
        marketingOptIn: marketingOptIn,
        acceptTerms: true,
      ),
    ),
  );
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(belleApiProvider)),
);
