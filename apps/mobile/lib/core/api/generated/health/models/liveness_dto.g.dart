// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liveness_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LivenessDto _$LivenessDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['status', 'time'],
    disallowNullValues: const ['status', 'time'],
  );
  return LivenessDto(
    status: json['status'] as String,
    time: json['time'] as String,
    additionalProperties:
        LivenessDto._extras(json, 'additionalProperties') == null
        ? const {}
        : LivenessDto._readExtras(
            LivenessDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$LivenessDtoToJson(LivenessDto instance) =>
    <String, dynamic>{'status': instance.status, 'time': instance.time};
