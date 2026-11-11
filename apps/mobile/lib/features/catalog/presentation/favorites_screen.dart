import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen 32 (FR-ACC-06). Saved products that are not available today still
/// show, with their badge.
class FavoritesScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final signedIn = ref.watch(sessionControllerProvider).value != null;
    final favorites = ref.watch(favoritesProvider);

    Widget message(String text, {Widget? action}) => Column(
      children: [
        const SizedBox(height: BBSpacing.xl),
        const BBHeroIcon(BBIcons.heart),
        const SizedBox(height: BBSpacing.md),
        Text(text, style: BBText.body.muted, textAlign: TextAlign.center),
        if (action != null) ...[const SizedBox(height: BBSpacing.md), action],
      ],
    );

    return Scaffold(
      appBar: BBTopBar(
        title: l10n.favoritesTitle,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(favoritesProvider.future),
        child: ListView(
          padding: const EdgeInsets.all(BBSpacing.page),
          children: [
            if (!signedIn)
              message(
                l10n.favoriteSignIn,
                action: BBButton(
                  label: l10n.onboardingSignIn,
                  leading: BBIcons.user,
                  onPressed: () => context.push(Routes.login),
                ),
              )
            else if (favorites.value case final items? when items.isEmpty)
              message(l10n.favoritesEmpty)
            else if (favorites.value case final items?)
              ProductGrid(products: items)
            else if (favorites.hasError)
              ErrorRetry(
                error: favorites.error!,
                onRetry: () => ref.invalidate(favoritesProvider),
              )
            else
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
