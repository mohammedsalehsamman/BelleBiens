// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_choice_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotChoiceDto _$SlotChoiceDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['date', 'start'],
    disallowNullValues: const ['date', 'start'],
  );
  return SlotChoiceDto(
    date: json['date'] as String,
    start: json['start'] as String,
    additionalProperties:
        SlotChoiceDto._extras(json, 'additionalProperties') == null
        ? const {}
        : SlotChoiceDto._readExtras(
            SlotChoiceDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$SlotChoiceDtoToJson(SlotChoiceDto instance) =>
    <String, dynamic>{'date': instance.date, 'start': instance.start};
