// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occasion_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OccasionDto _$OccasionDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['heroImage', 'name', 'slug', 'title'],
    disallowNullValues: const ['name', 'slug', 'title'],
  );
  return OccasionDto(
    heroImage: json['heroImage'] as String?,
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    slug: json['slug'] as String,
    title: LocalizedTextDto.fromJson(json['title'] as Map<String, dynamic>),
    additionalProperties:
        OccasionDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OccasionDto._readExtras(
            OccasionDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$OccasionDtoToJson(OccasionDto instance) =>
    <String, dynamic>{
      'heroImage': instance.heroImage,
      'name': instance.name.toJson(),
      'slug': instance.slug,
      'title': instance.title.toJson(),
    };
