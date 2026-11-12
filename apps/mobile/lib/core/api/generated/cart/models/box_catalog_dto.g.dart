// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_catalog_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoxCatalogDto _$BoxCatalogDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['items', 'types'],
    disallowNullValues: const ['items', 'types'],
  );
  return BoxCatalogDto(
    items: (json['items'] as List<dynamic>)
        .map((e) => DesignerItemDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    types: (json['types'] as List<dynamic>)
        .map((e) => BoxTypeDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    additionalProperties:
        BoxCatalogDto._extras(json, 'additionalProperties') == null
        ? const {}
        : BoxCatalogDto._readExtras(
            BoxCatalogDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$BoxCatalogDtoToJson(BoxCatalogDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'types': instance.types.map((e) => e.toJson()).toList(),
    };
