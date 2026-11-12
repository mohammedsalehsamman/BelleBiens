// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_input_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageInputDto _$MessageInputDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['ar', 'en'],
    disallowNullValues: const ['ar', 'en'],
  );
  return MessageInputDto(
    ar: json['ar'] as String,
    en: json['en'] as String,
    additionalProperties:
        MessageInputDto._extras(json, 'additionalProperties') == null
        ? const {}
        : MessageInputDto._readExtras(
            MessageInputDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$MessageInputDtoToJson(MessageInputDto instance) =>
    <String, dynamic>{'ar': instance.ar, 'en': instance.en};
