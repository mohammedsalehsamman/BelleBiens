import 'package:belle_biens/app/env.dart';
import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/launch/external_links.dart';
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

/// Screen 06: designer first, then today's flowers, cakes and the branch.
class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final home = ref.watch(homeProvider);
    final area = ref.watch(sessionControllerProvider).value?.user.homeArea;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(homeProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(BBSpacing.page),
            children: [
              _Header(area: area),
              const SizedBox(height: BBSpacing.md),
              SearchEntry(
                hint: l10n.homeSearchHint,
                onTap: () => context.push(Routes.search),
              ),
              const SizedBox(height: BBSpacing.md),
              const _DesignerHero(),
              const SizedBox(height: BBSpacing.md),
              CachedAsync<HomeDto>(
                value: home,
                onRetry: () => ref.invalidate(homeProvider),
                builder: (context, cached) =>
                    _HomeBody(home: cached.data, offline: cached.offline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const new({required this.area});

  final String? area;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final flavor = ref.watch(appEnvProvider).flavor;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.appTitle, style: BBText.wordmark),
              // Testers can tell a dev or staging build at a glance.
              if (flavor != AppFlavor.prod)
                BBBadge(
                  label: l10n.environmentBadge(flavor.name),
                  tone: BBBadgeTone.amber,
                ),
              if (area != null && area!.isNotEmpty)
                Row(
                  children: [
                    const BBIcon(
                      BBIcons.pin,
                      size: 14,
                      color: BBColors.textMuted,
                    ),
                    const SizedBox(width: BBSpacing.xs),
                    Flexible(
                      child: Text(
                        l10n.homeDeliveryTo(area!),
                        style: BBText.xs.muted,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const CurrencySwitch(),
      ],
    );
  }
}

class _DesignerHero extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BBCard(
      color: BBColors.primary,
      borderColor: BBColors.primary,
      onTap: () => context.go(Routes.designer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const BBIcon(
                BBIcons.sparkle,
                size: 16,
                color: BBColors.onPrimary,
              ),
              const SizedBox(width: BBSpacing.xs),
              Text(
                l10n.homeDesignerEyebrow,
                style: BBText.eyebrow.copyWith(color: BBColors.onPrimary),
              ),
            ],
          ),
          const SizedBox(height: BBSpacing.sm),
          Text(
            l10n.homeDesignerTitle,
            style: BBText.h2.copyWith(color: BBColors.onPrimary),
          ),
          const SizedBox(height: BBSpacing.xs),
          Text(
            l10n.homeDesignerBody,
            style: BBText.small.copyWith(color: BBColors.onPrimary),
          ),
          const SizedBox(height: BBSpacing.md),
          BBButton(
            label: l10n.homeDesignerCta,
            variant: BBButtonVariant.onPrimary,
            trailing: BBIcons.forward,
            small: true,
            onPressed: () => context.go(Routes.designer),
          ),
        ],
      ),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const new({required this.home, required this.offline});

  final HomeDto home;
  final bool offline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final branch = home.branch;
    final whatsapp = branch.whatsapp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (offline) ...[const OfflineBanner(), const SizedBox(height: 12)],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _QuickAction(
                icon: BBIcons.bag,
                title: l10n.homeOrderNow,
                subtitle: l10n.homeOrderNowSub,
                onTap: () => context.go(Routes.shop),
              ),
            ),
            const SizedBox(width: BBSpacing.sm),
            Expanded(
              child: _QuickAction(
                icon: BBIcons.whatsapp,
                title: l10n.homeWhatsapp,
                subtitle: l10n.homeWhatsappSub,
                onTap: whatsapp == null
                    ? null
                    : () => ref
                          .read(externalLinksProvider)
                          .open(ExternalLinks.whatsapp(whatsapp)),
              ),
            ),
            const SizedBox(width: BBSpacing.sm),
            Expanded(child: _OpenStatus(status: branch.status)),
          ],
        ),
        const SizedBox(height: BBSpacing.section),
        BBSectionHeader(title: l10n.homeCategories),
        const SizedBox(height: BBSpacing.sm),
        ChipStrip(
          children: [
            for (final c in home.categories)
              _CategoryChip(category: c, onTap: () => _openCategory(ref, c)),
          ],
        ),
        const _OccasionStrip(),
        if (home.today.isNotEmpty) ...[
          const SizedBox(height: BBSpacing.section),
          BBSectionHeader(
            title: l10n.homeTodayTitle,
            subtitle: l10n.homeTodaySub,
            actionLabel: l10n.seeAll,
            onAction: () => context.push(Routes.today),
          ),
          const SizedBox(height: BBSpacing.sm),
          _Carousel(products: home.today),
        ],
        if (home.cakes.isNotEmpty) ...[
          const SizedBox(height: BBSpacing.section),
          BBSectionHeader(
            title: l10n.homeCakesTitle,
            subtitle: l10n.homeCakesSub,
            actionLabel: l10n.seeAll,
            onAction: () {
              ref.read(shopQueryProvider.notifier).category('cakes');
              context.go(Routes.shop);
            },
          ),
          const SizedBox(height: BBSpacing.sm),
          _Carousel(products: home.cakes),
        ],
        const SizedBox(height: BBSpacing.section),
        BranchSummaryCard(branch: branch),
      ],
    );
  }

  void _openCategory(WidgetRef ref, CategoryDto category) {
    ref.read(shopQueryProvider.notifier).category(category.slug);
    GoRouter.of(ref.context).go(Routes.shop);
  }
}

