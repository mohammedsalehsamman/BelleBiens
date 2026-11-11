// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_option_group_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOptionGroupDto _$ProductOptionGroupDtoFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    requiredKeys: const ['key', 'name', 'options', 'required', 'selection'],
    disallowNullValues: const [
      'key',
      'name',
      'options',
      'required',
      'selection',
    ],
  );
  return ProductOptionGroupDto(
    key: json['key'] as String,
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    options: (json['options'] as List<dynamic>)
        .map((e) => ProductOptionDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    required2: json['required'] as bool,
    selection: ProductOptionGroupDto._read_selection(json['selection']),
    additionalProperties:
        ProductOptionGroupDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ProductOptionGroupDto._readExtras(
            ProductOptionGroupDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$ProductOptionGroupDtoToJson(
  ProductOptionGroupDto instance,
) => <String, dynamic>{
  'key': instance.key,
  'name': instance.name.toJson(),
  'options': instance.options.map((e) => e.toJson()).toList(),
  'required': instance.required2,
  'selection': ?ProductOptionGroupDto._write_selection(instance.selection),
};
