// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_controller_readiness_response200.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthControllerReadinessResponse200
_$HealthControllerReadinessResponse200FromJson(Map<String, dynamic> json) {
  $checkKeys(json, disallowNullValues: const ['details', 'status']);
  return HealthControllerReadinessResponse200(
    details: (json['details'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(
        k,
        HealthControllerReadinessResponse200DetailsValue.fromJson(
          e as Map<String, dynamic>,
        ),
      ),
    ),
    error: (json['error'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(
        k,
        HealthControllerReadinessResponse200ErrorValue.fromJson(
          e as Map<String, dynamic>,
        ),
      ),
    ),
    info: (json['info'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(
        k,
        HealthControllerReadinessResponse200InfoValue.fromJson(
          e as Map<String, dynamic>,
        ),
      ),
    ),
    status: HealthControllerReadinessResponse200._read_status(json['status']),
    additionalProperties:
        HealthControllerReadinessResponse200._extras(
              json,
              'additionalProperties',
            ) ==
            null
        ? const {}
        : HealthControllerReadinessResponse200._readExtras(
            HealthControllerReadinessResponse200._extras(
              json,
              'additionalProperties',
            ),
          ),
  );
}

Map<String, dynamic> _$HealthControllerReadinessResponse200ToJson(
  HealthControllerReadinessResponse200 instance,
) => <String, dynamic>{
  'details': ?instance.details?.map((k, e) => MapEntry(k, e.toJson())),
  'error': ?instance.error?.map((k, e) => MapEntry(k, e.toJson())),
  'info': ?instance.info?.map((k, e) => MapEntry(k, e.toJson())),
  'status': ?HealthControllerReadinessResponse200._write_status(
    instance.status,
  ),
};
