// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentsConfigDto _$PaymentsConfigDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['cash', 'shamcash', 'stripe'],
    disallowNullValues: const ['cash', 'shamcash', 'stripe'],
  );
  return PaymentsConfigDto(
    cash: json['cash'] as bool,
    shamcash: json['shamcash'] as bool,
    stripe: json['stripe'] as bool,
    additionalProperties:
        PaymentsConfigDto._extras(json, 'additionalProperties') == null
        ? const {}
        : PaymentsConfigDto._readExtras(
            PaymentsConfigDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$PaymentsConfigDtoToJson(PaymentsConfigDto instance) =>
    <String, dynamic>{
      'cash': instance.cash,
      'shamcash': instance.shamcash,
      'stripe': instance.stripe,
    };
