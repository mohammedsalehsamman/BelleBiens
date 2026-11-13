// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesReportDto _$SalesReportDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'byCategory',
      'byPaymentMethod',
      'byProduct',
      'byZone',
      'coupons',
      'orders',
      'periods',
      'totalMinor',
      'totalUsdCents',
    ],
    disallowNullValues: const [
      'byCategory',
      'byPaymentMethod',
      'byProduct',
      'byZone',
      'coupons',
      'orders',
      'periods',
      'totalMinor',
      'totalUsdCents',
    ],
  );
  return SalesReportDto(
    byCategory: (json['byCategory'] as List<dynamic>)
        .map((e) => LineBucketDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    byPaymentMethod: (json['byPaymentMethod'] as List<dynamic>)
        .map((e) => BucketDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    byProduct: (json['byProduct'] as List<dynamic>)
        .map((e) => LineBucketDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    byZone: (json['byZone'] as List<dynamic>)
        .map((e) => BucketDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    coupons: (json['coupons'] as List<dynamic>)
        .map((e) => CouponBucketDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    orders: SalesReportDto._read_orders(json['orders']),
    periods: (json['periods'] as List<dynamic>)
        .map((e) => BucketDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    totalMinor: SalesReportDto._read_totalMinor(json['totalMinor']),
    totalUsdCents: SalesReportDto._read_totalUsdCents(json['totalUsdCents']),
    additionalProperties:
        SalesReportDto._extras(json, 'additionalProperties') == null
        ? const {}
        : SalesReportDto._readExtras(
            SalesReportDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$SalesReportDtoToJson(
  SalesReportDto instance,
) => <String, dynamic>{
  'byCategory': instance.byCategory.map((e) => e.toJson()).toList(),
  'byPaymentMethod': instance.byPaymentMethod.map((e) => e.toJson()).toList(),
  'byProduct': instance.byProduct.map((e) => e.toJson()).toList(),
  'byZone': instance.byZone.map((e) => e.toJson()).toList(),
  'coupons': instance.coupons.map((e) => e.toJson()).toList(),
  'orders': ?SalesReportDto._write_orders(instance.orders),
  'periods': instance.periods.map((e) => e.toJson()).toList(),
  'totalMinor': ?SalesReportDto._write_totalMinor(instance.totalMinor),
  'totalUsdCents': ?SalesReportDto._write_totalUsdCents(instance.totalUsdCents),
};
