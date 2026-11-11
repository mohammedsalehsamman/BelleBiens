// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_image_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductImageDto _$ProductImageDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['alt', 'url'],
    disallowNullValues: const ['alt', 'url'],
  );
  return ProductImageDto(
    alt: LocalizedTextDto.fromJson(json['alt'] as Map<String, dynamic>),
    url: json['url'] as String,
    additionalProperties:
        ProductImageDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ProductImageDto._readExtras(
            ProductImageDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$ProductImageDtoToJson(ProductImageDto instance) =>
    <String, dynamic>{'alt': instance.alt.toJson(), 'url': instance.url};
