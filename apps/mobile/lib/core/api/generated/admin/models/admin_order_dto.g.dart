// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminOrderDto _$AdminOrderDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'callBeforeArrival',
      'canCancel',
      'createdAt',
      'customer',
      'fulfillment',
      'hideSender',
      'history',
      'lines',
      'next',
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
      'customer',
      'fulfillment',
      'hideSender',
      'history',
      'lines',
      'next',
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
  return AdminOrderDto(
    address: json['address'] == null
        ? null
        : OrderAddressDto.fromJson(json['address'] as Map<String, dynamic>),
    callBeforeArrival: json['callBeforeArrival'] as bool,
    canCancel: json['canCancel'] as bool,
    couponCode: json['couponCode'] as String?,
    createdAt: AdminOrderDto._read_createdAt(json['createdAt']),
    customer: RecipientDto.fromJson(json['customer'] as Map<String, dynamic>),
    fulfillment: AdminOrderDto._read_fulfillment(json['fulfillment']),
    hideSender: json['hideSender'] as bool,
    history: (json['history'] as List<dynamic>)
        .map((e) => StatusEventDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    lines: (json['lines'] as List<dynamic>)
        .map((e) => OrderLineDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    next: AdminOrderDto._read_next(json['next']),
    notes: json['notes'] as String,
    number: json['number'] as String,
    paymentMethod: AdminOrderDto._read_paymentMethod(json['paymentMethod']),
    paymentStatus: AdminOrderDto._read_paymentStatus(json['paymentStatus']),
    recipient: RecipientDto.fromJson(json['recipient'] as Map<String, dynamic>),
    slot: OrderSlotDto.fromJson(json['slot'] as Map<String, dynamic>),
    status: AdminOrderDto._read_status(json['status']),
    syp: MoneyBreakdownDto.fromJson(json['syp'] as Map<String, dynamic>),
    totalUsdCents: AdminOrderDto._read_totalUsdCents(json['totalUsdCents']),
    usdRate: json['usdRate'] as String,
    whatsappConfirm: json['whatsappConfirm'] as bool,
    zone: json['zone'] == null
        ? null
        : ZoneDto.fromJson(json['zone'] as Map<String, dynamic>),
    additionalProperties:
        AdminOrderDto._extras(json, 'additionalProperties') == null
        ? const {}
        : AdminOrderDto._readExtras(
            AdminOrderDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$AdminOrderDtoToJson(
  AdminOrderDto instance,
) => <String, dynamic>{
  'address': ?instance.address?.toJson(),
  'callBeforeArrival': instance.callBeforeArrival,
  'canCancel': instance.canCancel,
  'couponCode': ?instance.couponCode,
  'createdAt': ?AdminOrderDto._write_createdAt(instance.createdAt),
  'customer': instance.customer.toJson(),
  'fulfillment': ?AdminOrderDto._write_fulfillment(instance.fulfillment),
  'hideSender': instance.hideSender,
  'history': instance.history.map((e) => e.toJson()).toList(),
  'lines': instance.lines.map((e) => e.toJson()).toList(),
  'next': ?AdminOrderDto._write_next(instance.next),
  'notes': instance.notes,
  'number': instance.number,
  'paymentMethod': ?AdminOrderDto._write_paymentMethod(instance.paymentMethod),
  'paymentStatus': ?AdminOrderDto._write_paymentStatus(instance.paymentStatus),
  'recipient': instance.recipient.toJson(),
  'slot': instance.slot.toJson(),
  'status': ?AdminOrderDto._write_status(instance.status),
  'syp': instance.syp.toJson(),
  'totalUsdCents': ?AdminOrderDto._write_totalUsdCents(instance.totalUsdCents),
  'usdRate': instance.usdRate,
  'whatsappConfirm': instance.whatsappConfirm,
  'zone': ?instance.zone?.toJson(),
};
