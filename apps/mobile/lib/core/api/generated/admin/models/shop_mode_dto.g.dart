// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_mode_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopModeDto _$ShopModeDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['mode'],
    disallowNullValues: const ['acceptsFrom', 'message', 'mode'],
  );
  return ShopModeDto(
    acceptsFrom: json['acceptsFrom'] as String?,
    message: json['message'] == null
        ? null
        : MessageInputDto.fromJson(json['message'] as Map<String, dynamic>),
    mode: ShopModeDto._read_mode(json['mode']),
    additionalProperties:
        ShopModeDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ShopModeDto._readExtras(
            ShopModeDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$ShopModeDtoToJson(ShopModeDto instance) =>
    <String, dynamic>{
      'acceptsFrom': ?instance.acceptsFrom,
      'message': ?instance.message?.toJson(),
      'mode': ?ShopModeDto._write_mode(instance.mode),
    };
