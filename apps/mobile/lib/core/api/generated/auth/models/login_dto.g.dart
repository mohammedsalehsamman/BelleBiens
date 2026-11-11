// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginDto _$LoginDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['email', 'password'],
    disallowNullValues: const ['email', 'password'],
  );
  return LoginDto(
    email: json['email'] as String,
    password: json['password'] as String,
    additionalProperties: LoginDto._extras(json, 'additionalProperties') == null
        ? const {}
        : LoginDto._readExtras(LoginDto._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$LoginDtoToJson(LoginDto instance) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
};
