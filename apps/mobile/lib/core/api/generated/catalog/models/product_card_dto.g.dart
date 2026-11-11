// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCardDto _$ProductCardDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'available',
      'badges',
      'categorySlug',
      'id',
      'imageUrl',
      'kind',
      'leadTimeHours',
      'name',
      'priceFrom',
      'priceMinor',
      'slug',
      'stockLeft',
      'subtitle',
    ],
    disallowNullValues: const [
      'available',
      'badges',
      'categorySlug',
      'id',
      'kind',
      'leadTimeHours',
      'name',
      'priceFrom',
      'priceMinor',
      'slug',
      'subtitle',
    ],
  );
  return ProductCardDto(
    available: json['available'] as bool,
    badges: ProductCardDto._read_badges(json['badges']),
    categorySlug: json['categorySlug'] as String,
    id: json['id'] as String,
    imageUrl: json['imageUrl'] as String?,
    kind: ProductCardDto._read_kind(json['kind']),
    leadTimeHours: ProductCardDto._read_leadTimeHours(json['leadTimeHours']),
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    priceFrom: json['priceFrom'] as bool,
    priceMinor: ProductCardDto._read_priceMinor(json['priceMinor']),
    slug: json['slug'] as String,
    stockLeft: ProductCardDto._read_stockLeft(json['stockLeft']),
    subtitle: LocalizedTextDto.fromJson(
      json['subtitle'] as Map<String, dynamic>,
    ),
    additionalProperties:
        ProductCardDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ProductCardDto._readExtras(
            ProductCardDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$ProductCardDtoToJson(
  ProductCardDto instance,
) => <String, dynamic>{
  'available': instance.available,
  'badges': ?ProductCardDto._write_badges(instance.badges),
  'categorySlug': instance.categorySlug,
  'id': instance.id,
  'imageUrl': instance.imageUrl,
  'kind': ?ProductCardDto._write_kind(instance.kind),
  'leadTimeHours': ?ProductCardDto._write_leadTimeHours(instance.leadTimeHours),
  'name': instance.name.toJson(),
  'priceFrom': instance.priceFrom,
  'priceMinor': ?ProductCardDto._write_priceMinor(instance.priceMinor),
  'slug': instance.slug,
  'stockLeft': ProductCardDto._write_stockLeft(instance.stockLeft),
  'subtitle': instance.subtitle.toJson(),
};
