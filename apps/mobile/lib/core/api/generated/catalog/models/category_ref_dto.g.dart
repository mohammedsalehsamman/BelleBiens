// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_ref_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryRefDto _$CategoryRefDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'slug'],
    disallowNullValues: const ['name', 'slug'],
  );
  return CategoryRefDto(
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    slug: json['slug'] as String,
    additionalProperties:
        CategoryRefDto._extras(json, 'additionalProperties') == null
        ? const {}
        : CategoryRefDto._readExtras(
            CategoryRefDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$CategoryRefDtoToJson(CategoryRefDto instance) =>
    <String, dynamic>{'name': instance.name.toJson(), 'slug': instance.slug};
