// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_controller_readiness_response503_details_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthControllerReadinessResponse503DetailsValue
_$HealthControllerReadinessResponse503DetailsValueFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    requiredKeys: const ['status'],
    disallowNullValues: const ['responseTime', 'status'],
  );
  return HealthControllerReadinessResponse503DetailsValue(
    responseTime: json['responseTime'] as num?,
    status: HealthControllerReadinessResponse503DetailsValue._read_status(
      json['status'],
    ),
    additionalProperties:
        HealthControllerReadinessResponse503DetailsValue._extras(
              json,
              'additionalProperties',
            ) ==
            null
        ? const {}
        : HealthControllerReadinessResponse503DetailsValue._readExtras(
            HealthControllerReadinessResponse503DetailsValue._extras(
              json,
              'additionalProperties',
            ),
          ),
  );
}

Map<String, dynamic> _$HealthControllerReadinessResponse503DetailsValueToJson(
  HealthControllerReadinessResponse503DetailsValue instance,
) => <String, dynamic>{
  'responseTime': ?instance.responseTime,
  'status': ?HealthControllerReadinessResponse503DetailsValue._write_status(
    instance.status,
  ),
};
