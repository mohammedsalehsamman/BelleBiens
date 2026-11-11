// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview_image_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreviewImageDto _$PreviewImageDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['url'],
    disallowNullValues: const ['url'],
  );
  return PreviewImageDto(
    url: json['url'] as String,
    additionalProperties:
        PreviewImageDto._extras(json, 'additionalProperties') == null
        ? const {}
        : PreviewImageDto._readExtras(
            PreviewImageDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$PreviewImageDtoToJson(PreviewImageDto instance) =>
    <String, dynamic>{'url': instance.url};
