// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size_layout_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SizeLayoutDto _$SizeLayoutDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'extras',
      'flowers',
      'greens',
      'ribbon',
      'size',
      'wrapBack',
      'wrapFront',
    ],
    disallowNullValues: const [
      'extras',
      'flowers',
      'greens',
      'ribbon',
      'size',
      'wrapBack',
      'wrapFront',
    ],
  );
  return SizeLayoutDto(
    extras: (json['extras'] as List<dynamic>)
        .map((e) => SlotDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    flowers: (json['flowers'] as List<dynamic>)
        .map((e) => SlotDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    greens: (json['greens'] as List<dynamic>)
        .map((e) => SlotDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    ribbon: SlotDto.fromJson(json['ribbon'] as Map<String, dynamic>),
    size: SizeLayoutDto._read_size(json['size']),
    wrapBack: SlotDto.fromJson(json['wrapBack'] as Map<String, dynamic>),
    wrapFront: SlotDto.fromJson(json['wrapFront'] as Map<String, dynamic>),
    additionalProperties:
        SizeLayoutDto._extras(json, 'additionalProperties') == null
        ? const {}
        : SizeLayoutDto._readExtras(
            SizeLayoutDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$SizeLayoutDtoToJson(SizeLayoutDto instance) =>
    <String, dynamic>{
      'extras': instance.extras.map((e) => e.toJson()).toList(),
      'flowers': instance.flowers.map((e) => e.toJson()).toList(),
      'greens': instance.greens.map((e) => e.toJson()).toList(),
      'ribbon': instance.ribbon.toJson(),
      'size': ?SizeLayoutDto._write_size(instance.size),
      'wrapBack': instance.wrapBack.toJson(),
      'wrapFront': instance.wrapFront.toJson(),
    };
