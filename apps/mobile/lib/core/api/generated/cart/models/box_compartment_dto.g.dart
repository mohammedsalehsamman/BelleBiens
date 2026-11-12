// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_compartment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoxCompartmentDto _$BoxCompartmentDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['capacity', 'index', 'kind', 'name'],
    disallowNullValues: const ['capacity', 'index', 'kind', 'name'],
  );
  return BoxCompartmentDto(
    capacity: BoxCompartmentDto._read_capacity(json['capacity']),
    index: BoxCompartmentDto._read_index(json['index']),
    kind: BoxCompartmentDto._read_kind(json['kind']),
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    additionalProperties:
        BoxCompartmentDto._extras(json, 'additionalProperties') == null
        ? const {}
        : BoxCompartmentDto._readExtras(
            BoxCompartmentDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$BoxCompartmentDtoToJson(BoxCompartmentDto instance) =>
    <String, dynamic>{
      'capacity': ?BoxCompartmentDto._write_capacity(instance.capacity),
      'index': ?BoxCompartmentDto._write_index(instance.index),
      'kind': ?BoxCompartmentDto._write_kind(instance.kind),
      'name': instance.name.toJson(),
    };
