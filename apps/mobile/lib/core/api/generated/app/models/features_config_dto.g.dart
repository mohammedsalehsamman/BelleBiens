// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'features_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeaturesConfigDto _$FeaturesConfigDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['aiPreview', 'designer3d'],
    disallowNullValues: const ['aiPreview', 'designer3d'],
  );
  return FeaturesConfigDto(
    aiPreview: json['aiPreview'] as bool,
    designer3d: json['designer3d'] as bool,
    additionalProperties:
        FeaturesConfigDto._extras(json, 'additionalProperties') == null
        ? const {}
        : FeaturesConfigDto._readExtras(
            FeaturesConfigDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$FeaturesConfigDtoToJson(FeaturesConfigDto instance) =>
    <String, dynamic>{
      'aiPreview': instance.aiPreview,
      'designer3d': instance.designer3d,
    };
