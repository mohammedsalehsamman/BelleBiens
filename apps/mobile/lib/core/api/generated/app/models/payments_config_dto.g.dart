// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentsConfigDto _$PaymentsConfigDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['cash', 'shamcash', 'stripe', 'unpaidTimeoutMinutes'],
    disallowNullValues: const [
      'cash',
      'shamcash',
      'shamcashAccount',
      'stripe',
      'unpaidTimeoutMinutes',
    ],
  );
  return PaymentsConfigDto(
    cash: json['cash'] as bool,
    shamcash: json['shamcash'] as bool,
    shamcashAccount: json['shamcashAccount'] as String?,
    stripe: json['stripe'] as bool,
    unpaidTimeoutMinutes: PaymentsConfigDto._read_unpaidTimeoutMinutes(
      json['unpaidTimeoutMinutes'],
    ),
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
      'shamcashAccount': ?instance.shamcashAccount,
      'stripe': instance.stripe,
      'unpaidTimeoutMinutes': ?PaymentsConfigDto._write_unpaidTimeoutMinutes(
        instance.unpaidTimeoutMinutes,
      ),
    };
