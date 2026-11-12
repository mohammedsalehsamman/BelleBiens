// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderDto _$CreateOrderDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'customer',
      'fulfillment',
      'lines',
      'paymentMethod',
      'slot',
    ],
    disallowNullValues: const [
      'address',
      'callBeforeArrival',
      'couponCode',
      'customer',
      'fulfillment',
      'hideSender',
      'lines',
      'notes',
      'paymentMethod',
      'recipient',
      'slot',
      'slotHoldId',
      'whatsappConfirm',
    ],
  );
  return CreateOrderDto(
    address: json['address'] == null
        ? null
        : OrderAddressInputDto.fromJson(
            json['address'] as Map<String, dynamic>,
          ),
    callBeforeArrival: json['callBeforeArrival'] as bool?,
    couponCode: json['couponCode'] as String?,
    customer: PersonDto.fromJson(json['customer'] as Map<String, dynamic>),
    fulfillment: CreateOrderDto._read_fulfillment(json['fulfillment']),
    hideSender: json['hideSender'] as bool?,
    lines: (json['lines'] as List<dynamic>)
        .map((e) => CartLineInputDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    notes: json['notes'] as String?,
    paymentMethod: CreateOrderDto._read_paymentMethod(json['paymentMethod']),
    recipient: json['recipient'] == null
        ? null
        : PersonDto.fromJson(json['recipient'] as Map<String, dynamic>),
    slot: SlotChoiceDto.fromJson(json['slot'] as Map<String, dynamic>),
    slotHoldId: json['slotHoldId'] as String?,
    whatsappConfirm: json['whatsappConfirm'] as bool?,
    additionalProperties:
        CreateOrderDto._extras(json, 'additionalProperties') == null
        ? const {}
        : CreateOrderDto._readExtras(
            CreateOrderDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$CreateOrderDtoToJson(
  CreateOrderDto instance,
) => <String, dynamic>{
  'address': ?instance.address?.toJson(),
  'callBeforeArrival': ?instance.callBeforeArrival,
  'couponCode': ?instance.couponCode,
  'customer': instance.customer.toJson(),
  'fulfillment': ?CreateOrderDto._write_fulfillment(instance.fulfillment),
  'hideSender': ?instance.hideSender,
  'lines': instance.lines.map((e) => e.toJson()).toList(),
  'notes': ?instance.notes,
  'paymentMethod': ?CreateOrderDto._write_paymentMethod(instance.paymentMethod),
  'recipient': ?instance.recipient?.toJson(),
  'slot': instance.slot.toJson(),
  'slotHoldId': ?instance.slotHoldId,
  'whatsappConfirm': ?instance.whatsappConfirm,
};
