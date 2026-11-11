// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_layouts_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotLayoutsDto _$SlotLayoutsDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['height', 'sizes', 'version', 'width'],
    disallowNullValues: const ['height', 'sizes', 'version', 'width'],
  );
  return SlotLayoutsDto(
    height: SlotLayoutsDto._read_height(json['height']),
    sizes: (json['sizes'] as List<dynamic>)
        .map((e) => SizeLayoutDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    version: SlotLayoutsDto._read_version(json['version']),
    width: SlotLayoutsDto._read_width(json['width']),
    additionalProperties:
        SlotLayoutsDto._extras(json, 'additionalProperties') == null
        ? const {}
        : SlotLayoutsDto._readExtras(
            SlotLayoutsDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$SlotLayoutsDtoToJson(SlotLayoutsDto instance) =>
    <String, dynamic>{
      'height': ?SlotLayoutsDto._write_height(instance.height),
      'sizes': instance.sizes.map((e) => e.toJson()).toList(),
      'version': ?SlotLayoutsDto._write_version(instance.version),
      'width': ?SlotLayoutsDto._write_width(instance.width),
    };
