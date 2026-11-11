// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_adjustment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockAdjustmentDto _$StockAdjustmentDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['delta', 'reason', 'slug', 'target'],
    disallowNullValues: const ['delta', 'reason', 'slug', 'target'],
  );
  return StockAdjustmentDto(
    delta: json['delta'] as num,
    reason: json['reason'] as String,
    slug: json['slug'] as String,
    target: StockAdjustmentDto._read_target(json['target']),
    additionalProperties:
        StockAdjustmentDto._extras(json, 'additionalProperties') == null
        ? const {}
        : StockAdjustmentDto._readExtras(
            StockAdjustmentDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$StockAdjustmentDtoToJson(StockAdjustmentDto instance) =>
    <String, dynamic>{
      'delta': instance.delta,
      'reason': instance.reason,
      'slug': instance.slug,
      'target': ?StockAdjustmentDto._write_target(instance.target),
    };
