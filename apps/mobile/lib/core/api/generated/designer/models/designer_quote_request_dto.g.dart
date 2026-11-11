// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'designer_quote_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DesignerQuoteRequestDto _$DesignerQuoteRequestDtoFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    requiredKeys: const ['spec'],
    disallowNullValues: const ['spec'],
  );
  return DesignerQuoteRequestDto(
    spec: DesignerQuoteRequestDtoSpec.fromJson(
      json['spec'] as Map<String, dynamic>,
    ),
    additionalProperties:
        DesignerQuoteRequestDto._extras(json, 'additionalProperties') == null
        ? const {}
        : DesignerQuoteRequestDto._readExtras(
            DesignerQuoteRequestDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$DesignerQuoteRequestDtoToJson(
  DesignerQuoteRequestDto instance,
) => <String, dynamic>{'spec': instance.spec.toJson()};
