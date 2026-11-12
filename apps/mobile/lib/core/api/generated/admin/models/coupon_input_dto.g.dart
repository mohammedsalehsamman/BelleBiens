// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponInputDto _$CouponInputDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['code', 'type', 'value'],
    disallowNullValues: const [
      'active',
      'code',
      'endsAt',
      'maxRedemptions',
      'minOrderMinor',
      'startsAt',
      'type',
      'value',
    ],
  );
  return CouponInputDto(
    active: json['active'] as bool?,
    code: json['code'] as String,
    endsAt: CouponInputDto._read_endsAt(json['endsAt']),
    maxRedemptions: json['maxRedemptions'] as num?,
    minOrderMinor: json['minOrderMinor'] as num?,
    startsAt: CouponInputDto._read_startsAt(json['startsAt']),
    type2: CouponInputDto._read_type2(json['type']),
    value: json['value'] as num,
    additionalProperties:
        CouponInputDto._extras(json, 'additionalProperties') == null
        ? const {}
        : CouponInputDto._readExtras(
            CouponInputDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$CouponInputDtoToJson(CouponInputDto instance) =>
    <String, dynamic>{
      'active': ?instance.active,
      'code': instance.code,
      'endsAt': ?CouponInputDto._write_endsAt(instance.endsAt),
      'maxRedemptions': ?instance.maxRedemptions,
      'minOrderMinor': ?instance.minOrderMinor,
      'startsAt': ?CouponInputDto._write_startsAt(instance.startsAt),
      'type': ?CouponInputDto._write_type2(instance.type2),
      'value': instance.value,
    };
