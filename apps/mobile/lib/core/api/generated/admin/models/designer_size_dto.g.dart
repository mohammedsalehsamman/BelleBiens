// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'designer_size_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DesignerSizeDto _$DesignerSizeDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['key', 'maxStems', 'minStems', 'name'],
    disallowNullValues: const ['key', 'maxStems', 'minStems', 'name'],
  );
  return DesignerSizeDto(
    key: DesignerSizeDto._read_key(json['key']),
    maxStems: DesignerSizeDto._read_maxStems(json['maxStems']),
    minStems: DesignerSizeDto._read_minStems(json['minStems']),
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    additionalProperties:
        DesignerSizeDto._extras(json, 'additionalProperties') == null
        ? const {}
        : DesignerSizeDto._readExtras(
            DesignerSizeDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$DesignerSizeDtoToJson(DesignerSizeDto instance) =>
    <String, dynamic>{
      'key': ?DesignerSizeDto._write_key(instance.key),
      'maxStems': ?DesignerSizeDto._write_maxStems(instance.maxStems),
      'minStems': ?DesignerSizeDto._write_minStems(instance.minStems),
      'name': instance.name.toJson(),
    };
