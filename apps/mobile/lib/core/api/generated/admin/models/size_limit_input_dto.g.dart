// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size_limit_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SizeLimitInputDto _$SizeLimitInputDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['key', 'maxStems', 'minStems'],
    disallowNullValues: const ['key', 'maxStems', 'minStems'],
  );
  return SizeLimitInputDto(
    key: SizeLimitInputDto._read_key(json['key']),
    maxStems: json['maxStems'] as num,
    minStems: json['minStems'] as num,
    additionalProperties:
        SizeLimitInputDto._extras(json, 'additionalProperties') == null
        ? const {}
        : SizeLimitInputDto._readExtras(
            SizeLimitInputDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$SizeLimitInputDtoToJson(SizeLimitInputDto instance) =>
    <String, dynamic>{
      'key': ?SizeLimitInputDto._write_key(instance.key),
      'maxStems': instance.maxStems,
      'minStems': instance.minStems,
    };
