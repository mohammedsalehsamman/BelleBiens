// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_designer_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminDesignerItemDto _$AdminDesignerItemDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'nameAr',
      'nameEn',
      'slug',
      'todayQuantity',
      'type',
      'unitPriceMinor',
    ],
    disallowNullValues: const [
      'colorTags',
      'cutoutUrl',
      'id',
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
  return AdminDesignerItemDto(
    colorTags: (json['colorTags'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    cutoutUrl: json['cutoutUrl'] as String?,
    id: json['id'] as String,
    nameAr: json['nameAr'] as String,
    nameEn: json['nameEn'] as String,
    occasionTags: (json['occasionTags'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    seasonFrom: json['seasonFrom'] as String?,
    seasonTo: json['seasonTo'] as String?,
    slug: json['slug'] as String,
    sortOrder: json['sortOrder'] as num?,
    status: AdminDesignerItemDto._read_status(json['status']),
    stockQuantity: json['stockQuantity'] as num?,
    swatch: json['swatch'] as String?,
    todayQuantity: json['todayQuantity'] as num?,
    type2: AdminDesignerItemDto._read_type2(json['type']),
    unitPriceMinor: json['unitPriceMinor'] as num,
    additionalProperties:
        AdminDesignerItemDto._extras(json, 'additionalProperties') == null
        ? const {}
        : AdminDesignerItemDto._readExtras(
            AdminDesignerItemDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$AdminDesignerItemDtoToJson(
  AdminDesignerItemDto instance,
) => <String, dynamic>{
  'colorTags': ?instance.colorTags,
  'cutoutUrl': ?instance.cutoutUrl,
  'id': instance.id,
  'nameAr': instance.nameAr,
  'nameEn': instance.nameEn,
  'occasionTags': ?instance.occasionTags,
  'seasonFrom': ?instance.seasonFrom,
  'seasonTo': ?instance.seasonTo,
  'slug': instance.slug,
  'sortOrder': ?instance.sortOrder,
  'status': ?AdminDesignerItemDto._write_status(instance.status),
  'stockQuantity': ?instance.stockQuantity,
  'swatch': ?instance.swatch,
  'todayQuantity': instance.todayQuantity,
  'type': ?AdminDesignerItemDto._write_type2(instance.type2),
  'unitPriceMinor': instance.unitPriceMinor,
};
