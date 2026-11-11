// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_stems_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyStemsInputDto _$DailyStemsInputDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['items'],
    disallowNullValues: const ['items'],
  );
  return DailyStemsInputDto(
    items: (json['items'] as List<dynamic>)
        .map((e) => DailyStemInputDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    additionalProperties:
        DailyStemsInputDto._extras(json, 'additionalProperties') == null
        ? const {}
        : DailyStemsInputDto._readExtras(
            DailyStemsInputDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$DailyStemsInputDtoToJson(DailyStemsInputDto instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
