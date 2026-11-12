// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZoneDto _$ZoneDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['eta', 'feeMinor', 'name', 'slug'],
    disallowNullValues: const ['eta', 'feeMinor', 'name', 'slug'],
  );
  return ZoneDto(
    eta: LocalizedTextDto.fromJson(json['eta'] as Map<String, dynamic>),
    feeMinor: ZoneDto._read_feeMinor(json['feeMinor']),
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    slug: json['slug'] as String,
    additionalProperties: ZoneDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ZoneDto._readExtras(ZoneDto._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$ZoneDtoToJson(ZoneDto instance) => <String, dynamic>{
  'eta': instance.eta.toJson(),
  'feeMinor': ?ZoneDto._write_feeMinor(instance.feeMinor),
  'name': instance.name.toJson(),
  'slug': instance.slug,
};
