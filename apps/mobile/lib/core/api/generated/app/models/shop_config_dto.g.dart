// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopConfigDto _$ShopConfigDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['mode', 'timeZone', 'whatsapp', 'workingHours'],
    disallowNullValues: const [
      'acceptsFrom',
      'message',
      'mode',
      'timeZone',
      'workingHours',
    ],
  );
  return ShopConfigDto(
    acceptsFrom: json['acceptsFrom'] as String?,
    message: json['message'] == null
        ? null
        : ShopMessageDto.fromJson(json['message'] as Map<String, dynamic>),
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
      'acceptsFrom': ?instance.acceptsFrom,
      'message': ?instance.message?.toJson(),
      'mode': ?ShopConfigDto._write_mode(instance.mode),
      'timeZone': instance.timeZone,
      'whatsapp': instance.whatsapp,
      'workingHours': instance.workingHours.toJson(),
    };
