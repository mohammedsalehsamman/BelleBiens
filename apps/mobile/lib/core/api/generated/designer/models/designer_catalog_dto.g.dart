// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'designer_catalog_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DesignerCatalogDto _$DesignerCatalogDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'date',
      'items',
      'layouts',
      'occasions',
      'palettes',
      'sizes',
    ],
    disallowNullValues: const [
      'date',
      'items',
      'layouts',
      'occasions',
      'palettes',
      'sizes',
    ],
  );
  return DesignerCatalogDto(
    date: json['date'] as String,
    items: (json['items'] as List<dynamic>)
        .map((e) => DesignerItemDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    layouts: SlotLayoutsDto.fromJson(json['layouts'] as Map<String, dynamic>),
    occasions: (json['occasions'] as List<dynamic>)
        .map((e) => OccasionOptionDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    palettes: (json['palettes'] as List<dynamic>)
        .map((e) => PaletteDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    sizes: (json['sizes'] as List<dynamic>)
        .map((e) => DesignerSizeDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    additionalProperties:
        DesignerCatalogDto._extras(json, 'additionalProperties') == null
        ? const {}
        : DesignerCatalogDto._readExtras(
            DesignerCatalogDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$DesignerCatalogDtoToJson(DesignerCatalogDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'layouts': instance.layouts.toJson(),
      'occasions': instance.occasions.map((e) => e.toJson()).toList(),
      'palettes': instance.palettes.map((e) => e.toJson()).toList(),
      'sizes': instance.sizes.map((e) => e.toJson()).toList(),
    };
