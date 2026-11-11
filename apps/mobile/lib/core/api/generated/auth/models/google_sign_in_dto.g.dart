// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_in_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleSignInDto _$GoogleSignInDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['idToken'],
    disallowNullValues: const [
      'acceptTerms',
      'email',
      'homeArea',
      'idToken',
      'marketingOptIn',
      'name',
    ],
  );
  return GoogleSignInDto(
    acceptTerms: json['acceptTerms'] as bool?,
    email: json['email'] as String?,
    homeArea: json['homeArea'] as String?,
    idToken: json['idToken'] as String,
    marketingOptIn: json['marketingOptIn'] as bool?,
    name: json['name'] as String?,
    additionalProperties:
        GoogleSignInDto._extras(json, 'additionalProperties') == null
        ? const {}
        : GoogleSignInDto._readExtras(
            GoogleSignInDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$GoogleSignInDtoToJson(GoogleSignInDto instance) =>
    <String, dynamic>{
      'acceptTerms': ?instance.acceptTerms,
      'email': ?instance.email,
      'homeArea': ?instance.homeArea,
      'idToken': instance.idToken,
      'marketingOptIn': ?instance.marketingOptIn,
      'name': ?instance.name,
    };
