// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageDto _$PageDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['body', 'slug', 'title', 'updatedAt'],
    disallowNullValues: const ['body', 'slug', 'title', 'updatedAt'],
  );
  return PageDto(
    body: LocalizedTextDto.fromJson(json['body'] as Map<String, dynamic>),
    slug: json['slug'] as String,
    title: LocalizedTextDto.fromJson(json['title'] as Map<String, dynamic>),
    updatedAt: PageDto._read_updatedAt(json['updatedAt']),
    additionalProperties: PageDto._extras(json, 'additionalProperties') == null
        ? const {}
        : PageDto._readExtras(PageDto._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$PageDtoToJson(PageDto instance) => <String, dynamic>{
  'body': instance.body.toJson(),
  'slug': instance.slug,
  'title': instance.title.toJson(),
  'updatedAt': ?PageDto._write_updatedAt(instance.updatedAt),
};
