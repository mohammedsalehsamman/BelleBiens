// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_slot_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSlotDto _$OrderSlotDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['date', 'end', 'start'],
    disallowNullValues: const ['date', 'end', 'start'],
  );
  return OrderSlotDto(
    date: json['date'] as String,
    end: json['end'] as String,
    start: json['start'] as String,
    additionalProperties:
        OrderSlotDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OrderSlotDto._readExtras(
            OrderSlotDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$OrderSlotDtoToJson(OrderSlotDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'end': instance.end,
      'start': instance.start,
    };
