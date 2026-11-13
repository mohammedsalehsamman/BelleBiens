import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/analytics/analytics.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/launch/external_links.dart';
import 'package:belle_biens/core/money/money.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/cart/application/cart_controller.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:belle_biens/features/checkout/application/checkout_controller.dart';
import 'package:belle_biens/features/checkout/domain/checkout_draft.dart';
import 'package:belle_biens/features/checkout/presentation/checkout_widgets.dart';
import 'package:belle_biens/features/checkout/presentation/order_confirmed_screen.dart';
import 'package:belle_biens/features/checkout/presentation/shop_mode_notice.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Payment methods this release takes; the others show "قريباً" until
/// their sprints (Sham Cash S6, Stripe S12).
const Set<PaymentMethod> _supported = {
  PaymentMethod.cash,
  PaymentMethod.shamcash,
};

/// Screen 23: payment, a last look, and the order (FR-PAY-01/02, FR-CRT-08,
/// FR-CRT-12).
class PaymentScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _placing = false;

  Future<void> _place() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final draft = ref.read(checkoutControllerProvider);
    final money = ref.read(moneyFormatProvider);
    final whatsapp = ref.read(branchProvider).value?.data.whatsapp;
    final locale = Localizations.localeOf(context).languageCode;
    setState(() => _placing = true);
    try {
      final order = await ref.read(checkoutControllerProvider.notifier).place();
      ref.read(analyticsProvider).log(AnalyticsEvent.purchase, {
        'value': order.syp.totalMinor ~/ 100,
        'currency': 'SYP',
        'method': order.paymentMethod.name,
      });
      ref.read(checkoutControllerProvider.notifier).reset();
      // Sham Cash is paid next (screen 24); cash is done (screen 25).
      if (order.paymentMethod == PaymentMethod.shamcash) {
        router.go(Routes.orderPay(order.number));
      } else {
        router.go(Routes.orderConfirmed(order.number), extra: order);
      }
      // FR-CRT-12: the shop gets the number and the summary on WhatsApp.
      if (draft.whatsappConfirm && whatsapp != null) {
        await ref
            .read(externalLinksProvider)
            .open(
              ExternalLinks.whatsapp(
                whatsapp,
                text: orderWhatsappText(l10n, order, money, locale: locale),
              ),
            );
      }
    } on ApiError catch (error) {
      if (!mounted) return;
      setState(() => _placing = false);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(errorText(l10n, error))));
      switch (error.code) {
        case 'OUT_OF_ZONE':
          await router.push(Routes.checkoutOutOfZone);
        case 'SLOT_FULL' || 'SLOT_UNAVAILABLE':
          ref
            ..invalidate(daySlotsProvider)
            ..invalidate(deliveryCalendarProvider);
          router.pop();
        case 'CART_NOT_ORDERABLE' || 'STOCK_INSUFFICIENT' || 'COUPON_INVALID':
          // Back to the cart, where each line shows what changed.
          ref.invalidate(cartQuoteProvider);
          router
            ..pop()
            ..pop();
        case 'SHOP_CLOSED':
          ref.invalidate(appConfigProvider);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final d = ref.watch(checkoutControllerProvider);
    final quote = ref.watch(checkoutQuoteProvider);
    final money = ref.watch(moneyFormatProvider);
    final payments = ref.watch(appConfigProvider).value?.payments;
    final closed =
        ref.watch(appConfigProvider).value?.shop.mode ==
        ShopConfigDtoMode.closed;
    final q = quote.value;

    return Scaffold(
      appBar: BBTopBar(
        title: l10n.checkoutTitle,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(BBSpacing.page),
        children: [
          BBStepsBar(total: 2, current: 2, caption: l10n.checkoutStep2),
          const SizedBox(height: BBSpacing.section),
          const ShopModeNotice(),
          CheckoutSection(
            title: l10n.paymentMethodTitle,
            child: Column(
              children: [
                for (final (method, title, hint, enabled) in [
                  (
                    PaymentMethod.cash,
                    l10n.paymentCash,
                    l10n.paymentCashHint,
                    payments?.cash ?? true,
                  ),
                  (
                    PaymentMethod.shamcash,
                    l10n.paymentShamcash,
                    l10n.paymentShamcashHint,
                    payments?.shamcash ?? false,
                  ),
                  (
                    PaymentMethod.stripe,
                    l10n.paymentStripe,
                    l10n.paymentStripeHint,
                    payments?.stripe ?? false,
                  ),
                ])
                  if (enabled) ...[
                    _MethodTile(
                      title: title,
                      hint: hint,
                      badge: method == PaymentMethod.stripe
                          ? l10n.paymentStripeBadge
                          : null,
                      soon: !_supported.contains(method),
                      selected: d.paymentMethod == method,
                      onTap: () => ref
                          .read(checkoutControllerProvider.notifier)
                          .edit((x) => x.copyWith(paymentMethod: method)),
                    ),
                    const SizedBox(height: BBSpacing.sm),
                  ],
              ],
            ),
          ),
          const SizedBox(height: BBSpacing.md),
          _Summary(draft: d),
          const SizedBox(height: BBSpacing.section),
          CheckoutSection(
            title: l10n.paymentInvoice,
            action: SizedBox(
              width: 112,
              child: BBSegmented<DisplayCurrency>(
                dense: true,
                segments: [
                  (DisplayCurrency.syp, money.sypSymbol),
                  (DisplayCurrency.usd, r'$'),
                ],
                selected: money.currency,
                onChanged: (c) =>
                    ref.read(displayCurrencyProvider.notifier).select(c),
              ),
            ),
            child: q == null
                ? (quote.hasError
                      ? BBNotice(
                          text: errorText(l10n, quote.error!),
                          tone: BBNoticeTone.error,
                        )
                      : const Center(child: CircularProgressIndicator()))
                : _Invoice(quote: q, draft: d, money: money),
          ),
          const SizedBox(height: BBSpacing.md),
          ToggleRow(
            label: l10n.paymentWhatsapp,
            subtitle: l10n.paymentWhatsappHint,
            value: d.whatsappConfirm,
            onChanged: (v) => ref
                .read(checkoutControllerProvider.notifier)
                .edit((x) => x.copyWith(whatsappConfirm: v)),
          ),
          const SizedBox(height: BBSpacing.md),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: l10n.paymentTermsLead),
                TextSpan(
                  text: l10n.paymentTermsLink,
                  style: const TextStyle(
                    color: BBColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => context.push(Routes.page('terms')),
                ),
                const TextSpan(text: '.'),
              ],
            ),
            style: BBText.xs.muted,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: BBSpacing.lg),
        ],
      ),
      bottomNavigationBar: BBBottomCta(
        children: [
          Expanded(
            child: BBButton(
              label: q == null
                  ? l10n.paymentTotal
                  : l10n.paymentConfirm(money.primary(q.syp.totalMinor)),
              expand: true,
              loading: _placing,
              onPressed:
                  q == null ||
                      !q.orderable ||
                      closed ||
                      !_supported.contains(d.paymentMethod)
                  ? null
                  : _place,
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const new({
    required this.title,
    required this.hint,
    required this.soon,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final String title;
  final String hint;
  final String? badge;
  final bool soon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Opacity(
      opacity: soon ? 0.6 : 1,
      child: BBOptionTile(
        title: title,
        subtitle: hint,
        selected: selected && !soon,
        onTap: soon ? null : onTap,
        trailing: soon
            ? BBBadge(label: l10n.paymentSoon, tone: BBBadgeTone.gray)
            : (badge == null
                  ? null
                  : BBBadge(label: badge!, tone: BBBadgeTone.gray)),
      ),
    );
  }
}

/// "غداً 12:00 – 14:00 · البيت، أبو رمانة" and the recipient (screen 23).
class _Summary extends ConsumerWidget {
  const new({required this.draft});

  final CheckoutDraft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final lead = ref.watch(cartLeadTimeProvider) ?? 0;
    final days =
        ref
            .watch(
              deliveryCalendarProvider((
                leadTimeHours: lead,
                fulfillment: draft.fulfillment,
              )),
            )
            .value
            ?.days ??
        const <DeliveryDayDto>[];
    final date = draft.date;
    final inDays = days.indexWhere((x) => x.date == date);
    final when = date == null || draft.slotStart == null
        ? ''
        : slotWhenText(
            l10n,
            locale,
            date: date,
            inDays: inDays < 0 ? 2 : inDays,
            start: draft.slotStart!,
            end: draft.slotEnd ?? '',
          );
    final where = draft.delivery
        ? addressTitle(context, draft.address?.label ?? '', draft.address?.zone)
        : l10n.paymentPickupWhere;
    final name = draft.recipientIsMe ? draft.customerName : draft.recipientName;
    return BBCard(
      color: BBColors.surfaceLow,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.paymentWhenWhere(when, where),
                  style: BBText.small.bold.merge(BBText.numeric),
                ),
                const SizedBox(height: 2),
                Text(
                  !draft.recipientIsMe && draft.hideSender
                      ? l10n.paymentRecipientHidden(name)
                      : l10n.paymentRecipient(name),
                  style: BBText.small,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).maybePop(),
            child: Text(l10n.commonEdit),
          ),
        ],
      ),
    );
  }
}

