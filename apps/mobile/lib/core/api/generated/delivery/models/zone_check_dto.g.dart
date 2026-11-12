// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_check_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZoneCheckDto _$ZoneCheckDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['inZone'],
    disallowNullValues: const ['inZone', 'zone'],
  );
  return ZoneCheckDto(
    inZone: json['inZone'] as bool,
    zone: json['zone'] == null
        ? null
        : ZoneDto.fromJson(json['zone'] as Map<String, dynamic>),
    additionalProperties:
        ZoneCheckDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ZoneCheckDto._readExtras(
            ZoneCheckDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$ZoneCheckDtoToJson(ZoneCheckDto instance) =>
    <String, dynamic>{
      'inZone': instance.inZone,
      'zone': ?instance.zone?.toJson(),
    };
