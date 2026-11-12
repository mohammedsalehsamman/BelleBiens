import 'dart:async';

import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/launch/external_links.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/time/date_text.dart';
import 'package:belle_biens/core/time/shop_time.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:belle_biens/features/checkout/presentation/checkout_widgets.dart';
import 'package:belle_biens/features/checkout/presentation/order_confirmed_screen.dart';
import 'package:belle_biens/features/orders/application/orders_providers.dart';
import 'package:belle_biens/features/orders/presentation/order_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen 27: where the order is, what is in it, and what the customer can
/// still do (FR-ORD-04/05). Screen 38's payment problem shows at the top.
class OrderTrackScreen extends ConsumerStatefulWidget {
  const new({required this.number, super.key});

  final String number;

  @override
  ConsumerState<OrderTrackScreen> createState() => _OrderTrackScreenState();
}

class _OrderTrackScreenState extends ConsumerState<OrderTrackScreen> {
  Timer? _refresh;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refresh = Timer.periodic(
      orderRefreshEvery,
      (_) => ref.invalidate(orderProvider(widget.number)),
    );
  }

  @override
  void dispose() {
    _refresh?.cancel();
    super.dispose();
  }

  Future<void> _cancel(OrderDto order) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.trackCancelAsk(order.number)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.trackCancelNo),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.trackCancelYes),
          ),
        ],
      ),
    );
    if (sure != true) return;
    setState(() => _busy = true);
    try {
      await ref.read(orderActionsProvider).cancel(order.number);
      messenger.showSnackBar(SnackBar(content: Text(l10n.trackCancelled)));
    } on Object catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l10n, error))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final order = ref.watch(orderProvider(widget.number));
    return Scaffold(
      appBar: BBTopBar(
        title: l10n.orderTitle(widget.number),
        onBack: () =>
            context.canPop() ? context.pop() : context.go(Routes.orders),
      ),
      body: switch (order) {
        AsyncValue(:final value?) => RefreshIndicator(
          onRefresh: () => ref.refresh(orderProvider(widget.number).future),
          child: _Body(
            order: value,
            busy: _busy,
            onCancel: () => _cancel(value),
          ),
        ),
        AsyncError(:final error) => ErrorRetry(
          error: error,
          onRetry: () => ref.invalidate(orderProvider(widget.number)),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Body extends ConsumerWidget {
  const new({required this.order, required this.busy, required this.onCancel});

  final OrderDto order;
  final bool busy;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final money = ref.watch(moneyFormatProvider);
    final whatsapp = ref.watch(branchProvider).value?.data.whatsapp;
    final delivery = order.fulfillment == Fulfillment.delivery;
    final (state, tone) = orderState(
      l10n,
      status: order.status,
      paymentStatus: order.paymentStatus,
      paymentMethod: order.paymentMethod,
    );
    final address = order.address;

    return ListView(
      padding: const EdgeInsets.all(BBSpacing.page),
      children: [
        if (order.paymentStatus == PaymentStatus.failed &&
            order.status == OrderStatus.new2) ...[
          PaymentProblemCard(order: order),
          const SizedBox(height: BBSpacing.section),
        ],
        BBCard(
          color: BBColors.surfaceLow,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.trackCurrent, style: BBText.xs.muted),
              const SizedBox(height: BBSpacing.xs),
              BBBadge(label: state, tone: tone),
              const SizedBox(height: BBSpacing.sm),
              Text(_explain(l10n, order), style: BBText.small),
              if (owesShamCash(order)) ...[
                const SizedBox(height: BBSpacing.gutter),
                BBButton(
                  label: l10n.trackPayNow,
                  expand: true,
                  onPressed: () => context.push(Routes.orderPay(order.number)),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: BBSpacing.section),
        _Timeline(order: order),
        const SizedBox(height: BBSpacing.section),
        CheckoutSection(
          title: slotWhenText(
            l10n,
            locale,
            date: order.slot.date,
            inDays: daysBetween(
              shopDateOf(ref.watch(clockProvider)()),
              order.slot.date,
            ),
            start: order.slot.start,
            end: order.slot.end,
          ),
          child: BBCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  delivery ? l10n.trackDelivery : l10n.trackPickup,
                  style: BBText.xs.muted,
                ),
                Text(
                  [
                    if (delivery && address != null)
                      addressTitle(context, address.label, order.zone)
                    else
                      l10n.paymentPickupWhere,
                    if (delivery && order.callBeforeArrival)
                      l10n.trackCallBefore,
                  ].join(' · '),
                  style: BBText.small.bold,
                ),
                const SizedBox(height: BBSpacing.xs),
                Text(
                  order.hideSender
                      ? l10n.paymentRecipientHidden(order.recipient.name)
                      : l10n.paymentRecipient(order.recipient.name),
                  style: BBText.small,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: BBSpacing.section),
        CheckoutSection(
          title: l10n.trackContents,
          child: BBCard(
            child: Column(
              children: [
                for (final line in order.lines) ...[
                  BBKvRow(
                    label: line.qty > 1
                        ? '${line.title.of(context)} × ${line.qty}'
                        : line.title.of(context),
                    value: money.count(line.totalMinor ~/ 100),
                  ),
                  const SizedBox(height: BBSpacing.xs),
                ],
                if (order.syp.deliveryFeeMinor > 0) ...[
                  BBKvRow(
                    label: l10n.cartDelivery,
                    value: money.count(order.syp.deliveryFeeMinor ~/ 100),
                    mutedLabel: true,
                  ),
                  const SizedBox(height: BBSpacing.xs),
                ],
                if (order.syp.discountMinor > 0) ...[
                  BBKvRow(
                    label: l10n.cartDiscount,
                    value: money.change(-order.syp.discountMinor),
                    mutedLabel: true,
                  ),
                  const SizedBox(height: BBSpacing.xs),
                ],
                const Divider(),
                BBKvRow(
                  label: l10n.paymentTotal,
                  value: money.syp(order.syp.totalMinor),
                  total: true,
                ),
                const SizedBox(height: BBSpacing.sm),
                BBKvRow(
                  label: l10n.trackPayment,
                  value: l10n.payMethodState(
                    paymentMethodName(l10n, order.paymentMethod),
                    paymentStateText(l10n, order.paymentStatus),
                  ),
                  mutedLabel: true,
                  longValue: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: BBSpacing.section),
        BBButton(
          label: l10n.confirmWhatsapp,
          leading: BBIcons.whatsapp,
          variant: BBButtonVariant.whatsapp,
          expand: true,
          onPressed: whatsapp == null
              ? null
              : () => ref
                    .read(externalLinksProvider)
                    .open(
                      ExternalLinks.whatsapp(
                        whatsapp,
                        text: orderWhatsappText(
                          l10n,
                          order,
                          money,
                          locale: locale,
                        ),
                      ),
                    ),
        ),
        if (order.canCancel) ...[
          const SizedBox(height: BBSpacing.sm),
          BBButton(
            label: l10n.trackCancel,
            variant: BBButtonVariant.quiet,
            expand: true,
            loading: busy,
            onPressed: onCancel,
          ),
          Text(
            l10n.trackCancelHint,
            style: BBText.xs.muted,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: BBSpacing.lg),
      ],
    );
  }
}

String _explain(AppLocalizations l10n, OrderDto o) {
  final pickup = o.fulfillment == Fulfillment.pickup;
  return switch (o.status) {
    OrderStatus.new2 => switch (o.paymentStatus) {
      PaymentStatus.submitted => l10n.trackExplainSubmitted,
      PaymentStatus.pending when o.paymentMethod != PaymentMethod.cash =>
        l10n.trackExplainUnpaid,
      _ => l10n.trackExplainNew,
    },
    OrderStatus.confirmed => l10n.trackExplainConfirmed,
    OrderStatus.preparing => l10n.trackExplainPreparing,
    OrderStatus.ready =>
      pickup ? l10n.trackExplainReadyPickup : l10n.trackExplainReady,
    OrderStatus.outForDelivery => l10n.trackExplainOut,
    OrderStatus.delivered || OrderStatus.pickedUp => l10n.trackExplainDone,
    OrderStatus.cancelled => l10n.trackExplainCancelled,
  };
}

/// The steps of screen 27, the ones passed with their time.
class _Timeline extends StatelessWidget {
  const new({required this.order});

  final OrderDto order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final pickup = order.fulfillment == Fulfillment.pickup;
    final steps = <(OrderStatus, String, String?)>[
      (OrderStatus.new2, l10n.statusNew, null),
      (
        OrderStatus.confirmed,
        l10n.statusConfirmed,
        order.paymentMethod == PaymentMethod.cash
            ? null
            : l10n.trackAfterPayment,
      ),
      (OrderStatus.preparing, l10n.statusPreparing, null),
      (OrderStatus.ready, l10n.statusReady, null),
      if (!pickup) (OrderStatus.outForDelivery, l10n.statusOut, null),
      if (pickup)
        (OrderStatus.pickedUp, l10n.statusPickedUp, null)
      else
        (OrderStatus.delivered, l10n.statusDelivered, null),
    ];
    final cancelled = order.status == OrderStatus.cancelled;
    final reached = {for (final h in order.history) h.status: h.at};
    String at(DateTime t) {
      final local = t.toUtc().add(shopUtcOffset);
      final time =
          '${local.hour.toString().padLeft(2, '0')}:'
          '${local.minute.toString().padLeft(2, '0')}';
      return '${dayMonthText(locale, shopDateOf(t))} · $time';
    }

    final rows = [
      for (final (status, title, hint) in steps)
        if (!cancelled || reached.containsKey(status))
          (title, reached[status], hint, status == order.status),
      if (cancelled)
        (l10n.statusCancelled, reached[OrderStatus.cancelled], null, true),
    ];
    return Column(
      children: [
        for (final (i, (title, time, hint, now)) in rows.indexed)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: time != null ? BBColors.success : BBColors.surface,
                      border: Border.all(
                        color: time != null
                            ? BBColors.success
                            : BBColors.borderStrong,
                        width: 2,
                      ),
                    ),
                    child: time != null
                        ? const BBIcon(
                            BBIcons.check,
                            size: 12,
                            color: BBColors.onPrimary,
                          )
                        : null,
                  ),
                  if (i < rows.length - 1)
                    Container(width: 2, height: 32, color: BBColors.track),
                ],
              ),
              const SizedBox(width: BBSpacing.gutter),
              Expanded(
                child: Semantics(
                  selected: now,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: now
                            ? BBText.small.bold
                            : (time != null
                                  ? BBText.small
                                  : BBText.small.muted),
                      ),
                      if (time != null)
                        Text(
                          at(time),
                          style: BBText.xs.muted.merge(BBText.numeric),
                        )
                      else if (hint != null)
                        Text(hint, style: BBText.xs.muted),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

/// Screen 38: the shop could not match the payment.
class PaymentProblemCard extends ConsumerStatefulWidget {
  const new({required this.order, super.key});

  final OrderDto order;

  @override
  ConsumerState<PaymentProblemCard> createState() => _PaymentProblemCardState();
}

class _PaymentProblemCardState extends ConsumerState<PaymentProblemCard> {
  bool _busy = false;

  Future<void> _cash() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(orderActionsProvider).payCash(widget.order.number);
    } on Object catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l10n, error))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final order = widget.order;
    final now =
        ref.watch(nowTickerProvider).value ?? ref.watch(clockProvider)();
    final due = order.paymentDueAt;
    final whatsapp = ref.watch(branchProvider).value?.data.whatsapp;
    return Semantics(
      container: true,
      liveRegion: true,
      child: BBCard(
        color: BBColors.noticeErrBg,
        borderColor: BBColors.noticeErrBorder,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const BBIcon(BBIcons.warning, color: BBColors.noticeErrText),
                const SizedBox(width: BBSpacing.sm),
                Expanded(
                  child: Text(
                    l10n.payFailTitle,
                    style: BBText.bodyBold.copyWith(
                      color: BBColors.noticeErrText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: BBSpacing.xs),
            if (due != null)
              Text(
                l10n.payFailBody(countdownText(due, now)),
                style: BBText.small,
              ),
            if (order.paymentNote != null && order.paymentNote!.isNotEmpty) ...[
              const SizedBox(height: BBSpacing.xs),
              Text(
                l10n.payFailNote(order.paymentNote!),
                style: BBText.xs.muted,
              ),
            ],
            const SizedBox(height: BBSpacing.gutter),
            BBButton(
              label: l10n.payFailResend,
              expand: true,
              onPressed: () => context.push(Routes.orderPay(order.number)),
            ),
            const SizedBox(height: BBSpacing.sm),
            BBButton(
              label: l10n.payFailCash,
              variant: BBButtonVariant.secondary,
              expand: true,
              loading: _busy,
              onPressed: _cash,
            ),
            const SizedBox(height: BBSpacing.sm),
            BBButton(
              label: l10n.payFailContact,
              leading: BBIcons.whatsapp,
              variant: BBButtonVariant.quiet,
              expand: true,
              onPressed: whatsapp == null
                  ? null
                  : () => ref
                        .read(externalLinksProvider)
                        .open(ExternalLinks.whatsapp(whatsapp)),
            ),
          ],
        ),
      ),
    );
  }
}
