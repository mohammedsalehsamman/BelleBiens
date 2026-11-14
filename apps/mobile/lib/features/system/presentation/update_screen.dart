import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/launch/external_links.dart';
import 'package:belle_biens/core/version/update_required.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// NFR-CMP-01: shown in place of every screen once the server says this
/// version is too old. There is no way back: the server would refuse the
/// next call anyway. The cart and the design draft stay on the phone.
class UpdateScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final link = ref.watch(updateLinkProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: BBTopBar(title: l10n.updateTitle),
        body: ListView(
          padding: const EdgeInsets.all(BBSpacing.page),
          children: [
            const SizedBox(height: BBSpacing.lg),
            const Center(child: BBHeroIcon(BBIcons.refresh)),
            const SizedBox(height: BBSpacing.md),
            Text(
              l10n.updateHeadline,
              style: BBText.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BBSpacing.sm),
            Text(
              l10n.updateBody,
              style: BBText.body.muted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BBSpacing.lg),
            if (link != null)
              BBButton(
                label: l10n.updateNow,
                leading: BBIcons.refresh,
                expand: true,
                onPressed: () => ref.read(externalLinksProvider).open(link),
              )
            else
              BBNotice(text: l10n.updateNoLink, icon: BBIcons.info),
          ],
        ),
      ),
    );
  }
}
