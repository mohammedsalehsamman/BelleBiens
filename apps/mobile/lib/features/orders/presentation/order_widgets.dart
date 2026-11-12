import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:flutter/material.dart';

/// What a customer should read about an order now (screens 25-27): the
/// payment comes first while the shop has not confirmed it.
(String, BBBadgeTone) orderState(
  AppLocalizations l10n, {
  required OrderStatus status,
  required PaymentStatus paymentStatus,
  required PaymentMethod paymentMethod,
}) {
  if (status == OrderStatus.new2) {
    return switch (paymentStatus) {
      PaymentStatus.submitted => (
        l10n.confirmPendingPayment,
        BBBadgeTone.amber,
      ),
      PaymentStatus.failed => (l10n.statusPaymentProblem, BBBadgeTone.red),
      _ when paymentMethod != PaymentMethod.cash => (
        l10n.statusAwaitingPayment,
        BBBadgeTone.amber,
      ),
      _ => (l10n.statusAwaitingShop, BBBadgeTone.amber),
    };
  }
  return switch (status) {
    OrderStatus.confirmed => (l10n.statusConfirmed, BBBadgeTone.sage),
    OrderStatus.preparing => (l10n.statusPreparing, BBBadgeTone.blush),
    OrderStatus.ready => (l10n.statusReady, BBBadgeTone.blush),
    OrderStatus.outForDelivery => (l10n.statusOut, BBBadgeTone.blush),
    OrderStatus.delivered => (l10n.statusDelivered, BBBadgeTone.green),
    OrderStatus.pickedUp => (l10n.statusPickedUp, BBBadgeTone.green),
    _ => (l10n.statusCancelled, BBBadgeTone.gray),
  };
}

class OrderStateBadge extends StatelessWidget {
  const new({
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    super.key,
  });

  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final PaymentMethod paymentMethod;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = orderState(
      AppLocalizations.of(context),
      status: status,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
    );
    return BBBadge(label: label, tone: tone);
  }
}

String paymentStateText(AppLocalizations l10n, PaymentStatus status) =>
    switch (status) {
      PaymentStatus.pending => l10n.payStatePending,
      PaymentStatus.submitted => l10n.payStateSubmitted,
      PaymentStatus.paid => l10n.payStatePaid,
      PaymentStatus.failed => l10n.payStateFailed,
      PaymentStatus.refunded => l10n.payStateRefunded,
    };

/// Sham Cash still owed: the customer can pay (screen 24).
bool owesShamCash(OrderDto order) =>
    order.status == OrderStatus.new2 &&
    order.paymentMethod == PaymentMethod.shamcash &&
    order.paymentStatus == PaymentStatus.pending;
