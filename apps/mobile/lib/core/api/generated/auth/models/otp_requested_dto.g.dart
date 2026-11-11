// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_requested_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpRequestedDto _$OtpRequestedDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'channel',
      'codeLength',
      'expiresInSeconds',
      'maskedPhone',
      'phone',
      'resendAfterSeconds',
    ],
    disallowNullValues: const [
      'channel',
      'codeLength',
      'expiresInSeconds',
      'maskedPhone',
      'phone',
      'resendAfterSeconds',
    ],
  );
  return OtpRequestedDto(
    channel: OtpRequestedDto._read_channel(json['channel']),
    codeLength: json['codeLength'] as num,
    expiresInSeconds: json['expiresInSeconds'] as num,
    maskedPhone: json['maskedPhone'] as String,
    phone: json['phone'] as String,
    resendAfterSeconds: json['resendAfterSeconds'] as num,
    additionalProperties:
        OtpRequestedDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OtpRequestedDto._readExtras(
            OtpRequestedDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$OtpRequestedDtoToJson(OtpRequestedDto instance) =>
    <String, dynamic>{
      'channel': ?OtpRequestedDto._write_channel(instance.channel),
      'codeLength': instance.codeLength,
      'expiresInSeconds': instance.expiresInSeconds,
      'maskedPhone': instance.maskedPhone,
      'phone': instance.phone,
      'resendAfterSeconds': instance.resendAfterSeconds,
    };
