// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_facet_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchFacetDto _$SearchFacetDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['categorySlug', 'count', 'name'],
    disallowNullValues: const ['categorySlug', 'count', 'name'],
  );
  return SearchFacetDto(
    categorySlug: json['categorySlug'] as String,
    count: SearchFacetDto._read_count(json['count']),
    name: LocalizedTextDto.fromJson(json['name'] as Map<String, dynamic>),
    additionalProperties:
        SearchFacetDto._extras(json, 'additionalProperties') == null
        ? const {}
        : SearchFacetDto._readExtras(
            SearchFacetDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$SearchFacetDtoToJson(SearchFacetDto instance) =>
    <String, dynamic>{
      'categorySlug': instance.categorySlug,
      'count': ?SearchFacetDto._write_count(instance.count),
      'name': instance.name.toJson(),
    };
