// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_change_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusChangeDto _$StatusChangeDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['to'],
    disallowNullValues: const ['note', 'to'],
  );
  return StatusChangeDto(
    note: json['note'] as String?,
    to: StatusChangeDto._read_to(json['to']),
    additionalProperties:
        StatusChangeDto._extras(json, 'additionalProperties') == null
        ? const {}
        : StatusChangeDto._readExtras(
            StatusChangeDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$StatusChangeDtoToJson(StatusChangeDto instance) =>
    <String, dynamic>{
      'note': ?instance.note,
      'to': ?StatusChangeDto._write_to(instance.to),
    };
