// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDetailDto _$ProductDetailDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'allergens',
      'available',
      'badges',
      'category',
      'categorySlug',
      'colors',
      'customizable',
      'description',
      'earliestDeliveryInDays',
      'flowerTypes',
      'id',
      'imageUrl',
      'images',
      'isFavorite',
      'kind',
      'leadTimeHours',
      'name',
      'occasions',
      'optionGroups',
      'pairings',
      'priceFrom',
      'priceMinor',
      'slug',
      'stockLeft',
      'subtitle',
    ],
    disallowNullValues: const [
      'allergens',
      'available',
      'badges',
      'category',
      'categorySlug',
      'colors',
      'customizable',
      'description',
      'earliestDeliveryInDays',
      'flowerTypes',
      'id',
      'images',
      'isFavorite',
      'kind',
      'leadTimeHours',
      'name',
      'occasions',
      'optionGroups',
      'pairings',
      'priceFrom',
      'priceMinor',
      'slug',
      'subtitle',
    ],
  );
  return ProductDetailDto(
    allergens: (json['allergens'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    available: json['available'] as bool,
    badges: ProductDetailDto._read_badges(json['badges']),
    category: CategoryRefDto.fromJson(json['category'] as Map<String, dynamic>),
    categorySlug: json['categorySlug'] as String,
    colors: (json['colors'] as List<dynamic>).map((e) => e as String).toList(),
    customizable: json['customizable'] as bool,
    description: LocalizedTextDto.fromJson(
      json['description'] as Map<String, dynamic>,
    ),
    earliestDeliveryInDays: ProductDetailDto._read_earliestDeliveryInDays(
      json['earliestDeliveryInDays'],
    ),
    flowerTypes: (json['flowerTypes'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    id: json['id'] as String,
    imageUrl: json['imageUrl'] as String?,
    images: (json['images'] as List<dynamic>)
        .map((e) => ProductImageDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    isFavorite: json['isFavorite'] as bool,
    kind: ProductDetailDto._read_kind(json['kind']),
    leadTimeHours: ProductDetailDto._read_leadTimeHours(json['leadTimeHours']),
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    occasions: (json['occasions'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    optionGroups: (json['optionGroups'] as List<dynamic>)
        .map((e) => ProductOptionGroupDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    pairings: (json['pairings'] as List<dynamic>)
        .map((e) => ProductCardDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    priceFrom: json['priceFrom'] as bool,
    priceMinor: ProductDetailDto._read_priceMinor(json['priceMinor']),
    slug: json['slug'] as String,
    stockLeft: ProductDetailDto._read_stockLeft(json['stockLeft']),
    subtitle: LocalizedTextDto.fromJson(
      json['subtitle'] as Map<String, dynamic>,
    ),
    additionalProperties:
        ProductDetailDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ProductDetailDto._readExtras(
            ProductDetailDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$ProductDetailDtoToJson(ProductDetailDto instance) =>
    <String, dynamic>{
      'allergens': instance.allergens,
      'available': instance.available,
      'badges': ?ProductDetailDto._write_badges(instance.badges),
      'category': instance.category.toJson(),
      'categorySlug': instance.categorySlug,
      'colors': instance.colors,
      'customizable': instance.customizable,
      'description': instance.description.toJson(),
      'earliestDeliveryInDays': ?ProductDetailDto._write_earliestDeliveryInDays(
        instance.earliestDeliveryInDays,
      ),
      'flowerTypes': instance.flowerTypes,
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'isFavorite': instance.isFavorite,
      'kind': ?ProductDetailDto._write_kind(instance.kind),
      'leadTimeHours': ?ProductDetailDto._write_leadTimeHours(
        instance.leadTimeHours,
      ),
      'name': instance.name.toJson(),
      'occasions': instance.occasions,
      'optionGroups': instance.optionGroups.map((e) => e.toJson()).toList(),
      'pairings': instance.pairings.map((e) => e.toJson()).toList(),
      'priceFrom': instance.priceFrom,
      'priceMinor': ?ProductDetailDto._write_priceMinor(instance.priceMinor),
      'slug': instance.slug,
      'stockLeft': ProductDetailDto._write_stockLeft(instance.stockLeft),
      'subtitle': instance.subtitle.toJson(),
    };
