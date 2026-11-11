// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_reset_confirm_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordResetConfirmDto _$PasswordResetConfirmDtoFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    requiredKeys: const ['newPassword', 'token'],
    disallowNullValues: const ['newPassword', 'token'],
  );
  return PasswordResetConfirmDto(
    newPassword: json['newPassword'] as String,
    token: json['token'] as String,
    additionalProperties:
        PasswordResetConfirmDto._extras(json, 'additionalProperties') == null
        ? const {}
        : PasswordResetConfirmDto._readExtras(
            PasswordResetConfirmDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$PasswordResetConfirmDtoToJson(
  PasswordResetConfirmDto instance,
) => <String, dynamic>{
  'newPassword': instance.newPassword,
  'token': instance.token,
};
