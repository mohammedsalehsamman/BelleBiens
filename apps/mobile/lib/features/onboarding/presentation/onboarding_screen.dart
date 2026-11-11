import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/locale/app_locale.dart';
import 'package:belle_biens/app/preferences.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen 01: language, what the shop offers, and three ways in.
class OnboardingScreen extends ConsumerWidget {
  const new({super.key});

  Future<void> _leave(BuildContext context, WidgetRef ref, String route) async {
    await ref.read(appPreferencesProvider).setOnboardingSeen();
    if (!context.mounted) return;
    if (route == Routes.home) {
      context.go(route);
    } else {
      await context.push(route);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(appLocaleProvider);

    return BBScreen(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        Row(
          children: [
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 170),
                child: BBSegmented<String>(
                  segments: [
                    ('ar', l10n.languageArabic),
                    ('en', l10n.languageEnglish),
                  ],
                  selected: locale.languageCode,
                  onChanged: (code) =>
                      ref.read(appLocaleProvider.notifier).select(Locale(code)),
                ),
              ),
            ),
            const SizedBox(width: BBSpacing.sm),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: BBLink(
                  label: l10n.onboardingBrowseAsGuest,
                  onPressed: () => _leave(context, ref, Routes.home),
                ),
              ),
            ),
          ],
        ),
        _Hero(label: l10n.onboardingPhotoLabel, badge: l10n.onboardingBadge),
        Column(
          children: [
            Text(
              l10n.onboardingEyebrow,
              style: BBText.eyebrow,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BBSpacing.sm),
            Semantics(
              header: true,
              child: Text(
                l10n.onboardingTitle,
                style: BBText.h1.withColor(BBColors.primaryDeep),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: BBSpacing.sm),
            Text(
              l10n.onboardingBody,
              style: BBText.body.muted,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Column(
          children: [
            _Feature(
              icon: BBIcons.flower,
              title: l10n.onboardingDesignTitle,
              body: l10n.onboardingDesignBody,
            ),
            const SizedBox(height: BBSpacing.gutter),
            _Feature(
              icon: BBIcons.truck,
              title: l10n.onboardingDeliveryTitle,
              body: l10n.onboardingDeliveryBody,
            ),
            const SizedBox(height: BBSpacing.gutter),
            _Feature(
              icon: BBIcons.whatsapp,
              title: l10n.onboardingWhatsappTitle,
              body: l10n.onboardingWhatsappBody,
            ),
          ],
        ),
        Column(
          children: [
            BBButton(
              label: l10n.onboardingCreateAccount,
              trailing: BBIcons.forward,
              expand: true,
              onPressed: () => _leave(context, ref, Routes.register),
            ),
            const SizedBox(height: BBSpacing.gutter),
            BBButton(
              label: l10n.onboardingSignIn,
              leading: BBIcons.user,
              variant: BBButtonVariant.secondary,
              expand: true,
              onPressed: () => _leave(context, ref, Routes.login),
            ),
            const SizedBox(height: BBSpacing.gutter),
            BBButton(
              label: l10n.onboardingContinueAsGuest,
              leading: BBIcons.bag,
              variant: BBButtonVariant.quiet,
              expand: true,
              onPressed: () => _leave(context, ref, Routes.home),
            ),
          ],
        ),
      ],
    );
  }
}

/// Placeholder until the shop's photo shoot (5.6, CT-07): brand colors and the
/// flower mark instead of a stock image.
class _Hero extends StatelessWidget {
  const new({required this.label, required this.badge});

  final String label;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: label,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(BBRadius.sheet),
          gradient: const LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [BBColors.blush, BBColors.previewWash, BBColors.sage],
          ),
        ),
        child: Stack(
          children: [
            const Center(
              child: BBIcon(BBIcons.flower, size: 120, color: BBColors.primary),
            ),
            PositionedDirectional(
              bottom: 14,
              start: 14,
              child: BBBadge(label: badge, tone: BBBadgeTone.dark),
            ),
          ],
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const new({required this.icon, required this.title, required this.body});

  final BBIcons icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return BBCard(
      child: Row(
        children: [
          BBIconBox(icon),
          const SizedBox(width: BBSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: BBText.bodyBold),
                Text(body, style: BBText.small.muted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
