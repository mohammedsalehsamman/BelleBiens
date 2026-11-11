// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_status_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopStatusDto _$ShopStatusDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['closesAt', 'mode', 'openNow', 'opensAt'],
    disallowNullValues: const ['closesAt', 'mode', 'openNow', 'opensAt'],
  );
  return ShopStatusDto(
    closesAt: json['closesAt'] as String,
    mode: ShopStatusDto._read_mode(json['mode']),
    openNow: json['openNow'] as bool,
    opensAt: json['opensAt'] as String,
    additionalProperties:
        ShopStatusDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ShopStatusDto._readExtras(
            ShopStatusDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$ShopStatusDtoToJson(ShopStatusDto instance) =>
    <String, dynamic>{
      'closesAt': instance.closesAt,
      'mode': ?ShopStatusDto._write_mode(instance.mode),
      'openNow': instance.openNow,
      'opensAt': instance.opensAt,
    };
