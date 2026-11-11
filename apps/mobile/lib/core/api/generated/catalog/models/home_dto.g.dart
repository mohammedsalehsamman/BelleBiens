// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeDto _$HomeDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['branch', 'cakes', 'categories', 'today'],
    disallowNullValues: const ['branch', 'cakes', 'categories', 'today'],
  );
  return HomeDto(
    branch: BranchDto.fromJson(json['branch'] as Map<String, dynamic>),
    cakes: (json['cakes'] as List<dynamic>)
        .map((e) => ProductCardDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    categories: (json['categories'] as List<dynamic>)
        .map((e) => CategoryDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    today: (json['today'] as List<dynamic>)
        .map((e) => ProductCardDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    additionalProperties: HomeDto._extras(json, 'additionalProperties') == null
        ? const {}
        : HomeDto._readExtras(HomeDto._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$HomeDtoToJson(HomeDto instance) => <String, dynamic>{
  'branch': instance.branch.toJson(),
  'cakes': instance.cakes.map((e) => e.toJson()).toList(),
  'categories': instance.categories.map((e) => e.toJson()).toList(),
  'today': instance.today.map((e) => e.toJson()).toList(),
};
