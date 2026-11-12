// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_issue_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LineIssueDto _$LineIssueDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['code'],
    disallowNullValues: const ['available', 'code', 'itemId', 'requested'],
  );
  return LineIssueDto(
    available: LineIssueDto._read_available(json['available']),
    code: LineIssueDto._read_code(json['code']),
    itemId: json['itemId'] as String?,
    requested: LineIssueDto._read_requested(json['requested']),
    additionalProperties:
        LineIssueDto._extras(json, 'additionalProperties') == null
        ? const {}
        : LineIssueDto._readExtras(
            LineIssueDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$LineIssueDtoToJson(LineIssueDto instance) =>
    <String, dynamic>{
      'available': ?LineIssueDto._write_available(instance.available),
      'code': ?LineIssueDto._write_code(instance.code),
      'itemId': ?instance.itemId,
      'requested': ?LineIssueDto._write_requested(instance.requested),
    };
