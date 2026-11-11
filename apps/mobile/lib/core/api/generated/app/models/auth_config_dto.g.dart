// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthConfigDto _$AuthConfigDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'google',
      'otpChannels',
      'otpLength',
      'otpResendSeconds',
    ],
    disallowNullValues: const [
      'google',
      'otpChannels',
      'otpLength',
      'otpResendSeconds',
    ],
  );
  return AuthConfigDto(
    google: json['google'] as bool,
    otpChannels: (json['otpChannels'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    otpLength: json['otpLength'] as num,
    otpResendSeconds: json['otpResendSeconds'] as num,
    additionalProperties:
        AuthConfigDto._extras(json, 'additionalProperties') == null
        ? const {}
        : AuthConfigDto._readExtras(
            AuthConfigDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$AuthConfigDtoToJson(AuthConfigDto instance) =>
    <String, dynamic>{
      'google': instance.google,
      'otpChannels': instance.otpChannels,
      'otpLength': instance.otpLength,
      'otpResendSeconds': instance.otpResendSeconds,
    };
