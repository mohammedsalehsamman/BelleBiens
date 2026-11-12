import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/launch/external_links.dart';
import 'package:belle_biens/core/money/money.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/today_screen.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:belle_biens/features/designer/application/designer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The customer's choices on a product page: option keys per group.
class OptionChoice {
  const new(this.selected);

  /// Defaults chosen, as the page opens.
  factory defaults(List<ProductOptionGroupDto> groups) => OptionChoice({
    for (final g in groups)
      g.key: {
        for (final o in g.options)
          if (o.isDefault) o.key,
      },
  });

  final Map<String, Set<String>> selected;

  OptionChoice pick(ProductOptionGroupDto group, String option) {
    final current = selected[group.key] ?? const <String>{};
    final next = group.selection == OptionSelection.single
        ? {option}
        : (current.contains(option)
              ? ({...current}..remove(option))
              : {...current, option});
    return OptionChoice({...selected, group.key: next});
  }

  bool isSelected(String group, String option) =>
      selected[group]?.contains(option) ?? false;

  /// The price shown on the page for one piece: the card price minus the
  /// default options plus the chosen ones. The cart asks the server for the
  /// real price (NFR-SEC-06); this is only what the customer sees while
  /// choosing.
  int unitPrice(ProductDetailDto product) {
    var price = product.priceMinor;
    for (final g in product.optionGroups) {
      for (final o in g.options) {
        if (o.isDefault) price -= o.priceChangeMinor;
        if (isSelected(g.key, o.key)) price += o.priceChangeMinor;
      }
    }
    return price;
  }
}

/// Screens 12 (bouquet), 13 (cake, options grow in S4) and 14 (drink).
class ProductScreen extends ConsumerWidget {
  const new({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productProvider(slug));
    final data = product.value?.data;
    return Scaffold(
      appBar: BBTopBar(
        title: data?.category.name.of(context) ?? '',
        onBack: () => Navigator.of(context).maybePop(),
        action: data == null ? null : _FavoriteButton(product: data),
      ),
      body: CachedAsync<ProductDetailDto>(
        value: product,
        onRetry: () => ref.invalidate(productProvider(slug)),
        builder: (context, cached) =>
            _ProductBody(product: cached.data, offline: cached.offline),
      ),
    );
  }
}

class _ProductBody extends ConsumerStatefulWidget {
  const new({required this.product, required this.offline});

  final ProductDetailDto product;
  final bool offline;

