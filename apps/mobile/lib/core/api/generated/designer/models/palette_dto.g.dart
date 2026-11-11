// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'palette_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaletteDto _$PaletteDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['colors', 'key', 'name'],
    disallowNullValues: const ['colors', 'key', 'name'],
  );
  return PaletteDto(
    colors: (json['colors'] as List<dynamic>).map((e) => e as String).toList(),
    key: PaletteDto._read_key(json['key']),
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    additionalProperties:
        PaletteDto._extras(json, 'additionalProperties') == null
        ? const {}
        : PaletteDto._readExtras(
            PaletteDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$PaletteDtoToJson(PaletteDto instance) =>
    <String, dynamic>{
      'colors': instance.colors,
      'key': ?PaletteDto._write_key(instance.key),
      'name': instance.name.toJson(),
    };
