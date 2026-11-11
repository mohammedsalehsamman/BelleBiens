import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Tabs on the occasion page: everything, flowers, cakes and sweets, extras.
enum OccasionTab { all, flowers, cakes, extras }

bool inTab(OccasionTab tab, ProductKind kind) => switch (tab) {
  OccasionTab.all => true,
  OccasionTab.flowers => kind == ProductKind.bouquet,
  OccasionTab.cakes => kind == ProductKind.cake || kind == ProductKind.sweet,
  OccasionTab.extras => kind == ProductKind.gift || kind == ProductKind.drink,
};

/// Screen 11 (FR-CAT-11).
class OccasionScreen extends ConsumerStatefulWidget {
  const new({required this.slug, super.key});

  final String slug;

  @override
  ConsumerState<OccasionScreen> createState() => _OccasionScreenState();
}

class _OccasionScreenState extends ConsumerState<OccasionScreen> {
  OccasionTab _tab = OccasionTab.all;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final page = ref.watch(occasionProvider(widget.slug));
    final name = page.value?.data.occasion.name.of(context) ?? '';

    return Scaffold(
      appBar: BBTopBar(
        title: name,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(BBSpacing.page),
        children: [
          CachedAsync<OccasionPageDto>(
            value: page,
            onRetry: () => ref.invalidate(occasionProvider(widget.slug)),
            builder: (context, cached) {
              final data = cached.data;
              final products = data.products
                  .where((p) => inTab(_tab, p.kind))
                  .toList();
              final occasionName = data.occasion.name.of(context);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (cached.offline) ...[
                    const OfflineBanner(),
                    const SizedBox(height: BBSpacing.gutter),
                  ],
                  BBCard(
                    color: BBColors.blush,
                    borderColor: BBColors.blush,
                    child: Row(
                      children: [
                        const BBIcon(
                          BBIcons.gift,
                          size: 28,
                          color: BBColors.onBlush,
                        ),
                        const SizedBox(width: BBSpacing.gutter),
                        Expanded(
                          child: Text(
                            data.occasion.title.of(context),
                            style: BBText.h2.copyWith(color: BBColors.onBlush),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: BBSpacing.md),
                  ChipStrip(
                    children: [
                      for (final tab in OccasionTab.values)
                        BBChip(
                          label: switch (tab) {
                            OccasionTab.all => l10n.shopAll,
                            OccasionTab.flowers => l10n.occasionTabFlowers,
                            OccasionTab.cakes => l10n.occasionTabCakes,
                            OccasionTab.extras => l10n.occasionTabExtras,
                          },
                          selected: _tab == tab,
                          onTap: () => setState(() => _tab = tab),
                        ),
                    ],
                  ),
                  const SizedBox(height: BBSpacing.md),
                  ProductGrid(products: products),
                  const SizedBox(height: BBSpacing.md),
                  BBCard(
                    dashed: true,
                    onTap: () => context.go(Routes.designer),
                    child: Row(
                      children: [
                        const BBIconBox(BBIcons.flower),
                        const SizedBox(width: BBSpacing.gutter),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.occasionDesignCta(occasionName),
                                style: BBText.bodyBold,
                              ),
                              Text(
                                l10n.occasionDesignSub(occasionName),
                                style: BBText.xs.muted,
                              ),
                            ],
                          ),
                        ),
                        const BBIcon(
                          BBIcons.chevronRight,
                        ), // forward in RTL and LTR
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
