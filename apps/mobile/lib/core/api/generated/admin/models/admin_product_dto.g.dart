// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminProductDto _$AdminProductDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'basePriceMinor',
      'categorySlug',
      'dailyDate',
      'displayPriceMinor',
      'id',
      'kind',
      'nameAr',
      'nameEn',
      'priceFrom',
      'slug',
      'updatedAt',
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
      'displayPriceMinor',
      'flowerTypes',
      'id',
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
      'priceFrom',
      'seasonal',
      'slug',
      'status',
      'subtitleAr',
      'subtitleEn',
      'updatedAt',
    ],
  );
  return AdminProductDto(
    allergens: (json['allergens'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    basePriceMinor: json['basePriceMinor'] as num,
    bestSeller: json['bestSeller'] as bool?,
    categorySlug: json['categorySlug'] as String,
    colors: AdminProductDto._read_colors(json['colors']),
    dailyDate: json['dailyDate'] as String?,
    dailyOnly: json['dailyOnly'] as bool?,
    descriptionAr: json['descriptionAr'] as String?,
    descriptionEn: json['descriptionEn'] as String?,
    designerTemplate: json['designerTemplate'] == null
        ? null
        : AdminProductDtoDesignerTemplate.fromJson(
            json['designerTemplate'] as Map<String, dynamic>,
          ),
    displayPriceMinor: json['displayPriceMinor'] as num,
    flowerTypes: AdminProductDto._read_flowerTypes(json['flowerTypes']),
    id: json['id'] as String,
    images: (json['images'] as List<dynamic>?)
        ?.map((e) => ImageInputDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    kind: AdminProductDto._read_kind(json['kind']),
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
    priceFrom: json['priceFrom'] as bool,
    seasonal: json['seasonal'] as bool?,
    slug: json['slug'] as String,
    status: AdminProductDto._read_status(json['status']),
    stockQuantity: json['stockQuantity'] as num?,
    subtitleAr: json['subtitleAr'] as String?,
    subtitleEn: json['subtitleEn'] as String?,
    updatedAt: AdminProductDto._read_updatedAt(json['updatedAt']),
    additionalProperties:
        AdminProductDto._extras(json, 'additionalProperties') == null
        ? const {}
        : AdminProductDto._readExtras(
            AdminProductDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$AdminProductDtoToJson(AdminProductDto instance) =>
    <String, dynamic>{
      'allergens': ?instance.allergens,
      'basePriceMinor': instance.basePriceMinor,
      'bestSeller': ?instance.bestSeller,
      'categorySlug': instance.categorySlug,
      'colors': ?AdminProductDto._write_colors(instance.colors),
      'dailyDate': instance.dailyDate,
      'dailyOnly': ?instance.dailyOnly,
      'descriptionAr': ?instance.descriptionAr,
      'descriptionEn': ?instance.descriptionEn,
      'designerTemplate': ?instance.designerTemplate?.toJson(),
      'displayPriceMinor': instance.displayPriceMinor,
      'flowerTypes': ?AdminProductDto._write_flowerTypes(instance.flowerTypes),
      'id': instance.id,
      'images': ?instance.images?.map((e) => e.toJson()).toList(),
      'kind': ?AdminProductDto._write_kind(instance.kind),
      'leadTimeHours': ?instance.leadTimeHours,
      'limited': ?instance.limited,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'occasions': ?instance.occasions,
      'optionGroups': ?instance.optionGroups?.map((e) => e.toJson()).toList(),
      'pairings': ?instance.pairings,
      'popularity': ?instance.popularity,
      'priceFrom': instance.priceFrom,
      'seasonal': ?instance.seasonal,
      'slug': instance.slug,
      'status': ?AdminProductDto._write_status(instance.status),
      'stockQuantity': ?instance.stockQuantity,
      'subtitleAr': ?instance.subtitleAr,
      'subtitleEn': ?instance.subtitleEn,
      'updatedAt': ?AdminProductDto._write_updatedAt(instance.updatedAt),
    };
