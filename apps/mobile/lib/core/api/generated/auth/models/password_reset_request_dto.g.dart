// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_reset_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordResetRequestDto _$PasswordResetRequestDtoFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    requiredKeys: const ['email'],
    disallowNullValues: const ['email'],
  );
  return PasswordResetRequestDto(
    email: json['email'] as String,
    additionalProperties:
        PasswordResetRequestDto._extras(json, 'additionalProperties') == null
        ? const {}
        : PasswordResetRequestDto._readExtras(
            PasswordResetRequestDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$PasswordResetRequestDtoToJson(
  PasswordResetRequestDto instance,
) => <String, dynamic>{'email': instance.email};