  @override
  ConsumerState<_ProductBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends ConsumerState<_ProductBody> {
  late OptionChoice _choice = OptionChoice.defaults(
    widget.product.optionGroups,
  );
  int _quantity = 1;

  ProductDetailDto get _p => widget.product;

  /// FR-CAT-07: this bouquet's spec becomes the design (undo returns to the
  /// previous draft).
  Future<void> _customize() async {
    final template = _p.designerTemplate?.additionalProperties;
    if (template != null) {
      await ref.read(designerControllerProvider.notifier).startFrom(template);
    }
    if (mounted) context.go(Routes.designer);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final whatsapp = ref.watch(branchProvider).value?.data.whatsapp;
    final unit = _choice.unitPrice(_p);
    final name = _p.name.of(context);
    final isBouquet = _p.kind == ProductKind.bouquet;
    final size = _p.optionGroups.where((g) => g.key == 'size').firstOrNull;
    final chosenSize = size?.options
        .where((o) => _choice.isSelected(size.key, o.key))
        .firstOrNull;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(BBSpacing.page),
            children: [
              if (widget.offline) ...[
                const OfflineBanner(),
                const SizedBox(height: BBSpacing.gutter),
              ],
              _Gallery(product: _p),
              const SizedBox(height: BBSpacing.md),
              if (_p.badges.isNotEmpty) ...[
                ProductBadges(_p.badges, max: 3),
                const SizedBox(height: BBSpacing.sm),
              ],
              Text(
                isBouquet && _p.customizable
                    ? l10n.productReadyBouquet
                    : _p.category.name.of(context),
                style: BBText.eyebrow,
              ),
              Semantics(header: true, child: Text(name, style: BBText.h1)),
              if (_p.description.of(context).isNotEmpty) ...[
                const SizedBox(height: BBSpacing.xs),
                Text(_p.description.of(context), style: BBText.body.muted),
              ],
              const SizedBox(height: BBSpacing.gutter),
              PriceLines(priceMinor: unit, large: true, inline: true),
              if (chosenSize != null)
                Text(
                  l10n.productSelected(
                    size!.name.of(context),
                    chosenSize.name.of(context),
                  ),
                  style: BBText.xs.muted,
                ),
              if (!_p.available) ...[
                const SizedBox(height: BBSpacing.gutter),
                BBNotice(
                  text: l10n.productUnavailable,
                  tone: BBNoticeTone.warn,
                ),
              ],
              if (_p.customizable) ...[
                const SizedBox(height: BBSpacing.md),
                _CustomizeCard(onTap: _customize),
              ],
              for (final group in _p.optionGroups) ...[
                const SizedBox(height: BBSpacing.section),
                _OptionGroup(
                  group: group,
                  basePrice: _p.priceMinor,
                  choice: _choice,
                  money: money,
                  onPick: (key) =>
                      setState(() => _choice = _choice.pick(group, key)),
                ),
              ],
              if (_p.allergens.isNotEmpty) ...[
                const SizedBox(height: BBSpacing.md),
                BBNotice(
                  text: l10n.productAllergens(
                    _p.allergens.map((a) => allergenName(l10n, a)).join('، '),
                  ),
                  icon: BBIcons.info,
                ),
              ],
              const SizedBox(height: BBSpacing.section),
              _DeliveryCard(product: _p),
              if (isBouquet) ...[
                const SizedBox(height: BBSpacing.gutter),
                Text(l10n.productDisclaimer, style: BBText.xs.muted),
              ],
              if (_p.pairings.isNotEmpty) ...[
                const SizedBox(height: BBSpacing.section),
                BBSectionHeader(
                  title: _p.kind == ProductKind.drink
                      ? l10n.productPairingsDrink
                      : l10n.productPairingsGift,
                ),
                const SizedBox(height: BBSpacing.sm),
                for (final pairing in _p.pairings) ...[
                  ProductRow(product: pairing),
                  const SizedBox(height: BBSpacing.sm),
                ],
              ],
              if (whatsapp != null) ...[
                const SizedBox(height: BBSpacing.md),
                BBListGroup(
                  children: [
                    BBListTile(
                      title: l10n.productAskTitle,
                      subtitle: l10n.productAskBody,
                      leading: const BBIconBox(BBIcons.whatsapp, size: 36),
                      onTap: () => ref
                          .read(externalLinksProvider)
                          .open(ExternalLinks.whatsapp(whatsapp, text: name)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        BBBottomCta(
          children: [
            BBQtyStepper(
              value: _quantity,
              min: 1,
              max: _p.stockLeft?.clamp(1, 99) ?? 99,
              itemLabel: name,
              onChanged: (v) => setState(() => _quantity = v),
            ),
            Expanded(
              child: BBButton(
                label: l10n.productAddWithTotal(
                  money.primary(unit * _quantity),
                ),
                leading: BBIcons.bag,
                expand: true,
                onPressed: _p.available
                    ? () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.productCartSoon)),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

String allergenName(AppLocalizations l10n, String key) => switch (key) {
  'nuts' => l10n.allergenNuts,
  'milk' => l10n.allergenMilk,
  'eggs' => l10n.allergenEggs,
  'gluten' => l10n.allergenGluten,
  _ => key,
};

class _Gallery extends StatefulWidget {
  const new({required this.product});

  final ProductDetailDto product;

  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final name = p.name.of(context);
    final urls = p.images.isEmpty
        ? <String?>[p.imageUrl]
        : p.images.map((i) => i.url).toList();
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            itemCount: urls.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) =>
                ProductImage(url: urls[i], kind: p.kind, label: name),
          ),
        ),
        if (urls.length > 1) ...[
          const SizedBox(height: BBSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < urls.length; i++)
                Container(
                  width: i == _page ? 18 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i == _page ? BBColors.primary : BBColors.track,
                    borderRadius: BorderRadius.circular(BBRadius.pill),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _CustomizeCard extends StatelessWidget {
  const new({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BBCard(
      color: BBColors.surfaceLow,
      borderColor: BBColors.noticeInfoBorder,
      child: Row(
        children: [
          const BBIconBox(BBIcons.sparkle),
          const SizedBox(width: BBSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.productCustomizeTitle, style: BBText.bodyBold),
                Text(l10n.productCustomizeBody, style: BBText.xs.muted),
              ],
            ),
          ),
          const SizedBox(width: BBSpacing.sm),
          BBButton(
            label: l10n.productCustomize,
            small: true,
            variant: BBButtonVariant.soft,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}

class _OptionGroup extends StatelessWidget {
  const new({
    required this.group,
    required this.basePrice,
    required this.choice,
    required this.money,
    required this.onPick,
  });

  final ProductOptionGroupDto group;
  final int basePrice;
  final OptionChoice choice;
  final MoneyFormat money;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final allIncluded = group.options.every((o) => o.priceChangeMinor == 0);
    final defaultChange = group.options
        .where((o) => o.isDefault)
        .fold<int>(0, (sum, o) => sum + o.priceChangeMinor);
    final isSize = group.key == 'size';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: BBSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Semantics(
              header: true,
              child: Text(group.name.of(context), style: BBText.h3),
            ),
            if (allIncluded && group.options.length > 1)
              Text(l10n.productIncluded, style: BBText.xs.muted),
          ],
        ),
        const SizedBox(height: BBSpacing.sm),
        for (final option in group.options) ...[
          BBOptionTile(
            title: option.name.of(context),
            subtitle: option.detail.of(context).isEmpty
                ? null
                : option.detail.of(context),
            selected: choice.isSelected(group.key, option.key),
            multiple: group.selection == OptionSelection.multiple,
            onTap: () => onPick(option.key),
            trailing: _trailing(
              l10n,
              option,
              isSize: isSize,
              sizePrice: basePrice - defaultChange + option.priceChangeMinor,
              allIncluded: allIncluded,
            ),
          ),
          const SizedBox(height: BBSpacing.sm),
        ],
      ],
    );
  }

  Widget? _trailing(
    AppLocalizations l10n,
    ProductOptionDto option, {
    required bool isSize,
    required int sizePrice,
    required bool allIncluded,
  }) {
    final swatch = option.swatch;
    if (swatch != null) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: swatchColor(swatch),
          shape: BoxShape.circle,
          border: Border.all(color: BBColors.borderStrong),
        ),
      );
    }
    // Sizes show the full price ("1,800"); other choices show the change.
    final text = isSize
        ? money.primary(sizePrice)
        : option.priceChangeMinor == 0
        ? (allIncluded ? null : l10n.optionIncluded)
        : money.change(option.priceChangeMinor);
    if (text == null) return null;
    return Text(text, style: BBText.small.bold.merge(BBText.numeric));
  }
}

class _DeliveryCard extends StatelessWidget {
  const new({required this.product});

  final ProductDetailDto product;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final days = product.earliestDeliveryInDays;
    final when = switch (days) {
      0 => l10n.whenToday,
      1 => l10n.whenTomorrow,
      _ => l10n.whenInDays(days),
    };
    return BBCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const BBIcon(BBIcons.truck, color: BBColors.primary),
              const SizedBox(width: BBSpacing.sm),
              Expanded(
                child: Text(l10n.productEarliest(when), style: BBText.bodyBold),
              ),
            ],
          ),
          if (product.leadTimeHours > 0)
            Text(
              l10n.productLeadTime(product.leadTimeHours),
              style: BBText.xs.muted,
            ),
          const SizedBox(height: BBSpacing.xs),
          Text(l10n.productDeliveryNote, style: BBText.small.muted),
          BBLink(
            label: l10n.productDeliveryPolicy,
            onPressed: () => context.push(Routes.page('delivery')),
          ),
        ],
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  const new({required this.product});

  final ProductDetailDto product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final favorites = ref.watch(favoritesProvider);
    final saved =
        favorites.value?.any((c) => c.slug == product.slug) ??
        product.isFavorite;
    return Semantics(
      selected: saved,
      child: BBIconButton(
        icon: BBIcons.heart,
        tooltip: saved ? l10n.productFavoriteRemove : l10n.productFavoriteAdd,
        onPressed: () => _toggle(context, ref),
      ),
    );
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (ref.read(sessionControllerProvider).value == null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.favoriteSignIn),
          action: SnackBarAction(
            label: l10n.onboardingSignIn,
            onPressed: () => context.push(Routes.login),
          ),
        ),
      );
      return;
    }
    try {
      await ref.read(favoritesProvider.notifier).toggle(toCard(product));
    } on Object catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l10n, error))));
    }
  }
}

/// The card form of a product page, for the favorites list.
ProductCardDto toCard(ProductDetailDto p) => ProductCardDto(
  id: p.id,
  slug: p.slug,
  kind: p.kind,
  categorySlug: p.categorySlug,
  name: p.name,
  subtitle: p.subtitle,
  imageUrl: p.imageUrl,
  priceMinor: p.priceMinor,
  priceFrom: p.priceFrom,
  available: p.available,
  badges: p.badges,
  stockLeft: p.stockLeft,
  leadTimeHours: p.leadTimeHours,
);
