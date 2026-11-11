// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_page_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductPageDto _$ProductPageDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['items', 'page', 'pageSize', 'total'],
    disallowNullValues: const ['items', 'page', 'pageSize', 'total'],
  );
  return ProductPageDto(
    items: (json['items'] as List<dynamic>)
        .map((e) => ProductCardDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    page: ProductPageDto._read_page(json['page']),
    pageSize: ProductPageDto._read_pageSize(json['pageSize']),
    total: ProductPageDto._read_total(json['total']),
    additionalProperties:
        ProductPageDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ProductPageDto._readExtras(
            ProductPageDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$ProductPageDtoToJson(ProductPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'page': ?ProductPageDto._write_page(instance.page),
      'pageSize': ?ProductPageDto._write_pageSize(instance.pageSize),
      'total': ?ProductPageDto._write_total(instance.total),
    };
