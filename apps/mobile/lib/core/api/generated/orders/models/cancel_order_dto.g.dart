// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CancelOrderDto _$CancelOrderDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(json, disallowNullValues: const ['phone', 'reason']);
  return CancelOrderDto(
    phone: json['phone'] as String?,
    reason: json['reason'] as String?,
    additionalProperties:
        CancelOrderDto._extras(json, 'additionalProperties') == null
        ? const {}
        : CancelOrderDto._readExtras(
            CancelOrderDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$CancelOrderDtoToJson(CancelOrderDto instance) =>
    <String, dynamic>{'phone': ?instance.phone, 'reason': ?instance.reason};
