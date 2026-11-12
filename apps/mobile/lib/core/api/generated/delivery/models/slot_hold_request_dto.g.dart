// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_hold_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotHoldRequestDto _$SlotHoldRequestDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['date', 'start'],
    disallowNullValues: const ['date', 'leadTimeHours', 'start'],
  );
  return SlotHoldRequestDto(
    date: json['date'] as String,
    leadTimeHours: SlotHoldRequestDto._read_leadTimeHours(
      json['leadTimeHours'],
    ),
    start: json['start'] as String,
    additionalProperties:
        SlotHoldRequestDto._extras(json, 'additionalProperties') == null
        ? const {}
        : SlotHoldRequestDto._readExtras(
            SlotHoldRequestDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$SlotHoldRequestDtoToJson(SlotHoldRequestDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'leadTimeHours': ?SlotHoldRequestDto._write_leadTimeHours(
        instance.leadTimeHours,
      ),
      'start': instance.start,
    };
