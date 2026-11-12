// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipient_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipientDto _$RecipientDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'phone'],
    disallowNullValues: const ['name', 'phone'],
  );
  return RecipientDto(
    name: json['name'] as String,
    phone: json['phone'] as String,
    additionalProperties:
        RecipientDto._extras(json, 'additionalProperties') == null
        ? const {}
        : RecipientDto._readExtras(
            RecipientDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$RecipientDtoToJson(RecipientDto instance) =>
    <String, dynamic>{'name': instance.name, 'phone': instance.phone};
