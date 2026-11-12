// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponDto _$CouponDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['code', 'id', 'redemptions', 'type', 'value'],
    disallowNullValues: const [
      'active',
      'code',
      'endsAt',
      'id',
      'maxRedemptions',
      'minOrderMinor',
      'redemptions',
      'startsAt',
      'type',
      'value',
    ],
  );
  return CouponDto(
    active: json['active'] as bool?,
    code: json['code'] as String,
    endsAt: CouponDto._read_endsAt(json['endsAt']),
    id: json['id'] as String,
    maxRedemptions: json['maxRedemptions'] as num?,
    minOrderMinor: json['minOrderMinor'] as num?,
    redemptions: CouponDto._read_redemptions(json['redemptions']),
    startsAt: CouponDto._read_startsAt(json['startsAt']),
    type2: CouponDto._read_type2(json['type']),
    value: json['value'] as num,
    additionalProperties:
        CouponDto._extras(json, 'additionalProperties') == null
        ? const {}
        : CouponDto._readExtras(
            CouponDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$CouponDtoToJson(CouponDto instance) => <String, dynamic>{
  'active': ?instance.active,
  'code': instance.code,
  'endsAt': ?CouponDto._write_endsAt(instance.endsAt),
  'id': instance.id,
  'maxRedemptions': ?instance.maxRedemptions,
  'minOrderMinor': ?instance.minOrderMinor,
  'redemptions': ?CouponDto._write_redemptions(instance.redemptions),
  'startsAt': ?CouponDto._write_startsAt(instance.startsAt),
  'type': ?CouponDto._write_type2(instance.type2),
  'value': instance.value,
};
