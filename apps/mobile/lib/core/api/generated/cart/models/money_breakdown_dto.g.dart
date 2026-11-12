// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_breakdown_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoneyBreakdownDto _$MoneyBreakdownDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'assemblyFeeMinor',
      'deliveryFeeMinor',
      'discountMinor',
      'itemsMinor',
      'roundingAdjustmentMinor',
      'totalMinor',
    ],
    disallowNullValues: const [
      'assemblyFeeMinor',
      'deliveryFeeMinor',
      'discountMinor',
      'itemsMinor',
      'roundingAdjustmentMinor',
      'totalMinor',
    ],
  );
  return MoneyBreakdownDto(
    assemblyFeeMinor: MoneyBreakdownDto._read_assemblyFeeMinor(
      json['assemblyFeeMinor'],
    ),
    deliveryFeeMinor: MoneyBreakdownDto._read_deliveryFeeMinor(
      json['deliveryFeeMinor'],
    ),
    discountMinor: MoneyBreakdownDto._read_discountMinor(json['discountMinor']),
    itemsMinor: MoneyBreakdownDto._read_itemsMinor(json['itemsMinor']),
    roundingAdjustmentMinor: MoneyBreakdownDto._read_roundingAdjustmentMinor(
      json['roundingAdjustmentMinor'],
    ),
    totalMinor: MoneyBreakdownDto._read_totalMinor(json['totalMinor']),
    additionalProperties:
        MoneyBreakdownDto._extras(json, 'additionalProperties') == null
        ? const {}
        : MoneyBreakdownDto._readExtras(
            MoneyBreakdownDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$MoneyBreakdownDtoToJson(
  MoneyBreakdownDto instance,
) => <String, dynamic>{
  'assemblyFeeMinor': ?MoneyBreakdownDto._write_assemblyFeeMinor(
    instance.assemblyFeeMinor,
  ),
  'deliveryFeeMinor': ?MoneyBreakdownDto._write_deliveryFeeMinor(
    instance.deliveryFeeMinor,
  ),
  'discountMinor': ?MoneyBreakdownDto._write_discountMinor(
    instance.discountMinor,
  ),
  'itemsMinor': ?MoneyBreakdownDto._write_itemsMinor(instance.itemsMinor),
  'roundingAdjustmentMinor': ?MoneyBreakdownDto._write_roundingAdjustmentMinor(
    instance.roundingAdjustmentMinor,
  ),
  'totalMinor': ?MoneyBreakdownDto._write_totalMinor(instance.totalMinor),
};
