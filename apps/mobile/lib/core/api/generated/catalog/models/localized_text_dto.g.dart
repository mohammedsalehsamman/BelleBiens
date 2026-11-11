// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localized_text_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalizedTextDto _$LocalizedTextDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['ar', 'en'],
    disallowNullValues: const ['ar', 'en'],
  );
  return LocalizedTextDto(
    ar: json['ar'] as String,
    en: json['en'] as String,
    additionalProperties:
        LocalizedTextDto._extras(json, 'additionalProperties') == null
        ? const {}
        : LocalizedTextDto._readExtras(
            LocalizedTextDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$LocalizedTextDtoToJson(LocalizedTextDto instance) =>
    <String, dynamic>{'ar': instance.ar, 'en': instance.en};
