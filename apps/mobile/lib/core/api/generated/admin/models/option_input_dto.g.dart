// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'option_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptionInputDto _$OptionInputDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['key', 'nameAr', 'nameEn'],
    disallowNullValues: const [
      'detailAr',
      'detailEn',
      'isDefault',
      'key',
      'nameAr',
      'nameEn',
      'priceChangeMinor',
      'swatch',
    ],
  );
  return OptionInputDto(
    detailAr: json['detailAr'] as String?,
    detailEn: json['detailEn'] as String?,
    isDefault: json['isDefault'] as bool?,
    key: json['key'] as String,
    nameAr: json['nameAr'] as String,
    nameEn: json['nameEn'] as String,
    priceChangeMinor: json['priceChangeMinor'] as num?,
    swatch: json['swatch'] as String?,
    additionalProperties:
        OptionInputDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OptionInputDto._readExtras(
            OptionInputDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$OptionInputDtoToJson(OptionInputDto instance) =>
    <String, dynamic>{
      'detailAr': ?instance.detailAr,
      'detailEn': ?instance.detailEn,
      'isDefault': ?instance.isDefault,
      'key': instance.key,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'priceChangeMinor': ?instance.priceChangeMinor,
      'swatch': ?instance.swatch,
    };
