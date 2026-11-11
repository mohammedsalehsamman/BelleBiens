// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_flowers_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyFlowersDto _$DailyFlowersDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['date', 'expiresAt', 'products', 'stems'],
    disallowNullValues: const ['date', 'expiresAt', 'products', 'stems'],
  );
  return DailyFlowersDto(
    date: json['date'] as String,
    expiresAt: json['expiresAt'] as String,
    products: (json['products'] as List<dynamic>)
        .map((e) => ProductCardDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    stems: (json['stems'] as List<dynamic>)
        .map((e) => DailyStemDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    additionalProperties:
        DailyFlowersDto._extras(json, 'additionalProperties') == null
        ? const {}
        : DailyFlowersDto._readExtras(
            DailyFlowersDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$DailyFlowersDtoToJson(DailyFlowersDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'expiresAt': instance.expiresAt,
      'products': instance.products.map((e) => e.toJson()).toList(),
      'stems': instance.stems.map((e) => e.toJson()).toList(),
    };
