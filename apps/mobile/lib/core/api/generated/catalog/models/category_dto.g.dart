// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['icon', 'name', 'productCount', 'slug'],
    disallowNullValues: const ['name', 'productCount', 'slug'],
  );
  return CategoryDto(
    icon: json['icon'] as String?,
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    productCount: CategoryDto._read_productCount(json['productCount']),
    slug: json['slug'] as String,
    additionalProperties:
        CategoryDto._extras(json, 'additionalProperties') == null
        ? const {}
        : CategoryDto._readExtras(
            CategoryDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$CategoryDtoToJson(CategoryDto instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'name': instance.name.toJson(),
      'productCount': ?CategoryDto._write_productCount(instance.productCount),
      'slug': instance.slug,
    };
