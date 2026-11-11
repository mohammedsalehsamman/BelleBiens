// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_controller_readiness_response503_info_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthControllerReadinessResponse503InfoValue
_$HealthControllerReadinessResponse503InfoValueFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    requiredKeys: const ['status'],
    disallowNullValues: const ['responseTime', 'status'],
  );
  return HealthControllerReadinessResponse503InfoValue(
    responseTime: json['responseTime'] as num?,
    status: HealthControllerReadinessResponse503InfoValue._read_status(
      json['status'],
    ),
    additionalProperties:
        HealthControllerReadinessResponse503InfoValue._extras(
              json,
              'additionalProperties',
            ) ==
            null
        ? const {}
        : HealthControllerReadinessResponse503InfoValue._readExtras(
            HealthControllerReadinessResponse503InfoValue._extras(
              json,
              'additionalProperties',
            ),
          ),
  );
}

Map<String, dynamic> _$HealthControllerReadinessResponse503InfoValueToJson(
  HealthControllerReadinessResponse503InfoValue instance,
) => <String, dynamic>{
  'responseTime': ?instance.responseTime,
  'status': ?HealthControllerReadinessResponse503InfoValue._write_status(
    instance.status,
  ),
};
