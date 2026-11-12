// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_template_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotTemplateDto _$SlotTemplateDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['capacity', 'end', 'start'],
    disallowNullValues: const ['capacity', 'end', 'start'],
  );
  return SlotTemplateDto(
    capacity: SlotTemplateDto._read_capacity(json['capacity']),
    end: json['end'] as String,
    start: json['start'] as String,
    additionalProperties:
        SlotTemplateDto._extras(json, 'additionalProperties') == null
        ? const {}
        : SlotTemplateDto._readExtras(
            SlotTemplateDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$SlotTemplateDtoToJson(SlotTemplateDto instance) =>
    <String, dynamic>{
      'capacity': ?SlotTemplateDto._write_capacity(instance.capacity),
      'end': instance.end,
      'start': instance.start,
    };
