// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointDto _$PointDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['latitude', 'longitude'],
    disallowNullValues: const ['latitude', 'longitude'],
  );
  return PointDto(
    latitude: json['latitude'] as num,
    longitude: json['longitude'] as num,
    additionalProperties: PointDto._extras(json, 'additionalProperties') == null
        ? const {}
        : PointDto._readExtras(PointDto._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$PointDtoToJson(PointDto instance) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
