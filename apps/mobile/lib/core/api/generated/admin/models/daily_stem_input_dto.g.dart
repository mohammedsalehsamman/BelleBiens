// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_stem_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyStemInputDto _$DailyStemInputDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['quantity', 'slug'],
    disallowNullValues: const ['limited', 'quantity', 'slug'],
  );
  return DailyStemInputDto(
    limited: json['limited'] as bool?,
    quantity: json['quantity'] as num,
    slug: json['slug'] as String,
    additionalProperties:
        DailyStemInputDto._extras(json, 'additionalProperties') == null
        ? const {}
        : DailyStemInputDto._readExtras(
            DailyStemInputDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$DailyStemInputDtoToJson(DailyStemInputDto instance) =>
    <String, dynamic>{
      'limited': ?instance.limited,
      'quantity': instance.quantity,
      'slug': instance.slug,
    };
