import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/account/application/account_providers.dart';
import 'package:belle_biens/features/account/presentation/occasions_screen.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:belle_biens/features/checkout/application/checkout_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen 29: saved addresses, the default first (FR-ACC-04).
class AddressesScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final addresses = ref.watch(myAddressesProvider);
    return Scaffold(
      appBar: BBTopBar(
        title: l10n.accountAddresses,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: switch (addresses) {
        AsyncValue(:final value?) => ListView(
          padding: const EdgeInsets.all(BBSpacing.page),
          children: [
            if (value.isEmpty)
              BBNotice(text: l10n.addressesEmpty, icon: BBIcons.pin),
            for (final a in value) ...[
              _AddressCard(address: a),
              const SizedBox(height: BBSpacing.gutter),
            ],
            BBButton(
              label: l10n.addressesAdd,
              leading: BBIcons.plus,
              variant: BBButtonVariant.secondary,
              expand: true,
              onPressed: () => context.push(Routes.newAddress),
            ),
            const SizedBox(height: BBSpacing.md),
            Text(
              l10n.addressesOutNote,
              style: BBText.xs.muted,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        AsyncError(:final error) => ErrorRetry(
          error: error,
          onRetry: () => ref.invalidate(myAddressesProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _AddressCard extends ConsumerWidget {
  const new({required this.address});

  final AddressDto address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final a = address;
    final zone = a.zone;
    final line = [
      ?zone?.name.of(context),
      a.details,
      a.building,
      a.floor,
    ].where((p) => p.isNotEmpty).join(' · ');
    final second = [
      if (a.landmark.isNotEmpty) a.landmark,
      if (a.callBeforeArrival) l10n.checkoutCallBefore,
    ].join(' · ');

    Future<void> act(Future<void> Function() action) async {
      final messenger = ScaffoldMessenger.of(context);
      try {
        await action();
        ref
          ..invalidate(myAddressesProvider)
          ..invalidate(savedAddressesProvider);
      } on Object catch (error) {
        messenger.showSnackBar(SnackBar(content: Text(errorText(l10n, error))));
      }
    }

    final repo = ref.read(accountRepositoryProvider);
    Map<String, Object?> fields({bool? isDefault}) => {
      'latitude': a.latitude,
      'longitude': a.longitude,
      'label': a.label,
      'area': a.area,
      'landmark': a.landmark,
      'building': a.building,
      'floor': a.floor,
      'details': a.details,
      'callBeforeArrival': a.callBeforeArrival,
      'isDefault': ?isDefault,
    };

    return BBCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BBIconBox(BBIcons.pin, size: 40),
          const SizedBox(width: BBSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: BBSpacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(a.label, style: BBText.bodyBold),
                    if (a.isDefault)
                      BBBadge(
                        label: l10n.addressesDefault,
                        tone: BBBadgeTone.sage,
                      ),
                  ],
                ),
                if (line.isNotEmpty) Text(line, style: BBText.small),
                if (second.isNotEmpty) Text(second, style: BBText.xs.muted),
                if (zone == null) ...[
                  const SizedBox(height: BBSpacing.xs),
                  BBBadge(label: l10n.addressesOutBadge, tone: BBBadgeTone.red),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: l10n.addressesEdit,
            icon: const BBIcon(BBIcons.edit, color: BBColors.textMuted),
            onSelected: (choice) async {
              switch (choice) {
                case 'default':
                  await act(
                    () => repo.saveAddress(fields(isDefault: true), id: a.id),
                  );
                case 'edit':
                  await context.push(Routes.editAddress(a.id), extra: a);
                case 'delete':
                  final sure = await confirmDialog(
                    context,
                    l10n.addressesDeleteAsk(a.label),
                    l10n.addressesDelete,
                  );
                  if (sure) await act(() => repo.deleteAddress(a.id));
              }
            },
            itemBuilder: (context) => [
              if (!a.isDefault)
                PopupMenuItem(
                  value: 'default',
                  child: Text(l10n.addressesMakeDefault),
                ),
              PopupMenuItem(value: 'edit', child: Text(l10n.addressesEdit)),
              PopupMenuItem(value: 'delete', child: Text(l10n.addressesDelete)),
            ],
          ),
        ],
      ),
    );
  }
}
