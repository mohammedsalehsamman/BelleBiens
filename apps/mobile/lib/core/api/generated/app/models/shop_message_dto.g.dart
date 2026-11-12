// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopMessageDto _$ShopMessageDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['ar', 'en'],
    disallowNullValues: const ['ar', 'en'],
  );
  return ShopMessageDto(
    ar: json['ar'] as String,
    en: json['en'] as String,
    additionalProperties:
        ShopMessageDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ShopMessageDto._readExtras(
            ShopMessageDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$ShopMessageDtoToJson(ShopMessageDto instance) =>
    <String, dynamic>{'ar': instance.ar, 'en': instance.en};
