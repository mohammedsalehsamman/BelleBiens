// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_quote_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartQuoteRequestDto _$CartQuoteRequestDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['lines'],
    disallowNullValues: const ['couponCode', 'lines', 'zone'],
  );
  return CartQuoteRequestDto(
    couponCode: json['couponCode'] as String?,
    lines: (json['lines'] as List<dynamic>)
        .map((e) => CartLineInputDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    zone: json['zone'] as String?,
    additionalProperties:
        CartQuoteRequestDto._extras(json, 'additionalProperties') == null
        ? const {}
        : CartQuoteRequestDto._readExtras(
            CartQuoteRequestDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$CartQuoteRequestDtoToJson(
  CartQuoteRequestDto instance,
) => <String, dynamic>{
  'couponCode': ?instance.couponCode,
  'lines': instance.lines.map((e) => e.toJson()).toList(),
  'zone': ?instance.zone,
};
