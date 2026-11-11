// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodayListDto _$TodayListDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['productSlugs'],
    disallowNullValues: const ['productSlugs'],
  );
  return TodayListDto(
    productSlugs: (json['productSlugs'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    additionalProperties:
        TodayListDto._extras(json, 'additionalProperties') == null
        ? const {}
        : TodayListDto._readExtras(
            TodayListDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$TodayListDtoToJson(TodayListDto instance) =>
    <String, dynamic>{'productSlugs': instance.productSlugs};
