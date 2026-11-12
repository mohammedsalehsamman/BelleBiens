// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartDto _$CartDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['lines', 'updatedAt'],
    disallowNullValues: const ['lines'],
  );
  return CartDto(
    lines: (json['lines'] as List<dynamic>)
        .map((e) => CartLineInputDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    updatedAt: CartDto._read_updatedAt(json['updatedAt']),
    additionalProperties: CartDto._extras(json, 'additionalProperties') == null
        ? const {}
        : CartDto._readExtras(CartDto._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$CartDtoToJson(CartDto instance) => <String, dynamic>{
  'lines': instance.lines.map((e) => e.toJson()).toList(),
  'updatedAt': CartDto._write_updatedAt(instance.updatedAt),
};
