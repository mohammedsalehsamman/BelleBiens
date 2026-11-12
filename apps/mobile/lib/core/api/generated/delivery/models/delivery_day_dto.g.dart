// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_day_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryDayDto _$DeliveryDayDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['available', 'date', 'inDays'],
    disallowNullValues: const ['available', 'date', 'inDays', 'problem'],
  );
  return DeliveryDayDto(
    available: json['available'] as bool,
    date: json['date'] as String,
    inDays: DeliveryDayDto._read_inDays(json['inDays']),
    problem: DeliveryDayDto._read_problem(json['problem']),
    additionalProperties:
        DeliveryDayDto._extras(json, 'additionalProperties') == null
        ? const {}
        : DeliveryDayDto._readExtras(
            DeliveryDayDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$DeliveryDayDtoToJson(DeliveryDayDto instance) =>
    <String, dynamic>{
      'available': instance.available,
      'date': instance.date,
      'inDays': ?DeliveryDayDto._write_inDays(instance.inDays),
      'problem': ?DeliveryDayDto._write_problem(instance.problem),
    };
