// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterDto _$RegisterDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['acceptTerms', 'email', 'name', 'password'],
    disallowNullValues: const [
      'acceptTerms',
      'email',
      'marketingOptIn',
      'name',
      'password',
    ],
  );
  return RegisterDto(
    acceptTerms: json['acceptTerms'] as bool,
    email: json['email'] as String,
    marketingOptIn: json['marketingOptIn'] as bool?,
    name: json['name'] as String,
    password: json['password'] as String,
    additionalProperties:
        RegisterDto._extras(json, 'additionalProperties') == null
        ? const {}
        : RegisterDto._readExtras(
            RegisterDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$RegisterDtoToJson(RegisterDto instance) =>
    <String, dynamic>{
      'acceptTerms': instance.acceptTerms,
      'email': instance.email,
      'marketingOptIn': ?instance.marketingOptIn,
      'name': instance.name,
      'password': instance.password,
    };
