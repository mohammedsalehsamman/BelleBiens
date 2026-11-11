// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occasion_page_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OccasionPageDto _$OccasionPageDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['occasion', 'products'],
    disallowNullValues: const ['occasion', 'products'],
  );
  return OccasionPageDto(
    occasion: OccasionDto.fromJson(json['occasion'] as Map<String, dynamic>),
    products: (json['products'] as List<dynamic>)
        .map((e) => ProductCardDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    additionalProperties:
        OccasionPageDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OccasionPageDto._readExtras(
            OccasionPageDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$OccasionPageDtoToJson(OccasionPageDto instance) =>
    <String, dynamic>{
      'occasion': instance.occasion.toJson(),
      'products': instance.products.map((e) => e.toJson()).toList(),
    };
