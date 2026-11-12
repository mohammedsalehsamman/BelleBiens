// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_slots_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DaySlotsDto _$DaySlotsDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['date', 'slots'],
    disallowNullValues: const ['date', 'slots'],
  );
  return DaySlotsDto(
    date: json['date'] as String,
    slots: (json['slots'] as List<dynamic>)
        .map((e) => DeliverySlotDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    additionalProperties:
        DaySlotsDto._extras(json, 'additionalProperties') == null
        ? const {}
        : DaySlotsDto._readExtras(
            DaySlotsDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$DaySlotsDtoToJson(DaySlotsDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'slots': instance.slots.map((e) => e.toJson()).toList(),
    };
