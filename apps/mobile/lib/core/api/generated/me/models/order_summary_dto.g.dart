// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSummaryDto _$OrderSummaryDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'createdAt',
      'fulfillment',
      'itemCount',
      'number',
      'paymentMethod',
      'paymentStatus',
      'slot',
      'status',
      'title',
      'totalMinor',
    ],
    disallowNullValues: const [
      'createdAt',
      'fulfillment',
      'imageUrl',
      'itemCount',
      'number',
      'paymentMethod',
      'paymentStatus',
      'slot',
      'status',
      'title',
      'totalMinor',
    ],
  );
  return OrderSummaryDto(
    createdAt: OrderSummaryDto._read_createdAt(json['createdAt']),
    fulfillment: OrderSummaryDto._read_fulfillment(json['fulfillment']),
    imageUrl: json['imageUrl'] as String?,
    itemCount: OrderSummaryDto._read_itemCount(json['itemCount']),
    number: json['number'] as String,
    paymentMethod: OrderSummaryDto._read_paymentMethod(json['paymentMethod']),
    paymentStatus: OrderSummaryDto._read_paymentStatus(json['paymentStatus']),
    slot: OrderSlotDto.fromJson(json['slot'] as Map<String, dynamic>),
    status: OrderSummaryDto._read_status(json['status']),
    title: LocalizedTextDto.fromJson(json['title'] as Map<String, dynamic>),
    totalMinor: OrderSummaryDto._read_totalMinor(json['totalMinor']),
    additionalProperties:
        OrderSummaryDto._extras(json, 'additionalProperties') == null
        ? const {}
        : OrderSummaryDto._readExtras(
            OrderSummaryDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$OrderSummaryDtoToJson(OrderSummaryDto instance) =>
    <String, dynamic>{
      'createdAt': ?OrderSummaryDto._write_createdAt(instance.createdAt),
      'fulfillment': ?OrderSummaryDto._write_fulfillment(instance.fulfillment),
      'imageUrl': ?instance.imageUrl,
      'itemCount': ?OrderSummaryDto._write_itemCount(instance.itemCount),
      'number': instance.number,
      'paymentMethod': ?OrderSummaryDto._write_paymentMethod(
        instance.paymentMethod,
      ),
      'paymentStatus': ?OrderSummaryDto._write_paymentStatus(
        instance.paymentStatus,
      ),
      'slot': instance.slot.toJson(),
      'status': ?OrderSummaryDto._write_status(instance.status),
      'title': instance.title.toJson(),
      'totalMinor': ?OrderSummaryDto._write_totalMinor(instance.totalMinor),
    };
