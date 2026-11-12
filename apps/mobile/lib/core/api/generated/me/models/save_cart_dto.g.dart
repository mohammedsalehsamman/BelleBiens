// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_cart_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveCartDto _$SaveCartDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['lines'],
    disallowNullValues: const ['lines'],
  );
  return SaveCartDto(
    lines: (json['lines'] as List<dynamic>)
        .map((e) => CartLineInputDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    additionalProperties:
        SaveCartDto._extras(json, 'additionalProperties') == null
        ? const {}
        : SaveCartDto._readExtras(
            SaveCartDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$SaveCartDtoToJson(SaveCartDto instance) =>
    <String, dynamic>{'lines': instance.lines.map((e) => e.toJson()).toList()};
