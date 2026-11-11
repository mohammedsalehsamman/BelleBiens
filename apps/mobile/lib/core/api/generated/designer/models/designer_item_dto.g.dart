// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'designer_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DesignerItemDto _$DesignerItemDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'available',
      'colorTags',
      'cutoutUrl',
      'detail',
      'id',
      'limited',
      'name',
      'swatch',
      'type',
      'unitPriceMinor',
    ],
    disallowNullValues: const [
      'colorTags',
      'detail',
      'id',
      'limited',
      'name',
      'type',
      'unitPriceMinor',
    ],
  );
  return DesignerItemDto(
    available: DesignerItemDto._read_available(json['available']),
    colorTags: (json['colorTags'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    cutoutUrl: json['cutoutUrl'] as String?,
    detail: LocalizedTextDto.fromJson(json['detail'] as Map<String, dynamic>),
    id: json['id'] as String,
    limited: json['limited'] as bool,
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    swatch: json['swatch'] as String?,
    type2: DesignerItemDto._read_type2(json['type']),
    unitPriceMinor: DesignerItemDto._read_unitPriceMinor(
      json['unitPriceMinor'],
    ),
    additionalProperties:
        DesignerItemDto._extras(json, 'additionalProperties') == null
        ? const {}
        : DesignerItemDto._readExtras(
            DesignerItemDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$DesignerItemDtoToJson(DesignerItemDto instance) =>
    <String, dynamic>{
      'available': DesignerItemDto._write_available(instance.available),
      'colorTags': instance.colorTags,
      'cutoutUrl': instance.cutoutUrl,
      'detail': instance.detail.toJson(),
      'id': instance.id,
      'limited': instance.limited,
      'name': instance.name.toJson(),
      'swatch': instance.swatch,
      'type': ?DesignerItemDto._write_type2(instance.type2),
      'unitPriceMinor': ?DesignerItemDto._write_unitPriceMinor(
        instance.unitPriceMinor,
      ),
    };
