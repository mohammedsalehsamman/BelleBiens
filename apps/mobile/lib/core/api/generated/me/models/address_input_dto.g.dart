// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressInputDto _$AddressInputDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['label', 'latitude', 'longitude'],
    disallowNullValues: const [
      'area',
      'building',
      'details',
      'floor',
      'label',
      'landmark',
      'latitude',
      'longitude',
    ],
  );
  return AddressInputDto(
    area: json['area'] as String?,
    building: json['building'] as String?,
    details: json['details'] as String?,
    floor: json['floor'] as String?,
    label: json['label'] as String,
    landmark: json['landmark'] as String?,
    latitude: json['latitude'] as num,
    longitude: json['longitude'] as num,
    additionalProperties:
        AddressInputDto._extras(json, 'additionalProperties') == null
        ? const {}
        : AddressInputDto._readExtras(
            AddressInputDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$AddressInputDtoToJson(AddressInputDto instance) =>
    <String, dynamic>{
      'area': ?instance.area,
      'building': ?instance.building,
      'details': ?instance.details,
      'floor': ?instance.floor,
      'label': instance.label,
      'landmark': ?instance.landmark,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
