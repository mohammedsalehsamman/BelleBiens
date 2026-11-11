// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occasion_option_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OccasionOptionDto _$OccasionOptionDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'slug'],
    disallowNullValues: const ['name', 'slug'],
  );
  return OccasionOptionDto(
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    slug: json['slug'] as String,
    additionalProperties:
        OccasionOptionDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OccasionOptionDto._readExtras(
            OccasionOptionDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$OccasionOptionDtoToJson(OccasionOptionDto instance) =>
    <String, dynamic>{'name': instance.name.toJson(), 'slug': instance.slug};
