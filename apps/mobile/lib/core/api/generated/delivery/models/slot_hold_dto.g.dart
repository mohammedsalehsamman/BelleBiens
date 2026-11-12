// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_hold_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotHoldDto _$SlotHoldDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['date', 'expiresAt', 'id', 'start'],
    disallowNullValues: const ['date', 'expiresAt', 'id', 'start'],
  );
  return SlotHoldDto(
    date: json['date'] as String,
    expiresAt: SlotHoldDto._read_expiresAt(json['expiresAt']),
    id: json['id'] as String,
    start: json['start'] as String,
    additionalProperties:
        SlotHoldDto._extras(json, 'additionalProperties') == null
        ? const {}
        : SlotHoldDto._readExtras(
            SlotHoldDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$SlotHoldDtoToJson(SlotHoldDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'expiresAt': ?SlotHoldDto._write_expiresAt(instance.expiresAt),
      'id': instance.id,
      'start': instance.start,
    };
