// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResultDto _$SearchResultDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['facets', 'items', 'query', 'total'],
    disallowNullValues: const ['facets', 'items', 'query', 'total'],
  );
  return SearchResultDto(
    facets: (json['facets'] as List<dynamic>)
        .map((e) => SearchFacetDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    items: (json['items'] as List<dynamic>)
        .map((e) => ProductCardDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    query: json['query'] as String,
    total: SearchResultDto._read_total(json['total']),
    additionalProperties:
        SearchResultDto._extras(json, 'additionalProperties') == null
        ? const {}
        : SearchResultDto._readExtras(
            SearchResultDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$SearchResultDtoToJson(SearchResultDto instance) =>
    <String, dynamic>{
      'facets': instance.facets.map((e) => e.toJson()).toList(),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'query': instance.query,
      'total': ?SearchResultDto._write_total(instance.total),
    };
