// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_me_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateMeDto _$UpdateMeDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    disallowNullValues: const [
      'acceptTerms',
      'email',
      'homeArea',
      'language',
      'marketingOptIn',
      'name',
      'numerals',
    ],
  );
  return UpdateMeDto(
    acceptTerms: json['acceptTerms'] as bool?,
    email: json['email'] as String?,
    homeArea: json['homeArea'] as String?,
    language: UpdateMeDto._read_language(json['language']),
    marketingOptIn: json['marketingOptIn'] as bool?,
    name: json['name'] as String?,
    numerals: UpdateMeDto._read_numerals(json['numerals']),
    additionalProperties:
        UpdateMeDto._extras(json, 'additionalProperties') == null
        ? const {}
        : UpdateMeDto._readExtras(
            UpdateMeDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$UpdateMeDtoToJson(UpdateMeDto instance) =>
    <String, dynamic>{
      'acceptTerms': ?instance.acceptTerms,
      'email': ?instance.email,
      'homeArea': ?instance.homeArea,
      'language': ?UpdateMeDto._write_language(instance.language),
      'marketingOptIn': ?instance.marketingOptIn,
      'name': ?instance.name,
      'numerals': ?UpdateMeDto._write_numerals(instance.numerals),
    };
