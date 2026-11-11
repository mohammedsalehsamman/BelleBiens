// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_controller_readiness_response503_error_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthControllerReadinessResponse503ErrorValue
_$HealthControllerReadinessResponse503ErrorValueFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    requiredKeys: const ['status'],
    disallowNullValues: const ['responseTime', 'status'],
  );
  return HealthControllerReadinessResponse503ErrorValue(
    responseTime: json['responseTime'] as num?,
    status: HealthControllerReadinessResponse503ErrorValue._read_status(
      json['status'],
    ),
    additionalProperties:
        HealthControllerReadinessResponse503ErrorValue._extras(
              json,
              'additionalProperties',
            ) ==
            null
        ? const {}
        : HealthControllerReadinessResponse503ErrorValue._readExtras(
            HealthControllerReadinessResponse503ErrorValue._extras(
              json,
              'additionalProperties',
            ),
          ),
  );
}

Map<String, dynamic> _$HealthControllerReadinessResponse503ErrorValueToJson(
  HealthControllerReadinessResponse503ErrorValue instance,
) => <String, dynamic>{
  'responseTime': ?instance.responseTime,
  'status': ?HealthControllerReadinessResponse503ErrorValue._write_status(
    instance.status,
  ),
};
