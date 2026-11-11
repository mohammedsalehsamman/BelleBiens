// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alternative_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlternativeDto _$AlternativeDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'available',
      'id',
      'name',
      'sameColor',
      'unitPriceMinor',
    ],
    disallowNullValues: const ['id', 'name', 'sameColor', 'unitPriceMinor'],
  );
  return AlternativeDto(
    available: AlternativeDto._read_available(json['available']),
    id: json['id'] as String,
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    sameColor: json['sameColor'] as bool,
    unitPriceMinor: AlternativeDto._read_unitPriceMinor(json['unitPriceMinor']),
    additionalProperties:
        AlternativeDto._extras(json, 'additionalProperties') == null
        ? const {}
        : AlternativeDto._readExtras(
            AlternativeDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$AlternativeDtoToJson(AlternativeDto instance) =>
    <String, dynamic>{
      'available': AlternativeDto._write_available(instance.available),
      'id': instance.id,
      'name': instance.name.toJson(),
      'sameColor': instance.sameColor,
      'unitPriceMinor': ?AlternativeDto._write_unitPriceMinor(
        instance.unitPriceMinor,
      ),
    };
