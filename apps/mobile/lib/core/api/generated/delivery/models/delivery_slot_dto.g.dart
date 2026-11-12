// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_slot_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliverySlotDto _$DeliverySlotDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['available', 'end', 'start'],
    disallowNullValues: const ['available', 'end', 'problem', 'start'],
  );
  return DeliverySlotDto(
    available: json['available'] as bool,
    end: json['end'] as String,
    problem: DeliverySlotDto._read_problem(json['problem']),
    start: json['start'] as String,
    additionalProperties:
        DeliverySlotDto._extras(json, 'additionalProperties') == null
        ? const {}
        : DeliverySlotDto._readExtras(
            DeliverySlotDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$DeliverySlotDtoToJson(DeliverySlotDto instance) =>
    <String, dynamic>{
      'available': instance.available,
      'end': instance.end,
      'problem': ?DeliverySlotDto._write_problem(instance.problem),
      'start': instance.start,
    };
