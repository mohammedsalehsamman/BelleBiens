// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_line_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteLineDto _$QuoteLineDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'name',
      'qty',
      'totalMinor',
      'type',
      'unitPriceMinor',
    ],
    disallowNullValues: const [
      'id',
      'name',
      'qty',
      'totalMinor',
      'type',
      'unitPriceMinor',
    ],
  );
  return QuoteLineDto(
    id: json['id'] as String,
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    qty: QuoteLineDto._read_qty(json['qty']),
    totalMinor: QuoteLineDto._read_totalMinor(json['totalMinor']),
    type2: QuoteLineDto._read_type2(json['type']),
    unitPriceMinor: QuoteLineDto._read_unitPriceMinor(json['unitPriceMinor']),
    additionalProperties:
        QuoteLineDto._extras(json, 'additionalProperties') == null
        ? const {}
        : QuoteLineDto._readExtras(
            QuoteLineDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$QuoteLineDtoToJson(QuoteLineDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name.toJson(),
      'qty': ?QuoteLineDto._write_qty(instance.qty),
      'totalMinor': ?QuoteLineDto._write_totalMinor(instance.totalMinor),
      'type': ?QuoteLineDto._write_type2(instance.type2),
      'unitPriceMinor': ?QuoteLineDto._write_unitPriceMinor(
        instance.unitPriceMinor,
      ),
    };
