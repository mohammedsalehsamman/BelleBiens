import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/money/money.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/data/catalog_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Text in the app's language, falling back to the other one when the shop
/// left a field empty (FR-LOC-04).
extension LocalizedTextX on LocalizedTextDto {
  String of(BuildContext context) {
    final english = Localizations.localeOf(context).languageCode == 'en';
    final first = english ? en : ar;
    return first.isNotEmpty ? first : (english ? ar : en);
  }
}

/// Product page path (plan 4.8: `/p/:slug`).
String productPath(String slug) => '/p/$slug';

/// The product photo, or a calm placeholder until the shop's photos arrive
/// (R-02). Also shown when a photo fails to load on a slow network.
class ProductImage extends StatelessWidget {
  const new({
    required this.url,
    required this.kind,
    required this.label,
    this.height,
    this.radius = BBRadius.card,
    super.key,
  });

  final String? url;
  final ProductKind kind;
  final String label;
  final double? height;
  final double radius;

  static BBIcons iconFor(ProductKind kind) => switch (kind) {
    ProductKind.bouquet => BBIcons.flower,
    ProductKind.cake || ProductKind.sweet => BBIcons.cake,
    ProductKind.drink => BBIcons.coffee,
    _ => BBIcons.gift,
  };

  @override
  Widget build(BuildContext context) {
    final placeholder = DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [BBColors.blush, BBColors.previewWash],
        ),
      ),
      child: Center(
        child: BBIcon(iconFor(kind), size: 36, color: BBColors.onBlush),
      ),
    );
    final image = url == null
        ? placeholder
        : Image.network(
            url!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => placeholder,
          );
    return Semantics(
      image: true,
      label: AppLocalizations.of(context).imagePlaceholder(label),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(height: height, width: double.infinity, child: image),
      ),
    );
  }
}

/// "2,400 ل.س" with "$20.00" below or beside it (screens 06-14).
class PriceLines extends ConsumerWidget {
  const new({
    required this.priceMinor,
    this.from = false,
    this.inline = false,
    this.large = false,
    super.key,
  });

  final int priceMinor;
  final bool from;
  final bool inline;
  final bool large;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final primaryText = from
        ? l10n.priceFrom(money.primary(priceMinor))
        : money.primary(priceMinor);
    final primary = Text(
      primaryText,
      style: (large ? BBText.price.copyWith(fontSize: 22) : BBText.price).merge(
        BBText.numeric,
      ),
    );
    final secondary = Text(
      large
          ? l10n.priceApprox(money.secondary(priceMinor))
          : money.secondary(priceMinor),
      style: BBText.xs.muted.merge(BBText.numeric),
    );
    if (inline) {
      return Wrap(
        spacing: BBSpacing.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [primary, secondary],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [primary, secondary],
    );
  }
}

/// Label and color for each product badge.
(String, BBBadgeTone) badgeStyle(AppLocalizations l10n, ProductBadge badge) =>
    switch (badge) {
      ProductBadge.bestSeller => (l10n.badgeBestSeller, BBBadgeTone.dark),
      ProductBadge.seasonal => (l10n.badgeSeasonal, BBBadgeTone.sage),
      ProductBadge.today => (l10n.badgeToday, BBBadgeTone.green),
      ProductBadge.todayOnly => (l10n.badgeTodayOnly, BBBadgeTone.blush),
      ProductBadge.limited => (l10n.badgeLimited, BBBadgeTone.amber),
      ProductBadge.unavailable => (l10n.badgeUnavailable, BBBadgeTone.gray),
    };

class ProductBadges extends StatelessWidget {
  const new(this.badges, {this.max = 2, super.key});

  final List<ProductBadge> badges;
  final int max;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shown = badges
        .map((b) => badgeStyle(l10n, b))
        .where((s) => s.$1.isNotEmpty)
        .take(max);
    return Wrap(
      spacing: BBSpacing.xs,
      runSpacing: BBSpacing.xs,
      children: [
        for (final (label, tone) in shown) BBBadge(label: label, tone: tone),
      ],
    );
  }
}

/// A product in a two-column grid (screens 07, 11, 32) or a home carousel.
class ProductCard extends StatelessWidget {
  const new({required this.product, this.imageHeight = 150, super.key});

