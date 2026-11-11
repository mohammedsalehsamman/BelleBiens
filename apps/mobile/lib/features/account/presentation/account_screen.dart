import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/locale/app_locale.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The Account tab. The full screen 28 (addresses, designs, occasions,
/// favorites, settings) comes in S7; for now: who is signed in, language,
/// sign in or out.
class AccountScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionControllerProvider).value;
    final locale = ref.watch(appLocaleProvider);

    return BBScreen(
      topBar: BBTopBar(title: l10n.navAccount),
      children: [
        if (session == null)
          BBCard(
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
          )
        else
          BBCard(
            child: Row(
              children: [
                const BBIconBox(BBIcons.user),
                const SizedBox(width: BBSpacing.gutter),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.accountHello(session.user.name),
                        style: BBText.h3,
                      ),
                      if (session.user.phone != null)
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            session.user.phone!,
                            style: BBText.small.muted.merge(BBText.numeric),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        BBListGroup(
          children: [
            BBListTile(
              title: l10n.favoritesTitle,
              leading: const BBIconBox(BBIcons.heart, size: 36),
              onTap: () => context.push(Routes.favorites),
            ),
            BBListTile(
              title: l10n.branchTitle,
              leading: const BBIconBox(BBIcons.store, size: 36),
              onTap: () => context.push(Routes.branch),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.accountLanguage, style: BBText.label),
            const SizedBox(height: BBSpacing.sm),
            BBSegmented<String>(
              segments: [
                ('ar', l10n.languageArabic),
                ('en', l10n.languageEnglish),
              ],
              selected: locale.languageCode,
              onChanged: (code) =>
                  ref.read(appLocaleProvider.notifier).select(Locale(code)),
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
        const SizedBox(height: BBSpacing.sm),
        Text(
          'Belle Biens',
          style: BBText.wordmark.copyWith(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        Text('', style: BBText.xs.withColor(BBColors.textMuted)),
      ],
    );
  }
}
