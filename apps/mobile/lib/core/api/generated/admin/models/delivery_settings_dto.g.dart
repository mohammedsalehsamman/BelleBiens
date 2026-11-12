// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_settings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliverySettingsDto _$DeliverySettingsDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'closedDays',
      'slotHoldMinutes',
      'slots',
      'windowDays',
    ],
    disallowNullValues: const [
      'closedDays',
      'slotHoldMinutes',
      'slots',
      'windowDays',
    ],
  );
  return DeliverySettingsDto(
    closedDays: (json['closedDays'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    slotHoldMinutes: DeliverySettingsDto._read_slotHoldMinutes(
      json['slotHoldMinutes'],
    ),
    slots: (json['slots'] as List<dynamic>)
        .map((e) => SlotTemplateDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    windowDays: DeliverySettingsDto._read_windowDays(json['windowDays']),
    additionalProperties:
        DeliverySettingsDto._extras(json, 'additionalProperties') == null
        ? const {}
        : DeliverySettingsDto._readExtras(
            DeliverySettingsDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$DeliverySettingsDtoToJson(
  DeliverySettingsDto instance,
) => <String, dynamic>{
  'closedDays': instance.closedDays,
  'slotHoldMinutes': ?DeliverySettingsDto._write_slotHoldMinutes(
    instance.slotHoldMinutes,
  ),
  'slots': instance.slots.map((e) => e.toJson()).toList(),
  'windowDays': ?DeliverySettingsDto._write_windowDays(instance.windowDays),
};
