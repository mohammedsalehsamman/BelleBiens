// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_line_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartLineInputDto _$CartLineInputDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'kind', 'qty'],
    disallowNullValues: const [
      'id',
      'kind',
      'previewUrl',
      'product',
      'qty',
      'spec',
    ],
  );
  return CartLineInputDto(
    id: json['id'] as String,
    kind: CartLineInputDto._read_kind(json['kind']),
    previewUrl: json['previewUrl'] as String?,
    product: json['product'] == null
        ? null
        : ProductChoiceDto.fromJson(json['product'] as Map<String, dynamic>),
    qty: json['qty'] as num,
    spec: json['spec'] == null
        ? null
        : CartLineInputDtoSpec.fromJson(json['spec'] as Map<String, dynamic>),
    additionalProperties:
        CartLineInputDto._extras(json, 'additionalProperties') == null
        ? const {}
        : CartLineInputDto._readExtras(
            CartLineInputDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$CartLineInputDtoToJson(CartLineInputDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': ?CartLineInputDto._write_kind(instance.kind),
      'previewUrl': ?instance.previewUrl,
      'product': ?instance.product?.toJson(),
      'qty': instance.qty,
      'spec': ?instance.spec?.toJson(),
    };
