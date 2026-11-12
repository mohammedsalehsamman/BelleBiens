import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/core/launch/external_links.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/checkout/application/checkout_controller.dart';
import 'package:belle_biens/features/checkout/presentation/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen 36: the pin is outside every zone (FR-DLV-01). The customer asks
/// the shop on WhatsApp, picks the order up, or moves the pin. Pops with
/// [outOfZonePickup] or [outOfZoneOtherAddress].
class OutOfZoneScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final whatsapp = ref.watch(branchProvider).value?.data.whatsapp;
    final address = ref.watch(checkoutControllerProvider).address;

    Future<void> ask() async {
      final link = address == null
          ? ''
          : 'https://www.openstreetmap.org/?mlat=${address.latitude}'
                '&mlon=${address.longitude}#map=17/${address.latitude}/'
                '${address.longitude}';
      await ref
          .read(externalLinksProvider)
          .open(
            ExternalLinks.whatsapp(whatsapp!, text: l10n.outZoneMessage(link)),
          );
    }

    return Scaffold(
      appBar: BBTopBar(
        title: l10n.addressTitle,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(BBSpacing.page),
        children: [
          const SizedBox(height: BBSpacing.lg),
          const Center(child: BBHeroIcon(BBIcons.pin)),
          const SizedBox(height: BBSpacing.md),
          BBNotice(
            text: '${l10n.outZoneHeadline} ${l10n.outZoneBody}',
            tone: BBNoticeTone.warn,
            icon: BBIcons.warning,
          ),
          const SizedBox(height: BBSpacing.lg),
          BBButton(
            label: l10n.outZoneWhatsapp,
            leading: BBIcons.whatsapp,
            variant: BBButtonVariant.whatsapp,
            expand: true,
            onPressed: whatsapp == null ? null : ask,
          ),
          const SizedBox(height: BBSpacing.sm),
          BBButton(
            label: l10n.outZonePickup,
            leading: BBIcons.store,
            variant: BBButtonVariant.secondary,
            expand: true,
            onPressed: () => context.pop(outOfZonePickup),
          ),
          const SizedBox(height: BBSpacing.sm),
          BBButton(
            label: l10n.outZoneOther,
            variant: BBButtonVariant.quiet,
            expand: true,
            onPressed: () => context.pop(outOfZoneOtherAddress),
          ),
        ],
      ),
    );
  }
}
