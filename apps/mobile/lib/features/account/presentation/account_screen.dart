import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/account/application/account_providers.dart';
import 'package:belle_biens/features/account/presentation/occasions_screen.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/orders/application/orders_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// "+963 944 *** 456", as screen 28 shows the phone.
String maskedPhone(String e164) {
  if (e164.startsWith('+963') && e164.length == 13) {
    return '+963 ${e164.substring(4, 7)} *** ${e164.substring(10)}';
  }
  if (e164.length <= 6) return e164;
  final head = e164.substring(0, e164.length - 6);
  return '$head***${e164.substring(e164.length - 3)}';
}

/// Screen 28 (tab): the customer and everything kept for them.
class AccountScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionControllerProvider).value;

    return BBScreen(
      topBar: BBTopBar(title: l10n.accountTitle),
      children: [
        if (session == null) const _Guest() else _Profile(user: session.user),
        if (session != null) const _Kept(),
        BBListGroup(
          children: [
            BBListTile(
              title: l10n.favoritesTitle,
              leading: const BBIconBox(BBIcons.heart, size: 36),
              onTap: () => context.push(Routes.favorites),
            ),
            BBListTile(
              title: l10n.accountSettings,
              leading: const BBIconBox(BBIcons.settings, size: 36),
              onTap: () => context.push(Routes.settings),
            ),
            BBListTile(
              title: l10n.branchTitle,
              leading: const BBIconBox(BBIcons.store, size: 36),
              onTap: () => context.push(Routes.branch),
            ),
            BBListTile(
              title: l10n.accountPrivacy,
              leading: const BBIconBox(BBIcons.shieldCheck, size: 36),
              onTap: () => context.push(Routes.page('privacy')),
            ),
          ],
        ),
        if (session != null)
          BBButton(
            label: l10n.accountSignOut,
            leading: BBIcons.logout,
            variant: BBButtonVariant.secondary,
            expand: true,
            onPressed: () =>
                ref.read(sessionControllerProvider.notifier).signOut(),
          ),
        Text(
          'Belle Biens',
          style: BBText.wordmark.copyWith(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _Guest extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BBCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(
            alignment: AlignmentDirectional.centerStart,
            child: BBIconBox(BBIcons.user),
          ),
          const SizedBox(height: BBSpacing.gutter),
          Text(l10n.accountGuestTitle, style: BBText.h3),
          Text(l10n.accountGuestBody, style: BBText.small.muted),
          const SizedBox(height: BBSpacing.md),
          BBButton(
            label: l10n.onboardingSignIn,
            leading: BBIcons.user,
            expand: true,
            onPressed: () => context.push(Routes.login),
          ),
          const SizedBox(height: BBSpacing.sm),
          BBButton(
            label: l10n.onboardingCreateAccount,
            variant: BBButtonVariant.secondary,
            expand: true,
            onPressed: () => context.push(Routes.register),
          ),
        ],
      ),
    );
  }
}

class _Profile extends StatelessWidget {
  const new({required this.user});

  final MeDto user;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final phone = user.phone;
    return BBCard(
      onTap: () => context.push(Routes.profile),
      child: Row(
        children: [
          const BBIconBox(BBIcons.user),
          const SizedBox(width: BBSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name.isEmpty ? l10n.accountEditProfile : user.name,
                  style: BBText.h3,
                ),
                if (phone != null)
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      maskedPhone(phone),
                      style: BBText.small.muted.merge(BBText.numeric),
                    ),
                  ),
              ],
            ),
          ),
          const BBIcon(BBIcons.chevronRight, color: BBColors.textMuted),
        ],
      ),
    );
  }
}

/// Orders, addresses, designs and occasions, each with its count.
class _Kept extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final orders = ref.watch(ordersListProvider).value;
    final addresses = ref.watch(myAddressesProvider).value;
    final designs = ref.watch(myDesignsProvider).value;
    final occasions = ref.watch(myOccasionsProvider).value;
    final next = occasions?.firstOrNull;

    // No count: the row keeps its usual chevron.
    Widget? count(int? n) => n == null || n == 0 ? null : BBBadge(label: '$n');

    return BBListGroup(
      children: [
        BBListTile(
          title: l10n.navOrders,
          subtitle: orders == null
              ? null
              : l10n.accountOrdersCurrent(
                  orders.where((o) => o.current).length,
                ),
          leading: const BBIconBox(BBIcons.receipt, size: 36),
          onTap: () => context.go(Routes.orders),
        ),
        BBListTile(
          title: l10n.accountAddresses,
          leading: const BBIconBox(BBIcons.pin, size: 36),
          trailing: count(addresses?.length),
          onTap: () => context.push(Routes.addresses),
        ),
        BBListTile(
          title: l10n.accountDesigns,
          leading: const BBIconBox(BBIcons.flower, size: 36),
          trailing: count(designs?.length),
          onTap: () => context.push(Routes.designs),
        ),
        BBListTile(
          title: l10n.accountOccasions,
          subtitle: next == null
              ? null
              : l10n.accountOccasionNext(
                  occasionCountdown(l10n, next.daysLeft),
                  occasionTypeName(l10n, next.type2),
                  next.person,
                ),
          leading: const BBIconBox(BBIcons.calendar, size: 36),
          onTap: () => context.push(Routes.occasions),
        ),
      ],
    );
  }
}
