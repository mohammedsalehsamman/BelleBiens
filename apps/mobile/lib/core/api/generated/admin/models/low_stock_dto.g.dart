// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'low_stock_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LowStockDto _$LowStockDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'left', 'nameAr', 'nameEn', 'source'],
    disallowNullValues: const ['id', 'left', 'nameAr', 'nameEn', 'source'],
  );
  return LowStockDto(
    id: json['id'] as String,
    left: LowStockDto._read_left(json['left']),
    nameAr: json['nameAr'] as String,
    nameEn: json['nameEn'] as String,
    source: LowStockDto._read_source(json['source']),
    additionalProperties:
        LowStockDto._extras(json, 'additionalProperties') == null
        ? const {}
        : LowStockDto._readExtras(
            LowStockDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$LowStockDtoToJson(LowStockDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'left': ?LowStockDto._write_left(instance.left),
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'source': ?LowStockDto._write_source(instance.source),
    };
