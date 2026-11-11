// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VocabularyDto _$VocabularyDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'slug', 'swatch'],
    disallowNullValues: const ['name', 'slug'],
  );
  return VocabularyDto(
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    slug: json['slug'] as String,
    swatch: json['swatch'] as String?,
    additionalProperties:
        VocabularyDto._extras(json, 'additionalProperties') == null
        ? const {}
        : VocabularyDto._readExtras(
            VocabularyDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$VocabularyDtoToJson(VocabularyDto instance) =>
    <String, dynamic>{
      'name': instance.name.toJson(),
      'slug': instance.slug,
      'swatch': instance.swatch,
    };
