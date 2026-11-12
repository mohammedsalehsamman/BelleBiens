// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_proof_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentProofDto _$PaymentProofDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    disallowNullValues: const ['phone', 'receiptUrl', 'reference'],
  );
  return PaymentProofDto(
    phone: json['phone'] as String?,
    receiptUrl: json['receiptUrl'] as String?,
    reference: json['reference'] as String?,
    additionalProperties:
        PaymentProofDto._extras(json, 'additionalProperties') == null
        ? const {}
        : PaymentProofDto._readExtras(
            PaymentProofDto._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$PaymentProofDtoToJson(PaymentProofDto instance) =>
    <String, dynamic>{
      'phone': ?instance.phone,
      'receiptUrl': ?instance.receiptUrl,
      'reference': ?instance.reference,
    };
