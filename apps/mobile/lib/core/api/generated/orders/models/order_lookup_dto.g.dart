// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_lookup_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderLookupDto _$OrderLookupDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['number', 'phone'],
    disallowNullValues: const ['number', 'phone'],
  );
  return OrderLookupDto(
    number: json['number'] as String,
    phone: json['phone'] as String,
    additionalProperties:
        OrderLookupDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OrderLookupDto._readExtras(
            OrderLookupDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$OrderLookupDtoToJson(OrderLookupDto instance) =>
    <String, dynamic>{'number': instance.number, 'phone': instance.phone};
