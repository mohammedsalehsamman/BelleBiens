// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_bucket_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LineBucketDto _$LineBucketDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['key', 'qty', 'titleAr', 'titleEn', 'totalMinor'],
    disallowNullValues: const [
      'key',
      'qty',
      'titleAr',
      'titleEn',
      'totalMinor',
    ],
  );
  return LineBucketDto(
    key: json['key'] as String,
    qty: LineBucketDto._read_qty(json['qty']),
    titleAr: json['titleAr'] as String,
    titleEn: json['titleEn'] as String,
    totalMinor: LineBucketDto._read_totalMinor(json['totalMinor']),
    additionalProperties:
        LineBucketDto._extras(json, 'additionalProperties') == null
        ? const {}
        : LineBucketDto._readExtras(
            LineBucketDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$LineBucketDtoToJson(LineBucketDto instance) =>
    <String, dynamic>{
      'key': instance.key,
      'qty': ?LineBucketDto._write_qty(instance.qty),
      'titleAr': instance.titleAr,
      'titleEn': instance.titleEn,
      'totalMinor': ?LineBucketDto._write_totalMinor(instance.totalMinor),
    };
