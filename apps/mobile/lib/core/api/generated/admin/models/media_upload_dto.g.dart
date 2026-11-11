// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_upload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaUploadDto _$MediaUploadDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['file'],
    disallowNullValues: const ['file'],
  );
  return MediaUploadDto(
    file: json['file'] as String,
    additionalProperties:
        MediaUploadDto._extras(json, 'additionalProperties') == null
        ? const {}
        : MediaUploadDto._readExtras(
            MediaUploadDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$MediaUploadDtoToJson(MediaUploadDto instance) =>
    <String, dynamic>{'file': instance.file};
