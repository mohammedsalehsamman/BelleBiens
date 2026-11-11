// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'designer_quote_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DesignerQuoteDto _$DesignerQuoteDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'assemblyFeeMinor',
      'issues',
      'itemsMinor',
      'lines',
      'orderable',
      'size',
      'specHash',
      'stems',
      'totalMinor',
      'totalUsdCents',
      'usdRate',
    ],
    disallowNullValues: const [
      'assemblyFeeMinor',
      'issues',
      'itemsMinor',
      'lines',
      'orderable',
      'size',
      'specHash',
      'stems',
      'totalMinor',
      'totalUsdCents',
      'usdRate',
    ],
  );
  return DesignerQuoteDto(
    assemblyFeeMinor: DesignerQuoteDto._read_assemblyFeeMinor(
      json['assemblyFeeMinor'],
    ),
    issues: (json['issues'] as List<dynamic>)
        .map((e) => QuoteIssueDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    itemsMinor: DesignerQuoteDto._read_itemsMinor(json['itemsMinor']),
    lines: (json['lines'] as List<dynamic>)
        .map((e) => QuoteLineDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    orderable: json['orderable'] as bool,
    size: DesignerSizeDto.fromJson(json['size'] as Map<String, dynamic>),
    specHash: json['specHash'] as String,
    stems: DesignerQuoteDto._read_stems(json['stems']),
    totalMinor: DesignerQuoteDto._read_totalMinor(json['totalMinor']),
    totalUsdCents: DesignerQuoteDto._read_totalUsdCents(json['totalUsdCents']),
    usdRate: json['usdRate'] as String,
    additionalProperties:
        DesignerQuoteDto._extras(json, 'additionalProperties') == null
        ? const {}
        : DesignerQuoteDto._readExtras(
            DesignerQuoteDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$DesignerQuoteDtoToJson(DesignerQuoteDto instance) =>
    <String, dynamic>{
      'assemblyFeeMinor': ?DesignerQuoteDto._write_assemblyFeeMinor(
        instance.assemblyFeeMinor,
      ),
      'issues': instance.issues.map((e) => e.toJson()).toList(),
      'itemsMinor': ?DesignerQuoteDto._write_itemsMinor(instance.itemsMinor),
      'lines': instance.lines.map((e) => e.toJson()).toList(),
      'orderable': instance.orderable,
      'size': instance.size.toJson(),
      'specHash': instance.specHash,
      'stems': ?DesignerQuoteDto._write_stems(instance.stems),
      'totalMinor': ?DesignerQuoteDto._write_totalMinor(instance.totalMinor),
      'totalUsdCents': ?DesignerQuoteDto._write_totalUsdCents(
        instance.totalUsdCents,
      ),
      'usdRate': instance.usdRate,
    };
