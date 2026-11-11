// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_role_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeRoleDto _$ChangeRoleDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['role'],
    disallowNullValues: const ['role'],
  );
  return ChangeRoleDto(
    role: ChangeRoleDto._read_role(json['role']),
    additionalProperties:
        ChangeRoleDto._extras(json, 'additionalProperties') == null
        ? const {}
        : ChangeRoleDto._readExtras(
            ChangeRoleDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$ChangeRoleDtoToJson(ChangeRoleDto instance) =>
    <String, dynamic>{'role': ?ChangeRoleDto._write_role(instance.role)};
