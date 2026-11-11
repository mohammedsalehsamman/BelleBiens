// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size_limits_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SizeLimitsDto _$SizeLimitsDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['sizes'],
    disallowNullValues: const ['sizes'],
  );
  return SizeLimitsDto(
    sizes: (json['sizes'] as List<dynamic>)
        .map((e) => SizeLimitInputDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    additionalProperties:
        SizeLimitsDto._extras(json, 'additionalProperties') == null
        ? const {}
        : SizeLimitsDto._readExtras(
            SizeLimitsDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$SizeLimitsDtoToJson(SizeLimitsDto instance) =>
    <String, dynamic>{'sizes': instance.sizes.map((e) => e.toJson()).toList()};
