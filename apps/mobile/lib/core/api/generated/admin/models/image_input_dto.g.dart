// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageInputDto _$ImageInputDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['url'],
    disallowNullValues: const ['altAr', 'altEn', 'url'],
  );
  return ImageInputDto(
    altAr: json['altAr'] as String?,
    altEn: json['altEn'] as String?,
    url: json['url'] as String,
    additionalProperties:
        ImageInputDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ImageInputDto._readExtras(
            ImageInputDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$ImageInputDtoToJson(ImageInputDto instance) =>
    <String, dynamic>{
      'altAr': ?instance.altAr,
      'altEn': ?instance.altEn,
      'url': instance.url,
    };
