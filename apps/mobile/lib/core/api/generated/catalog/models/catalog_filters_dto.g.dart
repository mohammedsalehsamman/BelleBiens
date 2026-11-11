// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_filters_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CatalogFiltersDto _$CatalogFiltersDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['colors', 'flowerTypes', 'occasions', 'price'],
    disallowNullValues: const ['colors', 'flowerTypes', 'occasions', 'price'],
  );
  return CatalogFiltersDto(
    colors: (json['colors'] as List<dynamic>)
        .map((e) => VocabularyDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    flowerTypes: (json['flowerTypes'] as List<dynamic>)
        .map((e) => VocabularyDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    occasions: (json['occasions'] as List<dynamic>)
        .map((e) => VocabularyDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    price: PriceRangeDto.fromJson(json['price'] as Map<String, dynamic>),
    additionalProperties:
        CatalogFiltersDto._extras(json, 'additionalProperties') == null
        ? const {}
        : CatalogFiltersDto._readExtras(
            CatalogFiltersDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$CatalogFiltersDtoToJson(CatalogFiltersDto instance) =>
    <String, dynamic>{
      'colors': instance.colors.map((e) => e.toJson()).toList(),
      'flowerTypes': instance.flowerTypes.map((e) => e.toJson()).toList(),
      'occasions': instance.occasions.map((e) => e.toJson()).toList(),
      'price': instance.price.toJson(),
    };
