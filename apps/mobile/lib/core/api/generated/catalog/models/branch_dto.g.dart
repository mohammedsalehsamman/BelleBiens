// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchDto _$BranchDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'address',
      'code',
      'instagram',
      'latitude',
      'longitude',
      'name',
      'pages',
      'partners',
      'phone',
      'status',
      'whatsapp',
    ],
    disallowNullValues: const [
      'address',
      'code',
      'name',
      'pages',
      'partners',
      'status',
    ],
  );
  return BranchDto(
    address: LocalizedTextDto.fromJson(json['address'] as Map<String, dynamic>),
    code: json['code'] as String,
    instagram: json['instagram'] as String?,
    latitude: json['latitude'] as num?,
    longitude: json['longitude'] as num?,
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    pages: (json['pages'] as List<dynamic>)
        .map((e) => PageLinkDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    partners: (json['partners'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    phone: json['phone'] as String?,
    status: ShopStatusDto.fromJson(json['status'] as Map<String, dynamic>),
    whatsapp: json['whatsapp'] as String?,
    additionalProperties:
        BranchDto._extras(json, 'additionalProperties') == null
        ? const {}
        : BranchDto._readExtras(
            BranchDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$BranchDtoToJson(BranchDto instance) => <String, dynamic>{
  'address': instance.address.toJson(),
  'code': instance.code,
  'instagram': instance.instagram,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'name': instance.name.toJson(),
  'pages': instance.pages.map((e) => e.toJson()).toList(),
  'partners': instance.partners,
  'phone': instance.phone,
  'status': instance.status.toJson(),
  'whatsapp': instance.whatsapp,
};
