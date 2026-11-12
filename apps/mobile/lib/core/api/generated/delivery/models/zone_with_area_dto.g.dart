// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_with_area_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZoneWithAreaDto _$ZoneWithAreaDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['eta', 'feeMinor', 'name', 'polygon', 'slug'],
    disallowNullValues: const ['eta', 'feeMinor', 'name', 'polygon', 'slug'],
  );
  return ZoneWithAreaDto(
    eta: LocalizedTextDto.fromJson(json['eta'] as Map<String, dynamic>),
    feeMinor: ZoneWithAreaDto._read_feeMinor(json['feeMinor']),
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    polygon: (json['polygon'] as List<dynamic>)
        .map((e) => (e as List<dynamic>).map((e) => e as num).toList())
        .toList(),
    slug: json['slug'] as String,
    additionalProperties:
        ZoneWithAreaDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ZoneWithAreaDto._readExtras(
            ZoneWithAreaDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$ZoneWithAreaDtoToJson(ZoneWithAreaDto instance) =>
    <String, dynamic>{
      'eta': instance.eta.toJson(),
      'feeMinor': ?ZoneWithAreaDto._write_feeMinor(instance.feeMinor),
      'name': instance.name.toJson(),
      'polygon': instance.polygon,
      'slug': instance.slug,
    };
