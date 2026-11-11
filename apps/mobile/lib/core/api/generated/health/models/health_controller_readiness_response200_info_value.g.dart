// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_controller_readiness_response200_info_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthControllerReadinessResponse200InfoValue
_$HealthControllerReadinessResponse200InfoValueFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    requiredKeys: const ['status'],
    disallowNullValues: const ['responseTime', 'status'],
  );
  return HealthControllerReadinessResponse200InfoValue(
    responseTime: json['responseTime'] as num?,
    status: HealthControllerReadinessResponse200InfoValue._read_status(
      json['status'],
    ),
    additionalProperties:
        HealthControllerReadinessResponse200InfoValue._extras(
              json,
              'additionalProperties',
            ) ==
            null
        ? const {}
        : HealthControllerReadinessResponse200InfoValue._readExtras(
            HealthControllerReadinessResponse200InfoValue._extras(
              json,
              'additionalProperties',
            ),
          ),
  );
}

Map<String, dynamic> _$HealthControllerReadinessResponse200InfoValueToJson(
  HealthControllerReadinessResponse200InfoValue instance,
) => <String, dynamic>{
  'responseTime': ?instance.responseTime,
  'status': ?HealthControllerReadinessResponse200InfoValue._write_status(
    instance.status,
  ),
};
