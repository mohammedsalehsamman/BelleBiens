// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_device_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterDeviceDto _$RegisterDeviceDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['platform', 'pushToken'],
    disallowNullValues: const ['appVersion', 'locale', 'platform', 'pushToken'],
  );
  return RegisterDeviceDto(
    appVersion: json['appVersion'] as String?,
    locale: RegisterDeviceDto._read_locale(json['locale']),
    platform: RegisterDeviceDto._read_platform(json['platform']),
    pushToken: json['pushToken'] as String,
    additionalProperties:
        RegisterDeviceDto._extras(json, 'additionalProperties') == null
        ? const {}
        : RegisterDeviceDto._readExtras(
            RegisterDeviceDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$RegisterDeviceDtoToJson(RegisterDeviceDto instance) =>
    <String, dynamic>{
      'appVersion': ?instance.appVersion,
      'locale': ?RegisterDeviceDto._write_locale(instance.locale),
      'platform': ?RegisterDeviceDto._write_platform(instance.platform),
      'pushToken': instance.pushToken,
    };
