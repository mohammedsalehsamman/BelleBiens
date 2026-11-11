// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_controller_readiness_response200_details_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthControllerReadinessResponse200DetailsValue
_$HealthControllerReadinessResponse200DetailsValueFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    requiredKeys: const ['status'],
    disallowNullValues: const ['responseTime', 'status'],
  );
  return HealthControllerReadinessResponse200DetailsValue(
    responseTime: json['responseTime'] as num?,
    status: HealthControllerReadinessResponse200DetailsValue._read_status(
      json['status'],
    ),
    additionalProperties:
        HealthControllerReadinessResponse200DetailsValue._extras(
              json,
              'additionalProperties',
            ) ==
            null
        ? const {}
        : HealthControllerReadinessResponse200DetailsValue._readExtras(
            HealthControllerReadinessResponse200DetailsValue._extras(
              json,
              'additionalProperties',
            ),
          ),
  );
}

Map<String, dynamic> _$HealthControllerReadinessResponse200DetailsValueToJson(
  HealthControllerReadinessResponse200DetailsValue instance,
) => <String, dynamic>{
  'responseTime': ?instance.responseTime,
  'status': ?HealthControllerReadinessResponse200DetailsValue._write_status(
    instance.status,
  ),
};
