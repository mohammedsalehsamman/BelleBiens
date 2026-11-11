// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpDto _$VerifyOtpDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['code', 'phone'],
    disallowNullValues: const [
      'acceptTerms',
      'code',
      'email',
      'homeArea',
      'marketingOptIn',
      'name',
      'phone',
    ],
  );
  return VerifyOtpDto(
    acceptTerms: json['acceptTerms'] as bool?,
    code: json['code'] as String,
    email: json['email'] as String?,
    homeArea: json['homeArea'] as String?,
    marketingOptIn: json['marketingOptIn'] as bool?,
    name: json['name'] as String?,
    phone: json['phone'] as String,
    additionalProperties:
        VerifyOtpDto._extras(json, 'additionalProperties') == null
        ? const {}
        : VerifyOtpDto._readExtras(
            VerifyOtpDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$VerifyOtpDtoToJson(VerifyOtpDto instance) =>
    <String, dynamic>{
      'acceptTerms': ?instance.acceptTerms,
      'code': instance.code,
      'email': ?instance.email,
      'homeArea': ?instance.homeArea,
      'marketingOptIn': ?instance.marketingOptIn,
      'name': ?instance.name,
      'phone': instance.phone,
    };
