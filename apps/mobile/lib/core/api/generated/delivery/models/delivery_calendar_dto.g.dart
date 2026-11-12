// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_calendar_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryCalendarDto _$DeliveryCalendarDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['days', 'leadTimeHours', 'windowDays'],
    disallowNullValues: const ['days', 'leadTimeHours', 'windowDays'],
  );
  return DeliveryCalendarDto(
    days: (json['days'] as List<dynamic>)
        .map((e) => DeliveryDayDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    leadTimeHours: DeliveryCalendarDto._read_leadTimeHours(
      json['leadTimeHours'],
    ),
    windowDays: DeliveryCalendarDto._read_windowDays(json['windowDays']),
    additionalProperties:
        DeliveryCalendarDto._extras(json, 'additionalProperties') == null
        ? const {}
        : DeliveryCalendarDto._readExtras(
            DeliveryCalendarDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$DeliveryCalendarDtoToJson(
  DeliveryCalendarDto instance,
) => <String, dynamic>{
  'days': instance.days.map((e) => e.toJson()).toList(),
  'leadTimeHours': ?DeliveryCalendarDto._write_leadTimeHours(
    instance.leadTimeHours,
  ),
  'windowDays': ?DeliveryCalendarDto._write_windowDays(instance.windowDays),
};
