// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_link_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageLinkDto _$PageLinkDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['slug', 'title'],
    disallowNullValues: const ['slug', 'title'],
  );
  return PageLinkDto(
    slug: json['slug'] as String,
    title: LocalizedTextDto.fromJson(json['title'] as Map<String, dynamic>),
    additionalProperties:
        PageLinkDto._extras(json, 'additionalProperties') == null
        ? const {}
        : PageLinkDto._readExtras(
            PageLinkDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$PageLinkDtoToJson(PageLinkDto instance) =>
    <String, dynamic>{'slug': instance.slug, 'title': instance.title.toJson()};
