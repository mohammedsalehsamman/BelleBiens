// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_design_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedDesignInputDto _$SavedDesignInputDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'spec'],
    disallowNullValues: const ['name', 'previewUrl', 'spec'],
  );
  return SavedDesignInputDto(
    name: json['name'] as String,
    previewUrl: json['previewUrl'] as String?,
    spec: SavedDesignInputDtoSpec.fromJson(
      json['spec'] as Map<String, dynamic>,
    ),
    additionalProperties:
        SavedDesignInputDto._extras(json, 'additionalProperties') == null
        ? const {}
        : SavedDesignInputDto._readExtras(
            SavedDesignInputDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$SavedDesignInputDtoToJson(
  SavedDesignInputDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'previewUrl': ?instance.previewUrl,
  'spec': instance.spec.toJson(),
};
