import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen 08: search as you type (Arabic-aware, FR-CAT-04), tabs per
/// category, and recent searches.
class SearchScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _debounce = Debouncer(const Duration(milliseconds: 350));
  String _query = '';
  String? _category;

  @override
  void dispose() {
    _debounce.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String text) => _debounce.run(() {
    if (!mounted) return;
    setState(() {
      _query = text.trim();
      _category = null;
    });
  });

  void _submit(String text) {
    final q = text.trim();
    setState(() {
      _query = q;
      _category = null;
    });
    ref.read(recentSearchesProvider.notifier).add(q);
  }

  void _useRecent(String q) {
    _controller.text = q;
    _submit(q);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: BBTopBar(
        title: l10n.navShop,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(BBSpacing.page),
        children: [
          BBTextField(
            label: l10n.shopSearchHint,
            hint: l10n.homeSearchHint,
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            prefix: const BBIcon(BBIcons.search, color: BBColors.textMuted),
            onChanged: _onChanged,
            onSubmitted: _submit,
          ),
          const SizedBox(height: BBSpacing.md),
          if (_query.isEmpty)
            _RecentSearches(onTap: _useRecent)
          else
            _Results(
              query: _query,
              category: _category,
              onCategory: (c) => setState(() => _category = c),
              onOpen: () =>
                  ref.read(recentSearchesProvider.notifier).add(_query),
            ),
        ],
      ),
    );
  }
}

class _RecentSearches extends ConsumerWidget {
  const new({required this.onTap});

  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recent = ref.watch(recentSearchesProvider);
    if (recent.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(l10n.searchRecent, style: BBText.label)),
            BBLink(
              label: l10n.searchClear,
              onPressed: ref.read(recentSearchesProvider.notifier).clear,
            ),
          ],
        ),
        const SizedBox(height: BBSpacing.sm),
        Wrap(
          spacing: BBSpacing.sm,
          runSpacing: BBSpacing.sm,
          children: [
            for (final q in recent)
              BBChip(
                label: q,
                icon: BBIcons.clock,
                selected: false,
                onTap: () => onTap(q),
              ),
          ],
        ),
      ],
    );
  }
}

class _Results extends ConsumerWidget {
  const new({
    required this.query,
    required this.category,
    required this.onCategory,
    required this.onOpen,
  });

  final String query;
  final String? category;
  final ValueChanged<String?> onCategory;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final result = ref.watch(searchProvider(query));
    final categories = <String, LocalizedTextDto>{
      for (final c
          in ref.watch(homeProvider).value?.data.categories ??
              const <CategoryDto>[])
        c.slug: c.name,
    };

    return CachedAsync(
      value: result,
      onRetry: () => ref.invalidate(searchProvider(query)),
      builder: (context, cached) {
        final data = cached.data;
        final items = category == null
            ? data.items
            : data.items.where((c) => c.categorySlug == category).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (cached.offline) ...[
              BBNotice(
                text: l10n.searchOfflineNote,
                tone: BBNoticeTone.warn,
                icon: BBIcons.wifiOff,
              ),
              const SizedBox(height: BBSpacing.gutter),
            ],
            if (data.total == 0)
              Padding(
                padding: const EdgeInsets.all(BBSpacing.lg),
                child: Text(
                  l10n.searchNoResults(query),
                  style: BBText.body.muted,
                  textAlign: TextAlign.center,
                ),
              )
            else ...[
              ChipStrip(
                children: [
                  BBChip(
                    label: l10n.searchTab(l10n.shopAll, data.total),
                    selected: category == null,
                    onTap: () => onCategory(null),
                  ),
                  for (final f in data.facets)
                    BBChip(
                      label: l10n.searchTab(
                        (categories[f.categorySlug] ?? f.name).of(context),
                        f.count,
                      ),
                      selected: category == f.categorySlug,
                      onTap: () => onCategory(f.categorySlug),
                    ),
                ],
              ),
              const SizedBox(height: BBSpacing.gutter),
              for (final item in items) ...[
                Listener(
                  onPointerUp: (_) => onOpen(),
                  child: ProductRow(
                    product: item,
                    detail: categories[item.categorySlug]?.of(context),
                  ),
                ),
                const SizedBox(height: BBSpacing.sm),
              ],
            ],
          ],
        );
      },
    );
  }
}
