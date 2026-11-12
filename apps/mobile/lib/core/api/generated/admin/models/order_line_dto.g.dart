// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_line_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderLineDto _$OrderLineDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'kind',
      'position',
      'qty',
      'summary',
      'title',
      'totalMinor',
      'unitPriceMinor',
    ],
    disallowNullValues: const [
      'imageUrl',
      'kind',
      'position',
      'qty',
      'summary',
      'title',
      'totalMinor',
      'unitPriceMinor',
    ],
  );
  return OrderLineDto(
    imageUrl: json['imageUrl'] as String?,
    kind: json['kind'] as String,
    position: OrderLineDto._read_position(json['position']),
    qty: OrderLineDto._read_qty(json['qty']),
    summary: LocalizedTextDto.fromJson(json['summary'] as Map<String, dynamic>),
    title: LocalizedTextDto.fromJson(json['title'] as Map<String, dynamic>),
    totalMinor: OrderLineDto._read_totalMinor(json['totalMinor']),
    unitPriceMinor: OrderLineDto._read_unitPriceMinor(json['unitPriceMinor']),
    additionalProperties:
        OrderLineDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OrderLineDto._readExtras(
            OrderLineDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$OrderLineDtoToJson(OrderLineDto instance) =>
    <String, dynamic>{
      'imageUrl': ?instance.imageUrl,
      'kind': instance.kind,
      'position': ?OrderLineDto._write_position(instance.position),
      'qty': ?OrderLineDto._write_qty(instance.qty),
      'summary': instance.summary.toJson(),
      'title': instance.title.toJson(),
      'totalMinor': ?OrderLineDto._write_totalMinor(instance.totalMinor),
      'unitPriceMinor': ?OrderLineDto._write_unitPriceMinor(
        instance.unitPriceMinor,
      ),
    };