/// Occasion pages (screen 11, FR-CAT-11). Not in the home design, which
/// leaves no other way to reach them before notifications and banners.
class _OccasionStrip extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final occasions = ref.watch(catalogFiltersProvider).value?.data.occasions;
    if (occasions == null || occasions.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: BBSpacing.sm),
      child: ChipStrip(
        children: [
          for (final o in occasions)
            ActionChipLike(
              icon: BBIcons.gift,
              label: o.name.of(context),
              onTap: () => context.push(Routes.occasion(o.slug)),
            ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final BBIcons icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1,
      child: BBCard(
        padding: const EdgeInsets.all(BBSpacing.gutter),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BBIconBox(icon, size: 36),
            const SizedBox(height: BBSpacing.sm),
            Text(title, style: BBText.small.bold),
            Text(subtitle, style: BBText.xs.muted),
          ],
        ),
      ),
    );
  }
}

/// "مفتوح الآن · حتى 24:00" (FR-ADM-12).
class _OpenStatus extends StatelessWidget {
  const new({required this.status});

  final ShopStatusDto status;

  @override
  Widget build(BuildContext context) {
    final (title, detail) = shopStatusText(
      AppLocalizations.of(context),
      status,
    );
    return BBCard(
      padding: const EdgeInsets.all(BBSpacing.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BBIconBox(
            BBIcons.clock,
            size: 36,
            tone: status.openNow ? BBTone.sage : BBTone.blush,
          ),
          const SizedBox(height: BBSpacing.sm),
          Text(title, style: BBText.small.bold),
          Text(detail, style: BBText.xs.muted.merge(BBText.numeric)),
        ],
      ),
    );
  }
}

/// Title and detail for the shop's open state.
(String, String) shopStatusText(AppLocalizations l10n, ShopStatusDto status) {
  if (status.openNow) {
    final title = status.mode == ShopStatusDtoMode.busy
        ? l10n.shopBusyNow
        : l10n.shopOpenNow;
    return (title, l10n.shopUntil(status.closesAt));
  }
  return (l10n.shopClosedNow, l10n.shopOpensAt(status.opensAt));
}

class _CategoryChip extends StatelessWidget {
  const new({required this.category, required this.onTap});

  final CategoryDto category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = BBIcons.values.asNameMap()[category.icon] ?? BBIcons.grid;
    return ActionChipLike(
      icon: icon,
      label: category.name.of(context),
      onTap: onTap,
    );
  }
}

/// A rounded category button with an icon (screen 06).
class ActionChipLike extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final BBIcons icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BBCard(
      padding: const EdgeInsets.symmetric(
        horizontal: BBSpacing.md,
        vertical: BBSpacing.sm,
      ),
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 32),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BBIcon(icon, size: 18, color: BBColors.primary),
            const SizedBox(width: BBSpacing.sm),
            Text(label, style: BBText.small.bold),
          ],
        ),
      ),
    );
  }
}

class _Carousel extends StatelessWidget {
  const new({required this.products});

  final List<ProductCardDto> products;

  @override
  Widget build(BuildContext context) {
    // A few cards only (the API sends up to six), so a plain row is fine;
    // IntrinsicHeight makes every card as tall as the tallest one, at any
    // text size.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (i, product) in products.indexed) ...[
              if (i > 0) const SizedBox(width: BBSpacing.gutter),
              SizedBox(
                width: 170,
                child: ProductCard(product: product, imageHeight: 140),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Branch, hours and quick contact (bottom of screen 06; screen 34 has more).
class BranchSummaryCard extends ConsumerWidget {
  const new({required this.branch, super.key});

  final BranchDto branch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final links = ref.read(externalLinksProvider);
    final lat = branch.latitude;
    final lng = branch.longitude;
    final whatsapp = branch.whatsapp;
    final instagram = branch.instagram;

    return BBCard(
      onTap: () => context.push(Routes.branch),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const BBIconBox(BBIcons.store),
              const SizedBox(width: BBSpacing.gutter),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(branch.name.of(context), style: BBText.bodyBold),
                    Text(branch.address.of(context), style: BBText.xs.muted),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: BBSpacing.gutter),
          BBKvRow(
            label: l10n.branchHoursLabel,
            value: l10n.branchHoursDaily(
              branch.status.opensAt,
              branch.status.closesAt,
            ),
          ),
          const SizedBox(height: BBSpacing.sm),
          Wrap(
            spacing: BBSpacing.sm,
            runSpacing: BBSpacing.sm,
            children: [
              if (lat != null && lng != null)
                BBButton(
                  label: l10n.branchMap,
                  leading: BBIcons.pin,
                  small: true,
                  variant: BBButtonVariant.secondary,
                  onPressed: () => links.open(
                    ExternalLinks.maps(lat, lng, branch.name.of(context)),
                  ),
                ),
              if (whatsapp != null)
                BBButton(
                  label: l10n.homeWhatsapp,
                  leading: BBIcons.whatsapp,
                  small: true,
                  variant: BBButtonVariant.secondary,
                  onPressed: () => links.open(ExternalLinks.whatsapp(whatsapp)),
                ),
              if (instagram != null)
                BBButton(
                  label: l10n.branchInstagram,
                  leading: BBIcons.instagram,
                  small: true,
                  variant: BBButtonVariant.secondary,
                  onPressed: () =>
                      links.open(ExternalLinks.instagram(instagram)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
