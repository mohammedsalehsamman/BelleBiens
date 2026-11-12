import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/time/date_text.dart';
import 'package:belle_biens/core/time/shop_time.dart';
import 'package:belle_biens/core/validation/phone.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/cart/presentation/cart_screen.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:belle_biens/features/checkout/presentation/checkout_widgets.dart';
import 'package:belle_biens/features/orders/application/orders_providers.dart';
import 'package:belle_biens/features/orders/presentation/order_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen 26 (tab): current and past orders; a guest finds an order by
/// number and phone (FR-ORD-04).
class OrdersScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final orders = ref.watch(ordersListProvider);
    final signedIn = ref.watch(sessionControllerProvider).value != null;
    final items = orders.value ?? const <OrderListItem>[];
    final current = items.where((o) => o.current).toList();
    final past = items.where((o) => !o.current).toList();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(ordersListProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(BBSpacing.page),
            children: [
              Semantics(
                header: true,
                child: Text(l10n.ordersTitle, style: BBText.h1),
              ),
              const SizedBox(height: BBSpacing.md),
              if (orders.hasError && !orders.hasValue)
                ErrorRetry(
                  error: orders.error!,
                  onRetry: () => ref.invalidate(ordersListProvider),
                )
              else if (!orders.hasValue)
                const Padding(
                  padding: EdgeInsets.all(BBSpacing.lg),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (items.isEmpty)
                BBNotice(text: l10n.ordersEmpty, icon: BBIcons.receipt)
              else ...[
                if (current.isNotEmpty) ...[
                  Text(l10n.ordersCurrent(current.length), style: BBText.h3),
                  const SizedBox(height: BBSpacing.sm),
                  for (final o in current) ...[
                    _CurrentCard(order: o),
                    const SizedBox(height: BBSpacing.gutter),
                  ],
                ],
                if (past.isNotEmpty) ...[
                  const SizedBox(height: BBSpacing.sm),
                  Text(l10n.ordersPast(past.length), style: BBText.h3),
                  const SizedBox(height: BBSpacing.sm),
                  for (final o in past) ...[
                    _PastCard(order: o),
                    const SizedBox(height: BBSpacing.gutter),
                  ],
                ],
              ],
              if (!signedIn) ...[
                const SizedBox(height: BBSpacing.section),
                const _GuestLookup(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrentCard extends ConsumerWidget {
  const new({required this.order});

  final OrderListItem order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final money = ref.watch(moneyFormatProvider);
    final when = slotWhenText(
      l10n,
      locale,
      date: order.slot.date,
      inDays: daysBetween(
        shopDateOf(ref.watch(clockProvider)()),
        order.slot.date,
      ),
      start: order.slot.start,
      end: order.slot.end,
    );
    return BBCard(
      onTap: () => context.push(Routes.order(order.number)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.number,
                  style: BBText.bodyBold.merge(BBText.numeric),
                ),
              ),
              Flexible(
                child: OrderStateBadge(
                  status: order.status,
                  paymentStatus: order.paymentStatus,
                  paymentMethod: order.paymentMethod,
                ),
              ),
            ],
          ),
          const SizedBox(height: BBSpacing.xs),
          Text(
            '${l10n.ordersPieces(order.itemCount)} · $when',
            style: BBText.small.muted.merge(BBText.numeric),
          ),
          const SizedBox(height: BBSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  money.syp(order.totalMinor),
                  style: BBText.price.merge(BBText.numeric),
                ),
              ),
              BBButton(
                label: l10n.ordersTrack,
                small: true,
                onPressed: () => context.push(Routes.order(order.number)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PastCard extends ConsumerStatefulWidget {
  const new({required this.order});

  final OrderListItem order;

  @override
  ConsumerState<_PastCard> createState() => _PastCardState();
}

class _PastCardState extends ConsumerState<_PastCard> {
  bool _busy = false;

  /// FR-ORD-07: the lines go back in the cart, priced again at checkout.
  Future<void> _again() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final actions = ref.read(orderActionsProvider);
      await actions.orderAgain(await actions.fetch(widget.order.number));
      if (mounted) showAddedToCart(context, l10n.ordersAgainDone);
    } on Object catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l10n, error))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final o = widget.order;
    final title = o.title.of(context);
    return BBCard(
      onTap: () => context.push(Routes.order(o.number)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(o.number, style: BBText.bodyBold.merge(BBText.numeric)),
                Text(
                  [
                    dayMonthText(locale, shopDateOf(o.createdAt)),
                    if (title.isNotEmpty) title,
                  ].join(' · '),
                  style: BBText.xs.muted,
                ),
                const SizedBox(height: BBSpacing.xs),
                OrderStateBadge(
                  status: o.status,
                  paymentStatus: o.paymentStatus,
                  paymentMethod: o.paymentMethod,
                ),
              ],
            ),
          ),
          const SizedBox(width: BBSpacing.sm),
          BBButton(
            label: l10n.ordersAgain,
            small: true,
            variant: BBButtonVariant.secondary,
            loading: _busy,
            onPressed: _again,
          ),
        ],
      ),
    );
  }
}

class _GuestLookup extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_GuestLookup> createState() => _GuestLookupState();
}

class _GuestLookupState extends ConsumerState<_GuestLookup> {
  final _number = TextEditingController();
  final _phone = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _number.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _find() async {
    final l10n = AppLocalizations.of(context);
    final number = _number.text.trim().toUpperCase();
    final phone = _phone.text.trim();
    if (!RegExp(r'^BB-\d{4,9}$').hasMatch(number) ||
        normalizePhone(phone) == null) {
      setState(() => _error = l10n.ordersNotFound);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final order = await ref
          .read(orderActionsProvider)
          .findAsGuest(number, phone);
      if (mounted) await context.push(Routes.order(order.number));
    } on ApiError catch (error) {
      if (mounted) {
        setState(
          () => _error = error.code == 'NOT_FOUND'
              ? l10n.ordersNotFound
              : errorText(l10n, error),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BBCard(
      color: BBColors.surfaceLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.ordersGuestTitle, style: BBText.bodyBold),
          Text(l10n.ordersGuestBody, style: BBText.xs.muted),
          const SizedBox(height: BBSpacing.gutter),
          BBTextField(
            label: l10n.ordersNumber,
            controller: _number,
            hint: 'BB-1001',
            textDirection: TextDirection.ltr,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: BBSpacing.gutter),
          BBTextField(
            label: l10n.phoneLabel,
            controller: _phone,
            hint: l10n.phoneHint,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.ltr,
            error: _error,
            onSubmitted: (_) => _find(),
          ),
          const SizedBox(height: BBSpacing.gutter),
          BBButton(
            label: l10n.ordersShow,
            variant: BBButtonVariant.secondary,
            expand: true,
            loading: _busy,
            onPressed: _find,
          ),
        ],
      ),
    );
  }
}
