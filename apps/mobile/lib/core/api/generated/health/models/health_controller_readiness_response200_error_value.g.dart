// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_controller_readiness_response200_error_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthControllerReadinessResponse200ErrorValue
_$HealthControllerReadinessResponse200ErrorValueFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    requiredKeys: const ['status'],
    disallowNullValues: const ['responseTime', 'status'],
  );
  return HealthControllerReadinessResponse200ErrorValue(
    responseTime: json['responseTime'] as num?,
    status: HealthControllerReadinessResponse200ErrorValue._read_status(
      json['status'],
    ),
    additionalProperties:
        HealthControllerReadinessResponse200ErrorValue._extras(
              json,
              'additionalProperties',
            ) ==
            null
        ? const {}
        : HealthControllerReadinessResponse200ErrorValue._readExtras(
            HealthControllerReadinessResponse200ErrorValue._extras(
              json,
              'additionalProperties',
            ),
          ),
  );
}

Map<String, dynamic> _$HealthControllerReadinessResponse200ErrorValueToJson(
  HealthControllerReadinessResponse200ErrorValue instance,
) => <String, dynamic>{
  'responseTime': ?instance.responseTime,
  'status': ?HealthControllerReadinessResponse200ErrorValue._write_status(
    instance.status,
  ),
};
