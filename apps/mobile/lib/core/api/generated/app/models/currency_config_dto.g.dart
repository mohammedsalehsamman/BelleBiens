// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyConfigDto _$CurrencyConfigDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['base', 'usdRate'],
    disallowNullValues: const ['base', 'usdRate'],
  );
  return CurrencyConfigDto(
    base2: json['base'] as String,
    usdRate: json['usdRate'] as String,
    additionalProperties:
        CurrencyConfigDto._extras(json, 'additionalProperties') == null
        ? const {}
        : CurrencyConfigDto._readExtras(
            CurrencyConfigDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$CurrencyConfigDtoToJson(CurrencyConfigDto instance) =>
    <String, dynamic>{'base': instance.base2, 'usdRate': instance.usdRate};
