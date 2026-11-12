import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen 39: the shop is busy or closed (FR-ADM-12). Shown on home, the
/// shop and checkout; nothing when the shop is open.
class ShopModeNotice extends ConsumerWidget {
  const new({super.key, this.bottomGap = BBSpacing.md});

  final double bottomGap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shop = ref.watch(appConfigProvider).value?.shop;
    if (shop == null || shop.mode == ShopConfigDtoMode.open) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final busy = shop.mode == ShopConfigDtoMode.busy;
    final message = shop.message;
    final custom = message == null
        ? null
        : LocalizedTextDto(ar: message.ar, en: message.en).of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: bottomGap),
      child: Semantics(
        container: true,
        liveRegion: true,
        child: BBCard(
          color: BBColors.amber,
          borderColor: BBColors.noticeWarnBorder,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BBIcon(BBIcons.clock, color: BBColors.onAmber),
              const SizedBox(width: BBSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      busy ? l10n.shopBusyTitle : l10n.shopClosedTitle,
                      style: BBText.bodyBold.copyWith(color: BBColors.onAmber),
                    ),
                    const SizedBox(height: BBSpacing.xs),
                    Text(
                      busy && shop.acceptsFrom != null
                          ? l10n.shopBusyBody(shop.acceptsFrom!)
                          : l10n.shopClosedBody,
                      style: BBText.small.copyWith(color: BBColors.onAmber),
                    ),
                    if (custom != null && custom.isNotEmpty) ...[
                      const SizedBox(height: BBSpacing.xs),
                      Text(custom, style: BBText.xs.muted),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
