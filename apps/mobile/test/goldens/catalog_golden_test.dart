@Tags(['golden'])
// goldenTest registers the test synchronously; its Future is only for chaining.
// ignore_for_file: discarded_futures
library;

import 'package:alchemist/alchemist.dart';
import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/preferences.dart';
import 'package:belle_biens/app/theme/bb_theme.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fixture_server.dart';

/// Product cards (screens 06, 07, 11, 32) in both directions, with the
/// badges customers see: today only, seasonal and limited, "from" price,
/// and not available today.
Widget _frame(Locale locale, Widget child) => ProviderScope(
  overrides: [
    appPreferencesProvider.overrideWithValue(
      AppPreferences(MemoryPreferencesBackend()),
    ),
  ],
  child: Localizations(
    locale: locale,
    delegates: AppLocalizations.localizationsDelegates,
    child: Theme(
      data: BBTheme.light(),
      child: Directionality(
        textDirection: locale.languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Container(
          width: 360,
          color: const Color(0xFFFFF8F6),
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    ),
  ),
);

List<ProductCardDto> _cards() {
  final items = ((FixtureServer.fixture('products')! as Map)['items'] as List)
      .map((j) => ProductCardDto.fromJson(Map<String, Object?>.from(j as Map)))
      .toList();
  ProductCardDto bySlug(String slug) => items.firstWhere((c) => c.slug == slug);
  return [
    bySlug('red-rose-bouquet'),
    bySlug('spring-peony-bouquet'),
    bySlug('rose-pistachio-cake'),
    bySlug('iced-rose-matcha-latte')
        .copyWith(available: false, badges: [ProductBadge.unavailable]),
  ];
}

void main() {
  for (final (name, locale) in const [
    ('rtl', Locale('ar')),
    ('ltr', Locale('en')),
  ]) {
    goldenTest(
      'product cards ($name)',
      fileName: 'product_cards_$name',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'grid',
            child: _frame(locale, ProductGrid(products: _cards())),
          ),
          GoldenTestScenario(
            name: 'row',
            child: _frame(locale, ProductRow(product: _cards().first)),
          ),
        ],
      ),
    );
  }
}
