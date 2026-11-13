// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_bucket_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponBucketDto _$CouponBucketDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'discountMinor',
      'key',
      'orders',
      'totalMinor',
      'totalUsdCents',
    ],
    disallowNullValues: const [
      'discountMinor',
      'key',
      'orders',
      'totalMinor',
      'totalUsdCents',
    ],
  );
  return CouponBucketDto(
    discountMinor: CouponBucketDto._read_discountMinor(json['discountMinor']),
    key: json['key'] as String,
    orders: CouponBucketDto._read_orders(json['orders']),
    totalMinor: CouponBucketDto._read_totalMinor(json['totalMinor']),
    totalUsdCents: CouponBucketDto._read_totalUsdCents(json['totalUsdCents']),
    additionalProperties:
        CouponBucketDto._extras(json, 'additionalProperties') == null
        ? const {}
        : CouponBucketDto._readExtras(
            CouponBucketDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$CouponBucketDtoToJson(CouponBucketDto instance) =>
    <String, dynamic>{
      'discountMinor': ?CouponBucketDto._write_discountMinor(
        instance.discountMinor,
      ),
      'key': instance.key,
      'orders': ?CouponBucketDto._write_orders(instance.orders),
      'totalMinor': ?CouponBucketDto._write_totalMinor(instance.totalMinor),
      'totalUsdCents': ?CouponBucketDto._write_totalUsdCents(
        instance.totalUsdCents,
      ),
    };
