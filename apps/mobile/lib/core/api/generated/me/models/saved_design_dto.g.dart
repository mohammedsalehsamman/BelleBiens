// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_design_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedDesignDto _$SavedDesignDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'available',
      'id',
      'name',
      'priceMinor',
      'spec',
      'stems',
      'updatedAt',
    ],
    disallowNullValues: const [
      'available',
      'id',
      'name',
      'previewUrl',
      'priceMinor',
      'spec',
      'stems',
      'updatedAt',
      'wrap',
    ],
  );
  return SavedDesignDto(
    available: json['available'] as bool,
    id: json['id'] as String,
    name: json['name'] as String,
    previewUrl: json['previewUrl'] as String?,
    priceMinor: SavedDesignDto._read_priceMinor(json['priceMinor']),
    spec: SavedDesignDtoSpec.fromJson(json['spec'] as Map<String, dynamic>),
    stems: SavedDesignDto._read_stems(json['stems']),
    updatedAt: SavedDesignDto._read_updatedAt(json['updatedAt']),
    wrap: json['wrap'] == null
        ? null
        : LocalizedTextDto.fromJson(json['wrap'] as Map<String, dynamic>),
    additionalProperties:
        SavedDesignDto._extras(json, 'additionalProperties') == null
        ? const {}
        : SavedDesignDto._readExtras(
            SavedDesignDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$SavedDesignDtoToJson(SavedDesignDto instance) =>
    <String, dynamic>{
      'available': instance.available,
      'id': instance.id,
      'name': instance.name,
      'previewUrl': ?instance.previewUrl,
      'priceMinor': ?SavedDesignDto._write_priceMinor(instance.priceMinor),
      'spec': instance.spec.toJson(),
      'stems': ?SavedDesignDto._write_stems(instance.stems),
      'updatedAt': ?SavedDesignDto._write_updatedAt(instance.updatedAt),
      'wrap': ?instance.wrap?.toJson(),
    };
