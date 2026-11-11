import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/filters_sheet.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen 07: category chips, filters, sorting and the product grid.
class ShopScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(shopQueryProvider);
    final products = ref.watch(shopProductsProvider);
    final categories = ref.watch(homeProvider).value?.data.categories ?? [];
    final filters = query.filterCount;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(shopProductsProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(BBSpacing.page),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(l10n.shopTitle, style: BBText.h1),
                    ),
                  ),
                  const CurrencySwitch(),
                ],
              ),
              const SizedBox(height: BBSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: SearchEntry(
                      hint: l10n.shopSearchHint,
                      onTap: () => context.push(Routes.search),
                    ),
                  ),
                  const SizedBox(width: BBSpacing.sm),
                  BBButton(
                    label: filters == 0
                        ? l10n.shopFilters
                        : l10n.shopFiltersCount(filters),
                    leading: BBIcons.filter,
                    variant: filters == 0
                        ? BBButtonVariant.secondary
                        : BBButtonVariant.soft,
                    small: true,
                    onPressed: () => showFiltersSheet(context),
                  ),
                ],
              ),
              const SizedBox(height: BBSpacing.gutter),
              ChipStrip(
                children: [
                  BBChip(
                    label: l10n.shopAll,
                    selected: query.category == null,
                    onTap: () =>
                        ref.read(shopQueryProvider.notifier).category(null),
                  ),
                  for (final c in categories)
                    BBChip(
                      label: c.name.of(context),
                      selected: query.category == c.slug,
                      onTap: () =>
                          ref.read(shopQueryProvider.notifier).category(c.slug),
                    ),
                ],
              ),
              const SizedBox(height: BBSpacing.gutter),
              if (products.value case final page?) ...[
                if (page.offline) ...[
                  const OfflineBanner(),
                  const SizedBox(height: BBSpacing.gutter),
                ],
                _ResultsBar(total: page.total),
                const SizedBox(height: BBSpacing.gutter),
                if (page.items.isEmpty)
                  _EmptyResults(hasFilters: filters > 0)
                else
                  ProductGrid(products: page.items),
                if (page.hasMore) ...[
                  const SizedBox(height: BBSpacing.md),
                  BBButton(
                    label: l10n.shopLoadMore,
                    variant: BBButtonVariant.secondary,
                    expand: true,
                    loading: page.loadingMore,
                    onPressed: () => _loadMore(context, ref),
                  ),
                ],
              ] else if (products.hasError)
                ErrorRetry(
                  error: products.error!,
                  onRetry: () => ref.invalidate(shopProductsProvider),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(BBSpacing.xl),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadMore(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(shopProductsProvider.notifier).loadMore();
    } on Object catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorText(AppLocalizations.of(context), error))),
      );
    }
  }
}

class _ResultsBar extends ConsumerWidget {
  const new({required this.total});

  final int total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sort = ref.watch(shopQueryProvider).sort;
    return Row(
      children: [
        Expanded(
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: () => _chooseSort(context, ref),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: BBSizes.minTouch),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    '${l10n.shopResultsCount(total)} · '
                    '${l10n.shopSortedBy(sortLabel(l10n, sort))}',
                    style: BBText.small.muted,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (ref.watch(homeProvider).value?.data.branch.status.openNow
            case final open?)
          BBBadge(
            label: open ? l10n.shopOpenForOrders : l10n.shopClosedNow,
            tone: open ? BBBadgeTone.green : BBBadgeTone.gray,
          ),
      ],
    );
  }

  Future<void> _chooseSort(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final current = ref.read(shopQueryProvider);
    final chosen = await showModalBottomSheet<ProductSort>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        // Scrolls on short screens and at large text sizes.
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              BBSpacing.page,
              0,
              BBSpacing.page,
              BBSpacing.page,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.shopSortTitle, style: BBText.h3),
                const SizedBox(height: BBSpacing.gutter),
                for (final sort in ProductSort.values) ...[
                  BBOptionTile(
                    title: sortLabel(l10n, sort),
                    selected: sort == current.sort,
                    onTap: () => Navigator.of(context).pop(sort),
                  ),
                  const SizedBox(height: BBSpacing.sm),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    if (chosen != null) {
      ref.read(shopQueryProvider.notifier).set(current.copyWith(sort: chosen));
    }
  }
}

String sortLabel(AppLocalizations l10n, ProductSort sort) => switch (sort) {
  ProductSort.popular => l10n.sortPopular,
  ProductSort.newest => l10n.sortNewest,
  ProductSort.priceAsc => l10n.sortPriceAsc,
  ProductSort.priceDesc => l10n.sortPriceDesc,
};

class _EmptyResults extends ConsumerWidget {
  const new({required this.hasFilters});

  final bool hasFilters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        const SizedBox(height: BBSpacing.lg),
        const BBHeroIcon(BBIcons.search),
        const SizedBox(height: BBSpacing.md),
        Text(
          l10n.shopEmpty,
          style: BBText.body.muted,
          textAlign: TextAlign.center,
        ),
        if (hasFilters) ...[
          const SizedBox(height: BBSpacing.md),
          BBButton(
            label: l10n.shopClearFilters,
            variant: BBButtonVariant.secondary,
            onPressed: () {
              ref
                  .read(shopQueryProvider.notifier)
                  .set(ref.read(shopQueryProvider).clearFilters());
            },
          ),
        ],
      ],
    );
  }
}
