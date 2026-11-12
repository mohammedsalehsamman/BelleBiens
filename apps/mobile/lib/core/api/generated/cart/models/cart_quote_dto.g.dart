// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_quote_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartQuoteDto _$CartQuoteDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'earliestAt',
      'earliestInDays',
      'leadTimeHours',
      'lines',
      'orderable',
      'suggestions',
      'syp',
      'usd',
      'usdRate',
    ],
    disallowNullValues: const [
      'coupon',
      'earliestAt',
      'earliestInDays',
      'leadTimeHours',
      'lines',
      'orderable',
      'suggestions',
      'syp',
      'usd',
      'usdRate',
    ],
  );
  return CartQuoteDto(
    coupon: json['coupon'] == null
        ? null
        : CouponResultDto.fromJson(json['coupon'] as Map<String, dynamic>),
    earliestAt: json['earliestAt'] as String,
    earliestInDays: CartQuoteDto._read_earliestInDays(json['earliestInDays']),
    leadTimeHours: CartQuoteDto._read_leadTimeHours(json['leadTimeHours']),
    lines: (json['lines'] as List<dynamic>)
        .map((e) => QuotedLineDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    orderable: json['orderable'] as bool,
    suggestions: (json['suggestions'] as List<dynamic>)
        .map((e) => ProductCardDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    syp: MoneyBreakdownDto.fromJson(json['syp'] as Map<String, dynamic>),
    usd: MoneyBreakdownDto.fromJson(json['usd'] as Map<String, dynamic>),
    usdRate: json['usdRate'] as String,
    additionalProperties:
        CartQuoteDto._extras(json, 'additionalProperties') == null
        ? const {}
        : CartQuoteDto._readExtras(
            CartQuoteDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$CartQuoteDtoToJson(
  CartQuoteDto instance,
) => <String, dynamic>{
  'coupon': ?instance.coupon?.toJson(),
  'earliestAt': instance.earliestAt,
  'earliestInDays': ?CartQuoteDto._write_earliestInDays(
    instance.earliestInDays,
  ),
  'leadTimeHours': ?CartQuoteDto._write_leadTimeHours(instance.leadTimeHours),
  'lines': instance.lines.map((e) => e.toJson()).toList(),
  'orderable': instance.orderable,
  'suggestions': instance.suggestions.map((e) => e.toJson()).toList(),
  'syp': instance.syp.toJson(),
  'usd': instance.usd.toJson(),
  'usdRate': instance.usdRate,
};
