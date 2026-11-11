// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_option_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOptionDto _$ProductOptionDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'detail',
      'isDefault',
      'key',
      'name',
      'priceChangeMinor',
      'swatch',
    ],
    disallowNullValues: const [
      'detail',
      'isDefault',
      'key',
      'name',
      'priceChangeMinor',
    ],
  );
  return ProductOptionDto(
    detail: LocalizedTextDto.fromJson(json['detail'] as Map<String, dynamic>),
    isDefault: json['isDefault'] as bool,
    key: json['key'] as String,
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    priceChangeMinor: ProductOptionDto._read_priceChangeMinor(
      json['priceChangeMinor'],
    ),
    swatch: json['swatch'] as String?,
    additionalProperties:
        ProductOptionDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ProductOptionDto._readExtras(
            ProductOptionDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$ProductOptionDtoToJson(ProductOptionDto instance) =>
    <String, dynamic>{
      'detail': instance.detail.toJson(),
      'isDefault': instance.isDefault,
      'key': instance.key,
      'name': instance.name.toJson(),
      'priceChangeMinor': ?ProductOptionDto._write_priceChangeMinor(
        instance.priceChangeMinor,
      ),
      'swatch': instance.swatch,
    };
