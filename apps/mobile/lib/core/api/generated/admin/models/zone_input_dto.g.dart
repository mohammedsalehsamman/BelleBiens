// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZoneInputDto _$ZoneInputDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['feeMinor', 'nameAr', 'nameEn', 'polygon', 'slug'],
    disallowNullValues: const [
      'active',
      'etaAr',
      'etaEn',
      'feeMinor',
      'nameAr',
      'nameEn',
      'polygon',
      'slug',
      'sortOrder',
    ],
  );
  return ZoneInputDto(
    active: json['active'] as bool?,
    etaAr: json['etaAr'] as String?,
    etaEn: json['etaEn'] as String?,
    feeMinor: ZoneInputDto._read_feeMinor(json['feeMinor']),
    nameAr: json['nameAr'] as String,
    nameEn: json['nameEn'] as String,
    polygon: (json['polygon'] as List<dynamic>)
        .map((e) => (e as List<dynamic>).map((e) => e as num).toList())
        .toList(),
    slug: json['slug'] as String,
    sortOrder: ZoneInputDto._read_sortOrder(json['sortOrder']),
    additionalProperties:
        ZoneInputDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ZoneInputDto._readExtras(
            ZoneInputDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$ZoneInputDtoToJson(ZoneInputDto instance) =>
    <String, dynamic>{
      'active': ?instance.active,
      'etaAr': ?instance.etaAr,
      'etaEn': ?instance.etaEn,
      'feeMinor': ?ZoneInputDto._write_feeMinor(instance.feeMinor),
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'polygon': instance.polygon,
      'slug': instance.slug,
      'sortOrder': ?ZoneInputDto._write_sortOrder(instance.sortOrder),
    };
