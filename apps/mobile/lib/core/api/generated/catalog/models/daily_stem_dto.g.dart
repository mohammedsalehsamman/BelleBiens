// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_stem_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyStemDto _$DailyStemDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'limited',
      'name',
      'quantity',
      'slug',
      'swatch',
      'type',
      'unitPriceMinor',
    ],
    disallowNullValues: const [
      'limited',
      'name',
      'quantity',
      'slug',
      'type',
      'unitPriceMinor',
    ],
  );
  return DailyStemDto(
    limited: json['limited'] as bool,
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    quantity: DailyStemDto._read_quantity(json['quantity']),
    slug: json['slug'] as String,
    swatch: json['swatch'] as String?,
    type2: DailyStemDto._read_type2(json['type']),
    unitPriceMinor: DailyStemDto._read_unitPriceMinor(json['unitPriceMinor']),
    additionalProperties:
        DailyStemDto._extras(json, 'additionalProperties') == null
        ? const {}
        : DailyStemDto._readExtras(
            DailyStemDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$DailyStemDtoToJson(DailyStemDto instance) =>
    <String, dynamic>{
      'limited': instance.limited,
      'name': instance.name.toJson(),
      'quantity': ?DailyStemDto._write_quantity(instance.quantity),
      'slug': instance.slug,
      'swatch': instance.swatch,
      'type': ?DailyStemDto._write_type2(instance.type2),
      'unitPriceMinor': ?DailyStemDto._write_unitPriceMinor(
        instance.unitPriceMinor,
      ),
    };
