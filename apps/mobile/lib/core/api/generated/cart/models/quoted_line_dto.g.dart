// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quoted_line_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuotedLineDto _$QuotedLineDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'imageUrl',
      'issues',
      'kind',
      'leadTimeHours',
      'qty',
      'summary',
      'title',
      'totalMinor',
      'unitPriceMinor',
    ],
    disallowNullValues: const [
      'id',
      'issues',
      'kind',
      'leadTimeHours',
      'qty',
      'summary',
      'title',
      'totalMinor',
      'unitPriceMinor',
    ],
  );
  return QuotedLineDto(
    id: json['id'] as String,
    imageUrl: json['imageUrl'] as String?,
    issues: (json['issues'] as List<dynamic>)
        .map((e) => LineIssueDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    kind: QuotedLineDto._read_kind(json['kind']),
    leadTimeHours: QuotedLineDto._read_leadTimeHours(json['leadTimeHours']),
    qty: QuotedLineDto._read_qty(json['qty']),
    summary: LocalizedTextDto.fromJson(json['summary'] as Map<String, dynamic>),
    title: LocalizedTextDto.fromJson(json['title'] as Map<String, dynamic>),
    totalMinor: QuotedLineDto._read_totalMinor(json['totalMinor']),
    unitPriceMinor: QuotedLineDto._read_unitPriceMinor(json['unitPriceMinor']),
    additionalProperties:
        QuotedLineDto._extras(json, 'additionalProperties') == null
        ? const {}
        : QuotedLineDto._readExtras(
            QuotedLineDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$QuotedLineDtoToJson(
  QuotedLineDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'imageUrl': instance.imageUrl,
  'issues': instance.issues.map((e) => e.toJson()).toList(),
  'kind': ?QuotedLineDto._write_kind(instance.kind),
  'leadTimeHours': ?QuotedLineDto._write_leadTimeHours(instance.leadTimeHours),
  'qty': ?QuotedLineDto._write_qty(instance.qty),
  'summary': instance.summary.toJson(),
  'title': instance.title.toJson(),
  'totalMinor': ?QuotedLineDto._write_totalMinor(instance.totalMinor),
  'unitPriceMinor': ?QuotedLineDto._write_unitPriceMinor(
    instance.unitPriceMinor,
  ),
};
