// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentEventDto _$PaymentEventDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'amountMinor',
      'at',
      'currency',
      'kind',
      'method',
      'note',
      'status',
    ],
    disallowNullValues: const [
      'amountMinor',
      'at',
      'currency',
      'kind',
      'method',
      'note',
      'receiptUrl',
      'reference',
      'status',
    ],
  );
  return PaymentEventDto(
    amountMinor: PaymentEventDto._read_amountMinor(json['amountMinor']),
    at: PaymentEventDto._read_at(json['at']),
    currency: json['currency'] as String,
    kind: json['kind'] as String,
    method: PaymentEventDto._read_method(json['method']),
    note: json['note'] as String,
    receiptUrl: json['receiptUrl'] as String?,
    reference: json['reference'] as String?,
    status: PaymentEventDto._read_status(json['status']),
    additionalProperties:
        PaymentEventDto._extras(json, 'additionalProperties') == null
        ? const {}
        : PaymentEventDto._readExtras(
            PaymentEventDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$PaymentEventDtoToJson(PaymentEventDto instance) =>
    <String, dynamic>{
      'amountMinor': ?PaymentEventDto._write_amountMinor(instance.amountMinor),
      'at': ?PaymentEventDto._write_at(instance.at),
      'currency': instance.currency,
      'kind': instance.kind,
      'method': ?PaymentEventDto._write_method(instance.method),
      'note': instance.note,
      'receiptUrl': ?instance.receiptUrl,
      'reference': ?instance.reference,
      'status': ?PaymentEventDto._write_status(instance.status),
    };
