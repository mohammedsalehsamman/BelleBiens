// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_designer_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateDesignerItemDto _$UpdateDesignerItemDtoFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    disallowNullValues: const [
      'colorTags',
      'cutoutUrl',
      'nameAr',
      'nameEn',
      'occasionTags',
      'seasonFrom',
      'seasonTo',
      'slug',
      'sortOrder',
      'status',
      'swatch',
      'type',
      'unitPriceMinor',
    ],
  );
  return UpdateDesignerItemDto(
    colorTags: (json['colorTags'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    cutoutUrl: json['cutoutUrl'] as String?,
    nameAr: json['nameAr'] as String?,
    nameEn: json['nameEn'] as String?,
    occasionTags: (json['occasionTags'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    seasonFrom: json['seasonFrom'] as String?,
    seasonTo: json['seasonTo'] as String?,
    slug: json['slug'] as String?,
    sortOrder: json['sortOrder'] as num?,
    status: UpdateDesignerItemDto._read_status(json['status']),
    stockQuantity: json['stockQuantity'] as num?,
    swatch: json['swatch'] as String?,
    type2: UpdateDesignerItemDto._read_type2(json['type']),
    unitPriceMinor: json['unitPriceMinor'] as num?,
    additionalProperties:
        UpdateDesignerItemDto._extras(json, 'additionalProperties') == null
        ? const {}
        : UpdateDesignerItemDto._readExtras(
            UpdateDesignerItemDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$UpdateDesignerItemDtoToJson(
  UpdateDesignerItemDto instance,
) => <String, dynamic>{
  'colorTags': ?instance.colorTags,
  'cutoutUrl': ?instance.cutoutUrl,
  'nameAr': ?instance.nameAr,
  'nameEn': ?instance.nameEn,
  'occasionTags': ?instance.occasionTags,
  'seasonFrom': ?instance.seasonFrom,
  'seasonTo': ?instance.seasonTo,
  'slug': ?instance.slug,
  'sortOrder': ?instance.sortOrder,
  'status': ?UpdateDesignerItemDto._write_status(instance.status),
  'stockQuantity': ?instance.stockQuantity,
  'swatch': ?instance.swatch,
  'type': ?UpdateDesignerItemDto._write_type2(instance.type2),
  'unitPriceMinor': ?instance.unitPriceMinor,
};
