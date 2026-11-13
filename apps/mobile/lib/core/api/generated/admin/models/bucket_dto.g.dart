// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bucket_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BucketDto _$BucketDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['key', 'orders', 'totalMinor', 'totalUsdCents'],
    disallowNullValues: const ['key', 'orders', 'totalMinor', 'totalUsdCents'],
  );
  return BucketDto(
    key: json['key'] as String,
    orders: BucketDto._read_orders(json['orders']),
    totalMinor: BucketDto._read_totalMinor(json['totalMinor']),
    totalUsdCents: BucketDto._read_totalUsdCents(json['totalUsdCents']),
    additionalProperties:
        BucketDto._extras(json, 'additionalProperties') == null
        ? const {}
        : BucketDto._readExtras(
            BucketDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$BucketDtoToJson(BucketDto instance) => <String, dynamic>{
  'key': instance.key,
  'orders': ?BucketDto._write_orders(instance.orders),
  'totalMinor': ?BucketDto._write_totalMinor(instance.totalMinor),
  'totalUsdCents': ?BucketDto._write_totalUsdCents(instance.totalUsdCents),
};
