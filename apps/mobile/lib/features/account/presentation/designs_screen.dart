import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/account/application/account_providers.dart';
import 'package:belle_biens/features/account/data/account_repository.dart';
import 'package:belle_biens/features/account/presentation/occasions_screen.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:belle_biens/features/designer/application/designer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen 30: saved designs at today's prices (FR-DSG-12).
class DesignsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final designs = ref.watch(myDesignsProvider);
    return Scaffold(
      appBar: BBTopBar(
        title: l10n.accountDesigns,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: switch (designs) {
        AsyncValue(:final value?) => ListView(
          padding: const EdgeInsets.all(BBSpacing.page),
          children: [
            if (value.isEmpty)
              BBNotice(text: l10n.designsEmpty, icon: BBIcons.flower),
            for (final d in value) ...[
              _DesignCard(design: d),
              const SizedBox(height: BBSpacing.gutter),
            ],
            BBButton(
              label: l10n.designsNew,
              leading: BBIcons.plus,
              variant: BBButtonVariant.secondary,
              expand: true,
              onPressed: () async {
                await ref.read(designerControllerProvider.notifier).restart();
                if (context.mounted) context.go(Routes.designer);
              },
            ),
            const SizedBox(height: BBSpacing.md),
            Text(
              l10n.designsPriceNote,
              style: BBText.xs.muted,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        AsyncError(:final error) => ErrorRetry(
          error: error,
          onRetry: () => ref.invalidate(myDesignsProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _DesignCard extends ConsumerWidget {
  const new({required this.design});

  final SavedDesignDto design;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final d = design;
    final summary = [
      l10n.designsStems(d.stems),
      ?d.wrap?.of(context),
    ].join(' · ');

    Future<void> remove() async {
      final messenger = ScaffoldMessenger.of(context);
      final sure = await confirmDialog(
        context,
        l10n.designsDeleteAsk(d.name),
        l10n.addressesDelete,
      );
      if (!sure) return;
      try {
        await ref.read(accountRepositoryProvider).deleteDesign(d.id);
        ref.invalidate(myDesignsProvider);
      } on Object catch (error) {
        messenger.showSnackBar(SnackBar(content: Text(errorText(l10n, error))));
      }
    }

    return BBCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(BBRadius.thumb),
            child: SizedBox.square(
              dimension: 72,
              child: d.previewUrl == null
                  ? Semantics(
                      label: l10n.designsPreview,
                      child: const ColoredBox(
                        color: BBColors.previewWash,
                        child: Center(
                          child: BBIcon(
                            BBIcons.flower,
                            color: BBColors.primary,
                          ),
                        ),
                      ),
                    )
                  : Image.network(
                      d.previewUrl!,
                      fit: BoxFit.cover,
                      semanticLabel: l10n.designsPreview,
                      errorBuilder: (_, _, _) =>
                          const ColoredBox(color: BBColors.previewWash),
                    ),
            ),
          ),
          const SizedBox(width: BBSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.name, style: BBText.bodyBold),
                Text(summary, style: BBText.xs.muted),
                const SizedBox(height: BBSpacing.xs),
                Text(
                  money.primary(d.priceMinor),
                  style: BBText.price.merge(BBText.numeric),
                ),
                if (!d.available)
                  Text(
                    l10n.designsUnavailable,
                    style: BBText.xs.copyWith(color: BBColors.noticeWarnText),
                  ),
              ],
            ),
          ),
          Column(
            children: [
              BBButton(
                label: l10n.designsOpen,
                small: true,
                onPressed: () async {
                  await ref
                      .read(designerControllerProvider.notifier)
                      .startFrom(designSpec(d));
                  if (context.mounted) context.go(Routes.designer);
                },
              ),
              BBIconButton(
                icon: BBIcons.trash,
                tooltip: l10n.addressesDelete,
                onPressed: remove,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The designer's "احفظ في تصاميمي" (FR-DSG-12): asks for a name, saves.
Future<void> saveDesignToAccount(
  BuildContext context,
  WidgetRef ref,
  Map<String, Object?> spec,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  if (ref.read(sessionControllerProvider).value == null) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.designSaveSignIn)));
    return;
  }
  final text = (await showDialog<String>(
    context: context,
    builder: (context) => const _NameDialog(),
  ))?.trim();
  if (text == null || text.isEmpty) return;
  try {
    await ref
        .read(accountRepositoryProvider)
        .saveDesign(name: text, spec: spec);
    ref.invalidate(myDesignsProvider);
    messenger.showSnackBar(SnackBar(content: Text(l10n.designSaved)));
  } on Object catch (error) {
    messenger.showSnackBar(SnackBar(content: Text(errorText(l10n, error))));
  }
}

/// Asks for the design's name; pops with it, or null.
class _NameDialog extends StatefulWidget {
  const new();

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      content: BBTextField(
        label: l10n.designSaveName,
        controller: _name,
        autofocus: true,
        maxLength: 60,
        onSubmitted: (v) => Navigator.of(context).pop(v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.trackCancelNo),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_name.text),
          child: Text(l10n.profileSave),
        ),
      ],
    );
  }
}
