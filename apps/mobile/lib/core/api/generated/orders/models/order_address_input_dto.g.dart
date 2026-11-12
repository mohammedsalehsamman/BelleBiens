// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_address_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderAddressInputDto _$OrderAddressInputDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['latitude', 'longitude'],
    disallowNullValues: const [
      'area',
      'building',
      'details',
      'floor',
      'label',
      'landmark',
      'latitude',
      'longitude',
      'save',
    ],
  );
  return OrderAddressInputDto(
    area: json['area'] as String?,
    building: json['building'] as String?,
    details: json['details'] as String?,
    floor: json['floor'] as String?,
    label: json['label'] as String?,
    landmark: json['landmark'] as String?,
    latitude: json['latitude'] as num,
    longitude: json['longitude'] as num,
    save: json['save'] as bool?,
    additionalProperties:
        OrderAddressInputDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OrderAddressInputDto._readExtras(
            OrderAddressInputDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$OrderAddressInputDtoToJson(
  OrderAddressInputDto instance,
) => <String, dynamic>{
  'area': ?instance.area,
  'building': ?instance.building,
  'details': ?instance.details,
  'floor': ?instance.floor,
  'label': ?instance.label,
  'landmark': ?instance.landmark,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'save': ?instance.save,
};
