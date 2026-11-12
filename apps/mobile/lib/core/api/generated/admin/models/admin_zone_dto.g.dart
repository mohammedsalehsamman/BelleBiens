// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_zone_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminZoneDto _$AdminZoneDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'active',
      'eta',
      'feeMinor',
      'id',
      'name',
      'polygon',
      'slug',
      'sortOrder',
    ],
    disallowNullValues: const [
      'active',
      'eta',
      'feeMinor',
      'id',
      'name',
      'polygon',
      'slug',
      'sortOrder',
    ],
  );
  return AdminZoneDto(
    active: json['active'] as bool,
    eta: LocalizedTextDto.fromJson(json['eta'] as Map<String, dynamic>),
    feeMinor: AdminZoneDto._read_feeMinor(json['feeMinor']),
    id: json['id'] as String,
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    polygon: (json['polygon'] as List<dynamic>)
        .map((e) => (e as List<dynamic>).map((e) => e as num).toList())
        .toList(),
    slug: json['slug'] as String,
    sortOrder: AdminZoneDto._read_sortOrder(json['sortOrder']),
    additionalProperties:
        AdminZoneDto._extras(json, 'additionalProperties') == null
        ? const {}
        : AdminZoneDto._readExtras(
            AdminZoneDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$AdminZoneDtoToJson(AdminZoneDto instance) =>
    <String, dynamic>{
      'active': instance.active,
      'eta': instance.eta.toJson(),
      'feeMinor': ?AdminZoneDto._write_feeMinor(instance.feeMinor),
      'id': instance.id,
      'name': instance.name.toJson(),
      'polygon': instance.polygon,
      'slug': instance.slug,
      'sortOrder': ?AdminZoneDto._write_sortOrder(instance.sortOrder),
    };
