// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_choice_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductChoiceDto _$ProductChoiceDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['options', 'slug'],
    disallowNullValues: const [
      'inscription',
      'options',
      'referenceImageUrl',
      'slug',
    ],
  );
  return ProductChoiceDto(
    inscription: json['inscription'] as String?,
    options: (json['options'] as List<dynamic>)
        .map((e) => OptionChoiceDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    referenceImageUrl: json['referenceImageUrl'] as String?,
    slug: json['slug'] as String,
    additionalProperties:
        ProductChoiceDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ProductChoiceDto._readExtras(
            ProductChoiceDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$ProductChoiceDtoToJson(ProductChoiceDto instance) =>
    <String, dynamic>{
      'inscription': ?instance.inscription,
      'options': instance.options.map((e) => e.toJson()).toList(),
      'referenceImageUrl': ?instance.referenceImageUrl,
      'slug': instance.slug,
    };
