// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_controller_readiness_response503.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthControllerReadinessResponse503
_$HealthControllerReadinessResponse503FromJson(Map<String, dynamic> json) {
  $checkKeys(json, disallowNullValues: const ['details', 'status']);
  return HealthControllerReadinessResponse503(
    details: (json['details'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(
        k,
        HealthControllerReadinessResponse503DetailsValue.fromJson(
          e as Map<String, dynamic>,
        ),
      ),
    ),
    error: (json['error'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(
        k,
        HealthControllerReadinessResponse503ErrorValue.fromJson(
          e as Map<String, dynamic>,
        ),
      ),
    ),
    info: (json['info'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(
        k,
        HealthControllerReadinessResponse503InfoValue.fromJson(
          e as Map<String, dynamic>,
        ),
      ),
    ),
    status: HealthControllerReadinessResponse503._read_status(json['status']),
    additionalProperties:
        HealthControllerReadinessResponse503._extras(
              json,
              'additionalProperties',
            ) ==
            null
        ? const {}
        : HealthControllerReadinessResponse503._readExtras(
            HealthControllerReadinessResponse503._extras(
              json,
              'additionalProperties',
            ),
          ),
  );
}

Map<String, dynamic> _$HealthControllerReadinessResponse503ToJson(
  HealthControllerReadinessResponse503 instance,
) => <String, dynamic>{
  'details': ?instance.details?.map((k, e) => MapEntry(k, e.toJson())),
  'error': ?instance.error?.map((k, e) => MapEntry(k, e.toJson())),
  'info': ?instance.info?.map((k, e) => MapEntry(k, e.toJson())),
  'status': ?HealthControllerReadinessResponse503._write_status(
    instance.status,
  ),
};
