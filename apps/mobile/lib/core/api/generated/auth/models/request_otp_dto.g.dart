// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_otp_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestOtpDto _$RequestOtpDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['phone'],
    disallowNullValues: const ['channel', 'phone'],
  );
  return RequestOtpDto(
    channel: RequestOtpDto._presentValue(json, 'channel') == null
        ? RequestOtpDtoChannel.sms
        : RequestOtpDto._read_channel(
            RequestOtpDto._presentValue(json, 'channel') as Object,
          ),
    phone: json['phone'] as String,
    additionalProperties:
        RequestOtpDto._extras(json, 'additionalProperties') == null
        ? const {}
        : RequestOtpDto._readExtras(
            RequestOtpDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$RequestOtpDtoToJson(RequestOtpDto instance) =>
    <String, dynamic>{
      'channel': ?RequestOtpDto._write_channel(instance.channel),
      'phone': instance.phone,
    };
