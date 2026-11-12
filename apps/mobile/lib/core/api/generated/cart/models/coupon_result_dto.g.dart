// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponResultDto _$CouponResultDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['applied', 'code', 'minOrderMinor', 'problem'],
    disallowNullValues: const ['applied', 'code', 'minOrderMinor'],
  );
  return CouponResultDto(
    applied: json['applied'] as bool,
    code: json['code'] as String,
    minOrderMinor: CouponResultDto._read_minOrderMinor(json['minOrderMinor']),
    problem: CouponResultDto._read_problem(json['problem']),
    additionalProperties:
        CouponResultDto._extras(json, 'additionalProperties') == null
        ? const {}
        : CouponResultDto._readExtras(
            CouponResultDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$CouponResultDtoToJson(CouponResultDto instance) =>
    <String, dynamic>{
      'applied': instance.applied,
      'code': instance.code,
      'minOrderMinor': ?CouponResultDto._write_minOrderMinor(
        instance.minOrderMinor,
      ),
      'problem': CouponResultDto._write_problem(instance.problem),
    };
