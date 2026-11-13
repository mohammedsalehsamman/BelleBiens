// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occasion_reminder_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OccasionReminderDto _$OccasionReminderDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'date',
      'daysLeft',
      'id',
      'next',
      'person',
      'remindDaysBefore',
      'type',
    ],
    disallowNullValues: const [
      'date',
      'daysLeft',
      'id',
      'next',
      'person',
      'remindDaysBefore',
      'type',
    ],
  );
  return OccasionReminderDto(
    date: json['date'] as String,
    daysLeft: OccasionReminderDto._read_daysLeft(json['daysLeft']),
    id: json['id'] as String,
    next: json['next'] as String,
    person: json['person'] as String,
    remindDaysBefore: OccasionReminderDto._read_remindDaysBefore(
      json['remindDaysBefore'],
    ),
    type2: OccasionReminderDto._read_type2(json['type']),
    additionalProperties:
        OccasionReminderDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OccasionReminderDto._readExtras(
            OccasionReminderDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$OccasionReminderDtoToJson(
  OccasionReminderDto instance,
) => <String, dynamic>{
  'date': instance.date,
  'daysLeft': ?OccasionReminderDto._write_daysLeft(instance.daysLeft),
  'id': instance.id,
  'next': instance.next,
  'person': instance.person,
  'remindDaysBefore': ?OccasionReminderDto._write_remindDaysBefore(
    instance.remindDaysBefore,
  ),
  'type': ?OccasionReminderDto._write_type2(instance.type2),
};
