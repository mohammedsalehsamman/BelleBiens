// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaDto _$MediaDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['contentType', 'height', 'url', 'width'],
    disallowNullValues: const ['contentType', 'height', 'url', 'width'],
  );
  return MediaDto(
    contentType: json['contentType'] as String,
    height: json['height'] as num,
    url: json['url'] as String,
    width: json['width'] as num,
    additionalProperties: MediaDto._extras(json, 'additionalProperties') == null
        ? const {}
        : MediaDto._readExtras(MediaDto._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$MediaDtoToJson(MediaDto instance) => <String, dynamic>{
  'contentType': instance.contentType,
  'height': instance.height,
  'url': instance.url,
  'width': instance.width,
};
