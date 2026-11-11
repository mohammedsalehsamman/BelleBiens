// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshDto _$RefreshDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['refreshToken'],
    disallowNullValues: const ['refreshToken'],
  );
  return RefreshDto(
    refreshToken: json['refreshToken'] as String,
    additionalProperties:
        RefreshDto._extras(json, 'additionalProperties') == null
        ? const {}
        : RefreshDto._readExtras(
            RefreshDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$RefreshDtoToJson(RefreshDto instance) =>
    <String, dynamic>{'refreshToken': instance.refreshToken};
