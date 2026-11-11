// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockMovementDto _$StockMovementDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'createdAt',
      'delta',
      'id',
      'quantityAfter',
      'reason',
      'slug',
      'target',
      'userId',
    ],
    disallowNullValues: const [
      'createdAt',
      'delta',
      'id',
      'quantityAfter',
      'reason',
      'slug',
      'target',
    ],
  );
  return StockMovementDto(
    createdAt: StockMovementDto._read_createdAt(json['createdAt']),
    delta: json['delta'] as num,
    id: json['id'] as String,
    quantityAfter: json['quantityAfter'] as num,
    reason: json['reason'] as String,
    slug: json['slug'] as String,
    target: StockMovementDto._read_target(json['target']),
    userId: json['userId'] as String?,
    additionalProperties:
        StockMovementDto._extras(json, 'additionalProperties') == null
        ? const {}
        : StockMovementDto._readExtras(
            StockMovementDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$StockMovementDtoToJson(StockMovementDto instance) =>
    <String, dynamic>{
      'createdAt': ?StockMovementDto._write_createdAt(instance.createdAt),
      'delta': instance.delta,
      'id': instance.id,
      'quantityAfter': instance.quantityAfter,
      'reason': instance.reason,
      'slug': instance.slug,
      'target': ?StockMovementDto._write_target(instance.target),
      'userId': instance.userId,
    };
