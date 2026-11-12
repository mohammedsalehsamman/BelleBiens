// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_address_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderAddressDto _$OrderAddressDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'area',
      'building',
      'details',
      'floor',
      'label',
      'landmark',
      'latitude',
      'longitude',
    ],
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
  return OrderAddressDto(
    area: json['area'] as String,
    building: json['building'] as String,
    details: json['details'] as String,
    floor: json['floor'] as String,
    label: json['label'] as String,
    landmark: json['landmark'] as String,
    latitude: json['latitude'] as num,
    longitude: json['longitude'] as num,
    additionalProperties:
        OrderAddressDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OrderAddressDto._readExtras(
            OrderAddressDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$OrderAddressDtoToJson(OrderAddressDto instance) =>
    <String, dynamic>{
      'area': instance.area,
      'building': instance.building,
      'details': instance.details,
      'floor': instance.floor,
      'label': instance.label,
      'landmark': instance.landmark,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
