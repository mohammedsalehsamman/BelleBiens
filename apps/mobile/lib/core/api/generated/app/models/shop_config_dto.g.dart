// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopConfigDto _$ShopConfigDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['mode', 'timeZone', 'whatsapp', 'workingHours'],
    disallowNullValues: const ['mode', 'timeZone', 'workingHours'],
  );
  return ShopConfigDto(
    mode: ShopConfigDto._read_mode(json['mode']),
    timeZone: json['timeZone'] as String,
    whatsapp: json['whatsapp'] as String?,
    workingHours: WorkingHoursDto.fromJson(
      json['workingHours'] as Map<String, dynamic>,
    ),
    additionalProperties:
        ShopConfigDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ShopConfigDto._readExtras(
            ShopConfigDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$ShopConfigDtoToJson(ShopConfigDto instance) =>
    <String, dynamic>{
      'mode': ?ShopConfigDto._write_mode(instance.mode),
      'timeZone': instance.timeZone,
      'whatsapp': instance.whatsapp,
      'workingHours': instance.workingHours.toJson(),
    };
