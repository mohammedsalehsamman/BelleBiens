// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'option_group_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptionGroupInputDto _$OptionGroupInputDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['key', 'nameAr', 'nameEn', 'options'],
    disallowNullValues: const [
      'key',
      'nameAr',
      'nameEn',
      'options',
      'required',
      'selection',
    ],
  );
  return OptionGroupInputDto(
    key: json['key'] as String,
    nameAr: json['nameAr'] as String,
    nameEn: json['nameEn'] as String,
    options: (json['options'] as List<dynamic>)
        .map((e) => OptionInputDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    required2: OptionGroupInputDto._presentValue(json, 'required') == null
        ? true
        : OptionGroupInputDto._read_required2(
            OptionGroupInputDto._presentValue(json, 'required') as Object,
          ),
    selection: OptionGroupInputDto._presentValue(json, 'selection') == null
        ? OptionGroupInputDtoSelection.single
        : OptionGroupInputDto._read_selection(
            OptionGroupInputDto._presentValue(json, 'selection') as Object,
          ),
    additionalProperties:
        OptionGroupInputDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OptionGroupInputDto._readExtras(
            OptionGroupInputDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$OptionGroupInputDtoToJson(
  OptionGroupInputDto instance,
) => <String, dynamic>{
  'key': instance.key,
  'nameAr': instance.nameAr,
  'nameEn': instance.nameEn,
  'options': instance.options.map((e) => e.toJson()).toList(),
  'required': ?OptionGroupInputDto._write_required2(instance.required2),
  'selection': ?OptionGroupInputDto._write_selection(instance.selection),
};