class _Invoice extends StatelessWidget {
  const new({required this.quote, required this.draft, required this.money});

  final CartQuoteDto quote;
  final CheckoutDraft draft;
  final MoneyFormat money;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final syp = quote.syp;
    final count = quote.lines.fold<int>(0, (s, l) => s + l.qty);
    final zone = draft.delivery ? draft.address?.zone : null;
    String amount(int minor) => money.primary(minor);
    return BBCard(
      child: Column(
        children: [
          BBKvRow(
            label: l10n.paymentProducts(count),
            value: amount(syp.itemsMinor),
            mutedLabel: true,
          ),
          if (syp.assemblyFeeMinor > 0) ...[
            const SizedBox(height: BBSpacing.xs),
            BBKvRow(
              label: l10n.designerAssemblyFee,
              value: amount(syp.assemblyFeeMinor),
              mutedLabel: true,
            ),
          ],
          const SizedBox(height: BBSpacing.xs),
          BBKvRow(
            label: zone == null
                ? l10n.paymentPickupWhere
                : l10n.paymentDeliveryZone(zone.name.of(context)),
            value: zone == null
                ? l10n.checkoutPickupFree
                : amount(syp.deliveryFeeMinor),
            mutedLabel: true,
          ),
          const SizedBox(height: BBSpacing.xs),
          BBKvRow(
            label: l10n.cartDiscount,
            value: syp.discountMinor == 0
                ? amount(0)
                : money.change(-syp.discountMinor),
            mutedLabel: true,
          ),
          if (syp.roundingAdjustmentMinor != 0) ...[
            const SizedBox(height: BBSpacing.xs),
            BBKvRow(
              label: l10n.cartRounding,
              value: money.change(syp.roundingAdjustmentMinor),
              mutedLabel: true,
            ),
          ],
          const Divider(),
          BBKvRow(
            label: l10n.paymentTotal,
            value: amount(syp.totalMinor),
            total: true,
          ),
          const SizedBox(height: BBSpacing.xs),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              l10n.paymentUsdNote(money.usdCents(quote.usd.totalMinor)),
              style: BBText.xs.muted.merge(BBText.numeric),
            ),
          ),
        ],
      ),
    );
  }
}
