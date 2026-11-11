// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotDto _$SlotDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['rotation', 'size', 'x', 'y'],
    disallowNullValues: const ['rotation', 'size', 'x', 'y'],
  );
  return SlotDto(
    rotation: SlotDto._read_rotation(json['rotation']),
    size: SlotDto._read_size(json['size']),
    x: SlotDto._read_x(json['x']),
    y: SlotDto._read_y(json['y']),
    additionalProperties: SlotDto._extras(json, 'additionalProperties') == null
        ? const {}
        : SlotDto._readExtras(SlotDto._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$SlotDtoToJson(SlotDto instance) => <String, dynamic>{
  'rotation': ?SlotDto._write_rotation(instance.rotation),
  'size': ?SlotDto._write_size(instance.size),
  'x': ?SlotDto._write_x(instance.x),
  'y': ?SlotDto._write_y(instance.y),
};
