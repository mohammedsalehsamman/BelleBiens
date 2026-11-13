// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occasion_reminder_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OccasionReminderInputDto _$OccasionReminderInputDtoFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    requiredKeys: const ['date', 'person', 'type'],
    disallowNullValues: const ['date', 'person', 'remindDaysBefore', 'type'],
  );
  return OccasionReminderInputDto(
    date: json['date'] as String,
    person: json['person'] as String,
    remindDaysBefore: OccasionReminderInputDto._read_remindDaysBefore(
      json['remindDaysBefore'],
    ),
    type2: OccasionReminderInputDto._read_type2(json['type']),
    additionalProperties:
        OccasionReminderInputDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OccasionReminderInputDto._readExtras(
            OccasionReminderInputDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$OccasionReminderInputDtoToJson(
  OccasionReminderInputDto instance,
) => <String, dynamic>{
  'date': instance.date,
  'person': instance.person,
  'remindDaysBefore': ?OccasionReminderInputDto._write_remindDaysBefore(
    instance.remindDaysBefore,
  ),
  'type': ?OccasionReminderInputDto._write_type2(instance.type2),
};
