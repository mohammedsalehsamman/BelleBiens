// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonDto _$PersonDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'phone'],
    disallowNullValues: const ['name', 'phone'],
  );
  return PersonDto(
    name: json['name'] as String,
    phone: json['phone'] as String,
    additionalProperties:
        PersonDto._extras(json, 'additionalProperties') == null
        ? const {}
        : PersonDto._readExtras(
            PersonDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$PersonDtoToJson(PersonDto instance) => <String, dynamic>{
  'name': instance.name,
  'phone': instance.phone,
};
