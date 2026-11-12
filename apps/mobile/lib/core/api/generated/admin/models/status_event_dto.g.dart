// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusEventDto _$StatusEventDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['at', 'status'],
    disallowNullValues: const ['at', 'status'],
  );
  return StatusEventDto(
    at: StatusEventDto._read_at(json['at']),
    status: StatusEventDto._read_status(json['status']),
    additionalProperties:
        StatusEventDto._extras(json, 'additionalProperties') == null
        ? const {}
        : StatusEventDto._readExtras(
            StatusEventDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$StatusEventDtoToJson(StatusEventDto instance) =>
    <String, dynamic>{
      'at': ?StatusEventDto._write_at(instance.at),
      'status': ?StatusEventDto._write_status(instance.status),
    };
