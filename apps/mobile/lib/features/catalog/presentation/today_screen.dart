import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen 10: today's products and the stems the designer can use today
/// (FR-DLY-01..05). The server drops yesterday's list at midnight.
class TodayScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final daily = ref.watch(dailyFlowersProvider);
    final money = ref.watch(moneyFormatProvider);

    return Scaffold(
      appBar: BBTopBar(
        title: l10n.homeTodayTitle,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(dailyFlowersProvider.future),
        child: ListView(
          padding: const EdgeInsets.all(BBSpacing.page),
          children: [
            BBNotice(text: l10n.todayNotice, icon: BBIcons.clock),
            const SizedBox(height: BBSpacing.md),
            CachedAsync<DailyFlowersDto>(
              value: daily,
              onRetry: () => ref.invalidate(dailyFlowersProvider),
              builder: (context, cached) {
                final data = cached.data;
                final flowers = data.stems
                    .where((s) => s.type2 == DesignerItemType.flower)
                    .toList();
                final greens = data.stems
                    .where((s) => s.type2 != DesignerItemType.flower)
                    .toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (cached.offline) ...[
                      const OfflineBanner(),
                      const SizedBox(height: BBSpacing.gutter),
                    ],
                    if (data.products.isEmpty && data.stems.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(BBSpacing.lg),
                        child: Text(
                          l10n.todayEmpty,
                          style: BBText.body.muted,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    for (final p in data.products) ...[
                      ProductRow(
                        product: p,
                        detail: p.stockLeft == null
                            ? l10n.todayAvailable
                            : l10n.todayLeft(p.stockLeft!),
                      ),
                      const SizedBox(height: BBSpacing.sm),
                    ],
                    if (data.stems.isNotEmpty) ...[
                      const SizedBox(height: BBSpacing.md),
                      BBSectionHeader(title: l10n.todayStemsTitle),
                      const SizedBox(height: BBSpacing.sm),
                      Wrap(
                        spacing: BBSpacing.sm,
                        runSpacing: BBSpacing.sm,
                        children: [
                          // Flowers show how many stems are left; greens
                          // are plentiful, so only their names.
                          for (final s in flowers)
                            _StemChip(
                              stem: s,
                              label: l10n.todayStem(
                                s.name.of(context),
                                money.count(s.quantity),
                              ),
                            ),
                          for (final s in greens)
                            _StemChip(stem: s, label: s.name.of(context)),
                        ],
                      ),
                      const SizedBox(height: BBSpacing.lg),
                      BBButton(
                        label: l10n.todayDesignCta,
                        leading: BBIcons.flower,
                        expand: true,
                        onPressed: () => context.go(Routes.designer),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StemChip extends StatelessWidget {
  const new({required this.stem, required this.label});

  final DailyStemDto stem;
  final String label;

  @override
  Widget build(BuildContext context) {
    final swatch = stem.swatch;
    return Container(
      constraints: const BoxConstraints(minHeight: 36),
      padding: const EdgeInsets.symmetric(
        horizontal: BBSpacing.gutter,
        vertical: BBSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: BBColors.surface,
        borderRadius: BorderRadius.circular(BBRadius.pill),
        border: Border.all(color: BBColors.borderStrong),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (swatch != null) ...[
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _parseHex(swatch),
                shape: BoxShape.circle,
                border: Border.all(color: BBColors.borderStrong),
              ),
            ),
            const SizedBox(width: BBSpacing.sm),
          ],
          Text(label, style: BBText.small.merge(BBText.numeric)),
          if (stem.limited) ...[
            const SizedBox(width: BBSpacing.xs),
            const BBIcon(BBIcons.warning, size: 14, color: BBColors.onAmber),
          ],
        ],
      ),
    );
  }
}

Color _parseHex(String hex) {
  final value = int.tryParse(hex.replaceFirst('#', ''), radix: 16) ?? 0xFFFFFF;
  return Color(0xFF000000 | value);
}

/// Swatch color from the API ("#7A1F3D").
Color swatchColor(String hex) => _parseHex(hex);
