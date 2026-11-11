// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'working_hours_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkingHoursDto _$WorkingHoursDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['close', 'open'],
    disallowNullValues: const ['close', 'open'],
  );
  return WorkingHoursDto(
    close: json['close'] as String,
    open: json['open'] as String,
    additionalProperties:
        WorkingHoursDto._extras(json, 'additionalProperties') == null
        ? const {}
        : WorkingHoursDto._readExtras(
            WorkingHoursDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$WorkingHoursDtoToJson(WorkingHoursDto instance) =>
    <String, dynamic>{'close': instance.close, 'open': instance.open};
