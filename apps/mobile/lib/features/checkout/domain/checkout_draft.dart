import 'dart:math';

import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/features/cart/domain/cart_line.dart';
import 'package:flutter/foundation.dart';

/// The delivery address as the customer set it on the map (screen 22).
@immutable
class DraftAddress {
  const new({
    required this.latitude,
    required this.longitude,
    this.zone,
    this.label = '',
    this.landmark = '',
    this.building = '',
    this.floor = '',
    this.details = '',
    this.save = false,
  });

  factory fromSaved(AddressDto a) => DraftAddress(
    latitude: a.latitude.toDouble(),
    longitude: a.longitude.toDouble(),
    zone: a.zone,
    label: a.label,
    landmark: a.landmark,
    building: a.building,
    floor: a.floor,
    details: a.details,
  );

  final double latitude;
  final double longitude;

  /// Null: outside every zone.
  final ZoneDto? zone;
  final String label;
  final String landmark;
  final String building;
  final String floor;
  final String details;
  final bool save;

  /// "[الشارع والبناء والطابق]، قرب [معلم معروف]" (screen 21).
  String get line => [
    details,
    building,
    floor,
    landmark,
  ].where((p) => p.trim().isNotEmpty).join('، ');

  OrderAddressInputDto toInput() => OrderAddressInputDto(
    latitude: latitude,
    longitude: longitude,
    label: label.isEmpty ? null : label,
    area: zone?.name.ar,
    landmark: landmark.isEmpty ? null : landmark,
    building: building.isEmpty ? null : building,
    floor: floor.isEmpty ? null : floor,
    details: details.isEmpty ? null : details,
    save: save ? true : null,
  );
}

/// Screens 21 and 23 as the customer fills them in. Nothing here is priced:
/// the server prices the order when it is placed (NFR-SEC-06).
@immutable
class CheckoutDraft {
  const new({
    required this.idempotencyKey,
    this.fulfillment = Fulfillment.delivery,
    this.address,
    this.customerName = '',
    this.customerPhone = '',
    this.recipientIsMe = false,
    this.recipientName = '',
    this.recipientPhone = '',
    this.hideSender = false,
    this.date,
    this.slotStart,
    this.slotEnd,
    this.holdId,
    this.callBeforeArrival = false,
    this.notes = '',
    this.paymentMethod = PaymentMethod.cash,
    this.whatsappConfirm = false,
  });

  /// FR-CRT-10: one key per checkout; a retry after a lost answer reuses it.
  final String idempotencyKey;
  final Fulfillment fulfillment;
  final DraftAddress? address;
  final String customerName;
  final String customerPhone;
  final bool recipientIsMe;
  final String recipientName;
  final String recipientPhone;
  final bool hideSender;

  /// YYYY-MM-DD in Damascus.
  final String? date;
  final String? slotStart;
  final String? slotEnd;
  final String? holdId;
  final bool callBeforeArrival;
  final String notes;
  final PaymentMethod paymentMethod;
  final bool whatsappConfirm;

  bool get delivery => fulfillment == Fulfillment.delivery;

  /// The zone whose fee the invoice adds (null for pickup).
  String? get zoneSlug => delivery ? address?.zone?.slug : null;

  CheckoutDraft copyWith({
    String? idempotencyKey,
    Fulfillment? fulfillment,
    DraftAddress? Function()? address,
    String? customerName,
    String? customerPhone,
    bool? recipientIsMe,
    String? recipientName,
    String? recipientPhone,
    bool? hideSender,
    String? Function()? date,
    String? Function()? slotStart,
    String? Function()? slotEnd,
    String? Function()? holdId,
    bool? callBeforeArrival,
    String? notes,
    PaymentMethod? paymentMethod,
    bool? whatsappConfirm,
  }) => CheckoutDraft(
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    fulfillment: fulfillment ?? this.fulfillment,
    address: address == null ? this.address : address(),
    customerName: customerName ?? this.customerName,
    customerPhone: customerPhone ?? this.customerPhone,
    recipientIsMe: recipientIsMe ?? this.recipientIsMe,
    recipientName: recipientName ?? this.recipientName,
    recipientPhone: recipientPhone ?? this.recipientPhone,
    hideSender: hideSender ?? this.hideSender,
    date: date == null ? this.date : date(),
    slotStart: slotStart == null ? this.slotStart : slotStart(),
    slotEnd: slotEnd == null ? this.slotEnd : slotEnd(),
    holdId: holdId == null ? this.holdId : holdId(),
    callBeforeArrival: callBeforeArrival ?? this.callBeforeArrival,
    notes: notes ?? this.notes,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    whatsappConfirm: whatsappConfirm ?? this.whatsappConfirm,
  );

  /// The body of POST /v1/orders.
  CreateOrderDto toOrder(List<CartLine> lines, {String? coupon}) {
    final customer = PersonDto(
      name: customerName.trim(),
      phone: customerPhone.trim(),
    );
    return CreateOrderDto(
      lines: [for (final l in lines) CartLineInputDto.fromJson(l.toJson())],
      couponCode: coupon,
      fulfillment: fulfillment,
      customer: customer,
      recipient: recipientIsMe
          ? null
          : PersonDto(name: recipientName.trim(), phone: recipientPhone.trim()),
      hideSender: !recipientIsMe && hideSender ? true : null,
      address: delivery ? address?.toInput() : null,
      slot: SlotChoiceDto(date: date!, start: slotStart!),
      slotHoldId: delivery ? holdId : null,
      callBeforeArrival: delivery && callBeforeArrival ? true : null,
      whatsappConfirm: whatsappConfirm ? true : null,
      notes: notes.trim().isEmpty ? null : notes.trim(),
      paymentMethod: paymentMethod,
    );
  }
}

/// A random key for one checkout (32 hex characters).
String newIdempotencyKey([Random? random]) {
  final r = random ?? Random.secure();
  return [
    for (var i = 0; i < 16; i++)
      r.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ].join();
}
