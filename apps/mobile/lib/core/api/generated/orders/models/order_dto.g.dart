// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDto _$OrderDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'callBeforeArrival',
      'canCancel',
      'createdAt',
      'fulfillment',
      'hideSender',
      'history',
      'lines',
      'notes',
      'number',
      'paymentMethod',
      'paymentStatus',
      'recipient',
      'slot',
      'status',
      'syp',
      'totalUsdCents',
      'usdRate',
      'whatsappConfirm',
    ],
    disallowNullValues: const [
      'address',
      'callBeforeArrival',
      'canCancel',
      'couponCode',
      'createdAt',
      'fulfillment',
      'hideSender',
      'history',
      'lines',
      'notes',
      'number',
      'paymentMethod',
      'paymentStatus',
      'recipient',
      'slot',
      'status',
      'syp',
      'totalUsdCents',
      'usdRate',
      'whatsappConfirm',
      'zone',
    ],
  );
  return OrderDto(
    address: json['address'] == null
        ? null
        : OrderAddressDto.fromJson(json['address'] as Map<String, dynamic>),
    callBeforeArrival: json['callBeforeArrival'] as bool,
    canCancel: json['canCancel'] as bool,
    couponCode: json['couponCode'] as String?,
    createdAt: OrderDto._read_createdAt(json['createdAt']),
    fulfillment: OrderDto._read_fulfillment(json['fulfillment']),
    hideSender: json['hideSender'] as bool,
    history: (json['history'] as List<dynamic>)
        .map((e) => StatusEventDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    lines: (json['lines'] as List<dynamic>)
        .map((e) => OrderLineDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    notes: json['notes'] as String,
    number: json['number'] as String,
    paymentMethod: OrderDto._read_paymentMethod(json['paymentMethod']),
    paymentStatus: OrderDto._read_paymentStatus(json['paymentStatus']),
    recipient: RecipientDto.fromJson(json['recipient'] as Map<String, dynamic>),
    slot: OrderSlotDto.fromJson(json['slot'] as Map<String, dynamic>),
    status: OrderDto._read_status(json['status']),
    syp: MoneyBreakdownDto.fromJson(json['syp'] as Map<String, dynamic>),
    totalUsdCents: OrderDto._read_totalUsdCents(json['totalUsdCents']),
    usdRate: json['usdRate'] as String,
    whatsappConfirm: json['whatsappConfirm'] as bool,
    zone: json['zone'] == null
        ? null
        : ZoneDto.fromJson(json['zone'] as Map<String, dynamic>),
    additionalProperties: OrderDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OrderDto._readExtras(OrderDto._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$OrderDtoToJson(OrderDto instance) => <String, dynamic>{
  'address': ?instance.address?.toJson(),
  'callBeforeArrival': instance.callBeforeArrival,
  'canCancel': instance.canCancel,
  'couponCode': ?instance.couponCode,
  'createdAt': ?OrderDto._write_createdAt(instance.createdAt),
  'fulfillment': ?OrderDto._write_fulfillment(instance.fulfillment),
  'hideSender': instance.hideSender,
  'history': instance.history.map((e) => e.toJson()).toList(),
  'lines': instance.lines.map((e) => e.toJson()).toList(),
  'notes': instance.notes,
  'number': instance.number,
  'paymentMethod': ?OrderDto._write_paymentMethod(instance.paymentMethod),
  'paymentStatus': ?OrderDto._write_paymentStatus(instance.paymentStatus),
  'recipient': instance.recipient.toJson(),
  'slot': instance.slot.toJson(),
  'status': ?OrderDto._write_status(instance.status),
  'syp': instance.syp.toJson(),
  'totalUsdCents': ?OrderDto._write_totalUsdCents(instance.totalUsdCents),
  'usdRate': instance.usdRate,
  'whatsappConfirm': instance.whatsappConfirm,
  'zone': ?instance.zone?.toJson(),
};
