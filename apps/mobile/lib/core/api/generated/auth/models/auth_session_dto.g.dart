// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSessionDto _$AuthSessionDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'accessToken',
      'accessTokenExpiresIn',
      'isNewUser',
      'refreshToken',
      'refreshTokenExpiresAt',
      'user',
    ],
    disallowNullValues: const [
      'accessToken',
      'accessTokenExpiresIn',
      'isNewUser',
      'refreshToken',
      'refreshTokenExpiresAt',
      'user',
    ],
  );
  return AuthSessionDto(
    accessToken: json['accessToken'] as String,
    accessTokenExpiresIn: json['accessTokenExpiresIn'] as num,
    isNewUser: json['isNewUser'] as bool,
    refreshToken: json['refreshToken'] as String,
    refreshTokenExpiresAt: AuthSessionDto._read_refreshTokenExpiresAt(
      json['refreshTokenExpiresAt'],
    ),
    user: MeDto.fromJson(json['user'] as Map<String, dynamic>),
    additionalProperties:
        AuthSessionDto._extras(json, 'additionalProperties') == null
        ? const {}
        : AuthSessionDto._readExtras(
            AuthSessionDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$AuthSessionDtoToJson(AuthSessionDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'accessTokenExpiresIn': instance.accessTokenExpiresIn,
      'isNewUser': instance.isNewUser,
      'refreshToken': instance.refreshToken,
      'refreshTokenExpiresAt': ?AuthSessionDto._write_refreshTokenExpiresAt(
        instance.refreshTokenExpiresAt,
      ),
      'user': instance.user.toJson(),
    };
