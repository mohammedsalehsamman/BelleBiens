// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploaded_image_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadedImageDto _$UploadedImageDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['url'],
    disallowNullValues: const ['url'],
  );
  return UploadedImageDto(
    url: json['url'] as String,
    additionalProperties:
        UploadedImageDto._extras(json, 'additionalProperties') == null
        ? const {}
        : UploadedImageDto._readExtras(
            UploadedImageDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$UploadedImageDtoToJson(UploadedImageDto instance) =>
    <String, dynamic>{'url': instance.url};
