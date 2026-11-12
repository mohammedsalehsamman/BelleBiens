// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnerDto _$OwnerDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(json, disallowNullValues: const ['phone']);
  return OwnerDto(
    phone: json['phone'] as String?,
    additionalProperties: OwnerDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OwnerDto._readExtras(OwnerDto._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$OwnerDtoToJson(OwnerDto instance) => <String, dynamic>{
  'phone': ?instance.phone,
};
