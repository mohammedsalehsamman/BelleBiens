// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_range_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceRangeDto _$PriceRangeDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['maxMinor', 'minMinor'],
    disallowNullValues: const ['maxMinor', 'minMinor'],
  );
  return PriceRangeDto(
    maxMinor: PriceRangeDto._read_maxMinor(json['maxMinor']),
    minMinor: PriceRangeDto._read_minMinor(json['minMinor']),
    additionalProperties:
        PriceRangeDto._extras(json, 'additionalProperties') == null
        ? const {}
        : PriceRangeDto._readExtras(
            PriceRangeDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$PriceRangeDtoToJson(PriceRangeDto instance) =>
    <String, dynamic>{
      'maxMinor': ?PriceRangeDto._write_maxMinor(instance.maxMinor),
      'minMinor': ?PriceRangeDto._write_minMinor(instance.minMinor),
    };
