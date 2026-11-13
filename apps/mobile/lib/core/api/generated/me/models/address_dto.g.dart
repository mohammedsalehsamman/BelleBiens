// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressDto _$AddressDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'area',
      'building',
      'callBeforeArrival',
      'details',
      'floor',
      'id',
      'isDefault',
      'label',
      'landmark',
      'latitude',
      'longitude',
    ],
    disallowNullValues: const [
      'area',
      'building',
      'callBeforeArrival',
      'details',
      'floor',
      'id',
      'isDefault',
      'label',
      'landmark',
      'latitude',
      'longitude',
      'zone',
    ],
  );
  return AddressDto(
    area: json['area'] as String,
    building: json['building'] as String,
    callBeforeArrival: json['callBeforeArrival'] as bool,
    details: json['details'] as String,
    floor: json['floor'] as String,
    id: json['id'] as String,
    isDefault: json['isDefault'] as bool,
    label: json['label'] as String,
    landmark: json['landmark'] as String,
    latitude: json['latitude'] as num,
    longitude: json['longitude'] as num,
    zone: json['zone'] == null
        ? null
        : ZoneDto.fromJson(json['zone'] as Map<String, dynamic>),
    additionalProperties:
        AddressDto._extras(json, 'additionalProperties') == null
        ? const {}
        : AddressDto._readExtras(
            AddressDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$AddressDtoToJson(AddressDto instance) =>
    <String, dynamic>{
      'area': instance.area,
      'building': instance.building,
      'callBeforeArrival': instance.callBeforeArrival,
      'details': instance.details,
      'floor': instance.floor,
      'id': instance.id,
      'isDefault': instance.isDefault,
      'label': instance.label,
      'landmark': instance.landmark,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'zone': ?instance.zone?.toJson(),
    };
