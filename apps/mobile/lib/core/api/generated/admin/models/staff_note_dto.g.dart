// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_note_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffNoteDto _$StaffNoteDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['note'],
    disallowNullValues: const ['note'],
  );
  return StaffNoteDto(
    note: json['note'] as String,
    additionalProperties:
        StaffNoteDto._extras(json, 'additionalProperties') == null
        ? const {}
        : StaffNoteDto._readExtras(
            StaffNoteDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$StaffNoteDtoToJson(StaffNoteDto instance) =>
    <String, dynamic>{'note': instance.note};
