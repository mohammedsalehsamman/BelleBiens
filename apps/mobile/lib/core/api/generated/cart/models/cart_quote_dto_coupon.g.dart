// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_quote_dto_coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartQuoteDtoCoupon _$CartQuoteDtoCouponFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['applied', 'code', 'minOrderMinor', 'problem'],
    disallowNullValues: const ['applied', 'code', 'minOrderMinor'],
  );
  return CartQuoteDtoCoupon(
    applied: json['applied'] as bool,
    code: json['code'] as String,
    minOrderMinor: CartQuoteDtoCoupon._read_minOrderMinor(
      json['minOrderMinor'],
    ),
    problem: CartQuoteDtoCoupon._read_problem(json['problem']),
    additionalProperties:
        CartQuoteDtoCoupon._extras(json, 'additionalProperties') == null
        ? const {}
        : CartQuoteDtoCoupon._readExtras(
            CartQuoteDtoCoupon._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$CartQuoteDtoCouponToJson(CartQuoteDtoCoupon instance) =>
    <String, dynamic>{
      'applied': instance.applied,
      'code': instance.code,
      'minOrderMinor': ?CartQuoteDtoCoupon._write_minOrderMinor(
        instance.minOrderMinor,
      ),
      'problem': CartQuoteDtoCoupon._write_problem(instance.problem),
    };
