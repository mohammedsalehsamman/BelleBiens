// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigDto _$AppConfigDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'auth',
      'currency',
      'features',
      'minSupportedVersion',
      'payments',
      'shop',
    ],
    disallowNullValues: const [
      'auth',
      'currency',
      'features',
      'minSupportedVersion',
      'payments',
      'shop',
    ],
  );
  return AppConfigDto(
    auth: AuthConfigDto.fromJson(json['auth'] as Map<String, dynamic>),
    currency: CurrencyConfigDto.fromJson(
      json['currency'] as Map<String, dynamic>,
    ),
    features: FeaturesConfigDto.fromJson(
      json['features'] as Map<String, dynamic>,
    ),
    minSupportedVersion: json['minSupportedVersion'] as String,
    payments: PaymentsConfigDto.fromJson(
      json['payments'] as Map<String, dynamic>,
    ),
    shop: ShopConfigDto.fromJson(json['shop'] as Map<String, dynamic>),
    additionalProperties:
        AppConfigDto._extras(json, 'additionalProperties') == null
        ? const {}
        : AppConfigDto._readExtras(
            AppConfigDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$AppConfigDtoToJson(AppConfigDto instance) =>
    <String, dynamic>{
      'auth': instance.auth.toJson(),
      'currency': instance.currency.toJson(),
      'features': instance.features.toJson(),
      'minSupportedVersion': instance.minSupportedVersion,
      'payments': instance.payments.toJson(),
      'shop': instance.shop.toJson(),
    };