  final ProductCardDto product;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    final name = product.name.of(context);
    final subtitle = product.subtitle.of(context);
    return BBCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push(productPath(product.slug)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ProductImage(
                url: product.imageUrl,
                kind: product.kind,
                label: name,
                height: imageHeight,
                radius: 0,
              ),
              if (product.badges.isNotEmpty)
                PositionedDirectional(
                  top: BBSpacing.sm,
                  start: BBSpacing.sm,
                  end: BBSpacing.sm,
                  child: ProductBadges(product.badges, max: 1),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(BBSpacing.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: BBText.bodyBold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: BBText.xs.muted,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: BBSpacing.xs),
                PriceLines(
                  priceMinor: product.priceMinor,
                  from: product.priceFrom,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A product as a row (screens 08, 10): photo, name, detail, price.
class ProductRow extends StatelessWidget {
  const new({required this.product, this.detail, super.key});

  final ProductCardDto product;

  /// Replaces the subtitle, e.g. "متبقٍ 8 باقات" on today's list.
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final name = product.name.of(context);
    return BBCard(
      padding: const EdgeInsets.all(BBSpacing.sm),
      onTap: () => context.push(productPath(product.slug)),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: ProductImage(
              url: product.imageUrl,
              kind: product.kind,
              label: name,
              radius: BBRadius.thumb,
            ),
          ),
          const SizedBox(width: BBSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.badges.isNotEmpty) ...[
                  ProductBadges(product.badges, max: 1),
                  const SizedBox(height: BBSpacing.xs),
                ],
                Text(name, style: BBText.bodyBold),
                Text(
                  detail ?? product.subtitle.of(context),
                  style: BBText.xs.muted,
                ),
              ],
            ),
          ),
          const SizedBox(width: BBSpacing.sm),
          PriceLines(priceMinor: product.priceMinor, from: product.priceFrom),
        ],
      ),
    );
  }
}

/// The ل.س / $ switch.
class CurrencySwitch extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // The segmented control fills its width; headers give it a fixed one.
    return SizedBox(
      width: 112,
      child: BBSegmented<DisplayCurrency>(
        dense: true,
        segments: [
          (DisplayCurrency.syp, l10n.currencySyp),
          (DisplayCurrency.usd, l10n.currencyUsd),
        ],
        selected: ref.watch(displayCurrencyProvider),
        onChanged: ref.read(displayCurrencyProvider.notifier).select,
      ),
    );
  }
}

/// Shown above content that came from the device, not the server (screen 39).
class OfflineBanner extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => BBNotice(
    text: AppLocalizations.of(context).offlineBanner,
    tone: BBNoticeTone.warn,
    icon: BBIcons.wifiOff,
  );
}

/// Loading, error with retry, or the content (with the offline bar when the
/// answer came from the device).
class CachedAsync<T> extends StatelessWidget {
  const new({
    required this.value,
    required this.builder,
    required this.onRetry,
    super.key,
  });

  final AsyncValue<Cached<T>> value;

  /// Gets the whole answer; `cached.offline` says it came from the device.
  final Widget Function(BuildContext context, Cached<T> cached) builder;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final data = value.value;
    if (data != null) return builder(context, data);
    if (value.hasError) {
      return ErrorRetry(error: value.error!, onRetry: onRetry);
    }
    return const Padding(
      padding: EdgeInsets.all(BBSpacing.xl),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class ErrorRetry extends StatelessWidget {
  const new({required this.error, required this.onRetry, super.key});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(BBSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BBNotice(text: errorText(l10n, error), tone: BBNoticeTone.error),
          const SizedBox(height: BBSpacing.md),
          BBButton(
            label: l10n.commonRetry,
            leading: BBIcons.refresh,
            variant: BBButtonVariant.secondary,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}

/// Two columns of product cards inside a scroll view.
class ProductGrid extends StatelessWidget {
  const new({required this.products, super.key});

  final List<ProductCardDto> products;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < products.length; i += 2) {
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: ProductCard(product: products[i])),
              const SizedBox(width: BBSpacing.gutter),
              Expanded(
                child: i + 1 < products.length
                    ? ProductCard(product: products[i + 1])
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, row) in rows.indexed) ...[
          if (i > 0) const SizedBox(height: BBSpacing.gutter),
          row,
        ],
      ],
    );
  }
}

/// A tappable search field that opens the search screen (screens 06, 07).
class SearchEntry extends StatelessWidget {
  const new({required this.hint, required this.onTap, super.key});

  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: hint,
      excludeSemantics: true,
      child: Material(
        color: BBColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BBRadius.pill),
          side: const BorderSide(color: BBColors.borderStrong),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: BBSizes.minTouch),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: BBSpacing.md),
              child: Row(
                children: [
                  const BBIcon(BBIcons.search, color: BBColors.textMuted),
                  const SizedBox(width: BBSpacing.sm),
                  Expanded(
                    child: Text(
                      hint,
                      style: BBText.small.muted,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal chips that scroll (category chips on screen 07).
class ChipStrip extends StatelessWidget {
  const new({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        for (final (i, chip) in children.indexed) ...[
          if (i > 0) const SizedBox(width: BBSpacing.sm),
          chip,
        ],
      ],
    ),
  );
}
