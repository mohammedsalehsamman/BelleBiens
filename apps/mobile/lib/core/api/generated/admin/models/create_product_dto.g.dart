// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateProductDto _$CreateProductDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'basePriceMinor',
      'categorySlug',
      'kind',
      'nameAr',
      'nameEn',
      'slug',
    ],
    disallowNullValues: const [
      'allergens',
      'basePriceMinor',
      'bestSeller',
      'categorySlug',
      'colors',
      'dailyOnly',
      'descriptionAr',
      'descriptionEn',
      'flowerTypes',
      'images',
      'kind',
      'leadTimeHours',
      'limited',
      'nameAr',
      'nameEn',
      'occasions',
      'optionGroups',
      'pairings',
      'popularity',
      'seasonal',
      'slug',
      'status',
      'subtitleAr',
      'subtitleEn',
    ],
  );
  return CreateProductDto(
    allergens: (json['allergens'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    basePriceMinor: json['basePriceMinor'] as num,
    bestSeller: json['bestSeller'] as bool?,
    categorySlug: json['categorySlug'] as String,
    colors: CreateProductDto._read_colors(json['colors']),
    dailyOnly: json['dailyOnly'] as bool?,
    descriptionAr: json['descriptionAr'] as String?,
    descriptionEn: json['descriptionEn'] as String?,
    designerTemplate: json['designerTemplate'] == null
        ? null
        : CreateProductDtoDesignerTemplate.fromJson(
            json['designerTemplate'] as Map<String, dynamic>,
          ),
    flowerTypes: CreateProductDto._read_flowerTypes(json['flowerTypes']),
    images: (json['images'] as List<dynamic>?)
        ?.map((e) => ImageInputDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    kind: CreateProductDto._read_kind(json['kind']),
    leadTimeHours: json['leadTimeHours'] as num?,
    limited: json['limited'] as bool?,
    nameAr: json['nameAr'] as String,
    nameEn: json['nameEn'] as String,
    occasions: (json['occasions'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    optionGroups: (json['optionGroups'] as List<dynamic>?)
        ?.map((e) => OptionGroupInputDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    pairings: (json['pairings'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    popularity: json['popularity'] as num?,
    seasonal: json['seasonal'] as bool?,
    slug: json['slug'] as String,
    status: CreateProductDto._read_status(json['status']),
    stockQuantity: json['stockQuantity'] as num?,
    subtitleAr: json['subtitleAr'] as String?,
    subtitleEn: json['subtitleEn'] as String?,
    additionalProperties:
        CreateProductDto._extras(json, 'additionalProperties') == null
        ? const {}
        : CreateProductDto._readExtras(
            CreateProductDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$CreateProductDtoToJson(CreateProductDto instance) =>
    <String, dynamic>{
      'allergens': ?instance.allergens,
      'basePriceMinor': instance.basePriceMinor,
      'bestSeller': ?instance.bestSeller,
      'categorySlug': instance.categorySlug,
      'colors': ?CreateProductDto._write_colors(instance.colors),
      'dailyOnly': ?instance.dailyOnly,
      'descriptionAr': ?instance.descriptionAr,
      'descriptionEn': ?instance.descriptionEn,
      'designerTemplate': ?instance.designerTemplate?.toJson(),
      'flowerTypes': ?CreateProductDto._write_flowerTypes(instance.flowerTypes),
      'images': ?instance.images?.map((e) => e.toJson()).toList(),
      'kind': ?CreateProductDto._write_kind(instance.kind),
      'leadTimeHours': ?instance.leadTimeHours,
      'limited': ?instance.limited,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'occasions': ?instance.occasions,
      'optionGroups': ?instance.optionGroups?.map((e) => e.toJson()).toList(),
      'pairings': ?instance.pairings,
      'popularity': ?instance.popularity,
      'seasonal': ?instance.seasonal,
      'slug': instance.slug,
      'status': ?CreateProductDto._write_status(instance.status),
      'stockQuantity': ?instance.stockQuantity,
      'subtitleAr': ?instance.subtitleAr,
      'subtitleEn': ?instance.subtitleEn,
    };
