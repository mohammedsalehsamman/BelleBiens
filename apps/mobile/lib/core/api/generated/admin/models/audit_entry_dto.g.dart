// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditEntryDto _$AuditEntryDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'action',
      'actorId',
      'actorRole',
      'after',
      'before',
      'createdAt',
      'entity',
      'entityId',
      'id',
    ],
    disallowNullValues: const [
      'action',
      'actorRole',
      'createdAt',
      'entity',
      'id',
    ],
  );
  return AuditEntryDto(
    action: json['action'] as String,
    actorId: json['actorId'] as String?,
    actorRole: AuditEntryDto._read_actorRole(json['actorRole']),
    after: json['after'] == null
        ? null
        : AuditEntryDtoAfter.fromJson(json['after'] as Map<String, dynamic>),
    before: json['before'] == null
        ? null
        : AuditEntryDtoBefore.fromJson(json['before'] as Map<String, dynamic>),
    createdAt: AuditEntryDto._read_createdAt(json['createdAt']),
    entity: json['entity'] as String,
    entityId: json['entityId'] as String?,
    id: json['id'] as String,
    additionalProperties:
        AuditEntryDto._extras(json, 'additionalProperties') == null
        ? const {}
        : AuditEntryDto._readExtras(
            AuditEntryDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$AuditEntryDtoToJson(AuditEntryDto instance) =>
    <String, dynamic>{
      'action': instance.action,
      'actorId': instance.actorId,
      'actorRole': ?AuditEntryDto._write_actorRole(instance.actorRole),
      'after': instance.after?.toJson(),
      'before': instance.before?.toJson(),
      'createdAt': ?AuditEntryDto._write_createdAt(instance.createdAt),
      'entity': instance.entity,
      'entityId': instance.entityId,
      'id': instance.id,
    };
