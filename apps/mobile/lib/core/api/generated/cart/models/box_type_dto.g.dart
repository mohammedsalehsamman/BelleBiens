// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_type_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoxTypeDto _$BoxTypeDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'basePriceMinor',
      'compartments',
      'detail',
      'fromPriceMinor',
      'id',
      'name',
    ],
    disallowNullValues: const [
      'basePriceMinor',
      'compartments',
      'detail',
      'fromPriceMinor',
      'id',
      'name',
    ],
  );
  return BoxTypeDto(
    basePriceMinor: BoxTypeDto._read_basePriceMinor(json['basePriceMinor']),
    compartments: (json['compartments'] as List<dynamic>)
        .map((e) => BoxCompartmentDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    detail: LocalizedTextDto.fromJson(json['detail'] as Map<String, dynamic>),
    fromPriceMinor: BoxTypeDto._read_fromPriceMinor(json['fromPriceMinor']),
    id: json['id'] as String,
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    additionalProperties:
        BoxTypeDto._extras(json, 'additionalProperties') == null
        ? const {}
        : BoxTypeDto._readExtras(
            BoxTypeDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$BoxTypeDtoToJson(
  BoxTypeDto instance,
) => <String, dynamic>{
  'basePriceMinor': ?BoxTypeDto._write_basePriceMinor(instance.basePriceMinor),
  'compartments': instance.compartments.map((e) => e.toJson()).toList(),
  'detail': instance.detail.toJson(),
  'fromPriceMinor': ?BoxTypeDto._write_fromPriceMinor(instance.fromPriceMinor),
  'id': instance.id,
  'name': instance.name.toJson(),
};
