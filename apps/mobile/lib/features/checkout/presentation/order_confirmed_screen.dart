import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/launch/external_links.dart';
import 'package:belle_biens/core/money/money.dart';
import 'package:belle_biens/core/time/shop_time.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/checkout/presentation/checkout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// "غداً 12:00 – 14:00" for an order, counted from the day it was placed.
String orderWhenText(AppLocalizations l10n, String locale, OrderDto order) {
  final placed = shopDateOf(order.createdAt);
  return slotWhenText(
    l10n,
    locale,
    date: order.slot.date,
    inDays: daysBetween(placed, order.slot.date),
    start: order.slot.start,
    end: order.slot.end,
  );
}

/// FR-CRT-12: the message the customer sends the shop to confirm.
String orderWhatsappText(
  AppLocalizations l10n,
  OrderDto order,
  MoneyFormat money, {
  String locale = 'ar',
}) {
  final english = locale == 'en';
  final summary = [
    for (final line in order.lines)
      '• ${english ? line.title.en : line.title.ar} × ${line.qty}',
  ].join('\n');
  return l10n.orderWhatsappMessage(
    order.number,
    summary,
    money.syp(order.syp.totalMinor),
    orderWhenText(l10n, locale, order),
  );
}

String paymentMethodName(AppLocalizations l10n, PaymentMethod method) =>
    switch (method) {
      PaymentMethod.cash => l10n.paymentCash,
      PaymentMethod.shamcash => l10n.paymentShamcash,
      PaymentMethod.stripe => l10n.paymentStripe,
    };

/// Screen 25: the order number, when, where, and what happens next.
class OrderConfirmedScreen extends ConsumerWidget {
  const new({required this.order, super.key});

  final OrderDto order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final money = ref.watch(moneyFormatProvider);
    final guest = ref.watch(sessionControllerProvider).value == null;
    final whatsapp = ref.watch(branchProvider).value?.data.whatsapp;
    final delivery = order.fulfillment == Fulfillment.delivery;
    final address = order.address;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(BBSpacing.page),
          children: [
            const SizedBox(height: BBSpacing.lg),
            const Center(child: BBHeroIcon(BBIcons.check)),
            const SizedBox(height: BBSpacing.md),
            Semantics(
              header: true,
              child: Text(
                l10n.confirmTitle,
                style: BBText.h1,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: BBSpacing.xs),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '${l10n.confirmNumber} '),
                  TextSpan(
                    text: order.number,
                    style: BBText.bodyBold.copyWith(color: BBColors.text),
                  ),
                ],
              ),
              style: BBText.body.muted.merge(BBText.numeric),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BBSpacing.sm),
            Center(
              child: BBBadge(
                label: l10n.confirmPendingShop,
                tone: BBBadgeTone.amber,
              ),
            ),
            const SizedBox(height: BBSpacing.section),
            BBCard(
              child: Column(
                children: [
                  BBKvRow(
                    label: l10n.confirmWhen,
                    value: orderWhenText(l10n, locale, order),
                    mutedLabel: true,
                    longValue: true,
                  ),
                  const SizedBox(height: BBSpacing.xs),
                  BBKvRow(
                    label: delivery ? l10n.confirmWhere : l10n.confirmPickup,
                    value: delivery && address != null
                        ? addressTitle(context, address.label, order.zone)
                        : l10n.paymentPickupWhere,
                    mutedLabel: true,
                    longValue: true,
                  ),
                  const SizedBox(height: BBSpacing.xs),
                  BBKvRow(
                    label: l10n.confirmPayment,
                    value: paymentMethodName(l10n, order.paymentMethod),
                    mutedLabel: true,
                    longValue: true,
                  ),
                  const Divider(),
                  BBKvRow(
                    label: l10n.paymentTotal,
                    value: money.syp(order.syp.totalMinor),
                    total: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: BBSpacing.section),
            Semantics(
              header: true,
              child: Text(l10n.confirmNextTitle, style: BBText.h3),
            ),
            const SizedBox(height: BBSpacing.sm),
            _Step(n: 1, text: l10n.confirmNextCash),
            const SizedBox(height: BBSpacing.sm),
            _Step(
              n: 2,
              text: delivery
                  ? l10n.confirmNextDelivery
                  : l10n.confirmNextPickup,
            ),
            const SizedBox(height: BBSpacing.section),
            BBButton(
              label: l10n.confirmTrack,
              expand: true,
              onPressed: () => context.go(Routes.orders),
            ),
            const SizedBox(height: BBSpacing.sm),
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
            const SizedBox(height: BBSpacing.sm),
            BBButton(
              label: l10n.confirmContinue,
              variant: BBButtonVariant.quiet,
              expand: true,
              onPressed: () => context.go(Routes.home),
            ),
            if (guest) ...[
              const SizedBox(height: BBSpacing.section),
              BBCard(
                color: BBColors.surfaceLow,
                onTap: () => context.push(Routes.register),
                child: Row(
                  children: [
                    const BBIconBox(BBIcons.user, size: 40),
                    const SizedBox(width: BBSpacing.gutter),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.confirmGuestTitle,
                            style: BBText.small.bold,
                          ),
                          Text(l10n.confirmGuestBody, style: BBText.xs.muted),
                        ],
                      ),
                    ),
                    const BBIcon(
                      BBIcons.chevronLeft,
                      color: BBColors.textMuted,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const new({required this.n, required this.text});

  final int n;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: BBColors.blush,
          shape: BoxShape.circle,
        ),
        child: Text(
          '$n',
          style: BBText.small.bold.copyWith(color: BBColors.onBlush),
        ),
      ),
      const SizedBox(width: BBSpacing.gutter),
      Expanded(child: Text(text, style: BBText.small)),
    ],
  );
}
