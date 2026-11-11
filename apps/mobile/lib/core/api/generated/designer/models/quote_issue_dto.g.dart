// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_issue_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteIssueDto _$QuoteIssueDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['code'],
    disallowNullValues: const [
      'alternatives',
      'available',
      'code',
      'itemId',
      'max',
      'min',
      'requested',
    ],
  );
  return QuoteIssueDto(
    alternatives: (json['alternatives'] as List<dynamic>?)
        ?.map((e) => AlternativeDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    available: QuoteIssueDto._read_available(json['available']),
    code: QuoteIssueDto._read_code(json['code']),
    itemId: json['itemId'] as String?,
    max: QuoteIssueDto._read_max(json['max']),
    min: QuoteIssueDto._read_min(json['min']),
    requested: QuoteIssueDto._read_requested(json['requested']),
    additionalProperties:
        QuoteIssueDto._extras(json, 'additionalProperties') == null
        ? const {}
        : QuoteIssueDto._readExtras(
            QuoteIssueDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$QuoteIssueDtoToJson(QuoteIssueDto instance) =>
    <String, dynamic>{
      'alternatives': ?instance.alternatives?.map((e) => e.toJson()).toList(),
      'available': ?QuoteIssueDto._write_available(instance.available),
      'code': ?QuoteIssueDto._write_code(instance.code),
      'itemId': ?instance.itemId,
      'max': ?QuoteIssueDto._write_max(instance.max),
      'min': ?QuoteIssueDto._write_min(instance.min),
      'requested': ?QuoteIssueDto._write_requested(instance.requested),
    };
