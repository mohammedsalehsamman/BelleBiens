// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'option_choice_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptionChoiceDto _$OptionChoiceDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['group', 'option'],
    disallowNullValues: const ['group', 'option'],
  );
  return OptionChoiceDto(
    group: json['group'] as String,
    option: json['option'] as String,
    additionalProperties:
        OptionChoiceDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OptionChoiceDto._readExtras(
            OptionChoiceDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$OptionChoiceDtoToJson(OptionChoiceDto instance) =>
    <String, dynamic>{'group': instance.group, 'option': instance.option};
