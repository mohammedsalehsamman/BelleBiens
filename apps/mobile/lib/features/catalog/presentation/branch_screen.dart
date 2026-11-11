import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/launch/external_links.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/home_screen.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen 34 (FR-CON-03/04): where the shop is, when it is open, how to reach
/// it, and the policy pages.
class BranchScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final branch = ref.watch(branchProvider);
    return Scaffold(
      appBar: BBTopBar(
        title: l10n.branchTitle,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(BBSpacing.page),
        children: [
          CachedAsync<BranchDto>(
            value: branch,
            onRetry: () => ref.invalidate(branchProvider),
            builder: (context, cached) =>
                _BranchBody(branch: cached.data, offline: cached.offline),
          ),
        ],
      ),
    );
  }
}

class _BranchBody extends ConsumerWidget {
  const new({required this.branch, required this.offline});

  final BranchDto branch;
  final bool offline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final links = ref.read(externalLinksProvider);
    final (statusTitle, _) = shopStatusText(l10n, branch.status);
    final hours = l10n.branchHoursDaily(
      branch.status.opensAt,
      branch.status.closesAt,
    );
    final lat = branch.latitude;
    final lng = branch.longitude;
    final phone = branch.phone;
    final whatsapp = branch.whatsapp;
    final instagram = branch.instagram;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (offline) ...[
          const OfflineBanner(),
          const SizedBox(height: BBSpacing.gutter),
        ],
        BBCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BBIconBox(BBIcons.store),
              const SizedBox(height: BBSpacing.gutter),
              Text(branch.name.of(context), style: BBText.h2),
              Text(branch.address.of(context), style: BBText.small.muted),
              const SizedBox(height: BBSpacing.gutter),
              Wrap(
                spacing: BBSpacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  BBBadge(
                    label: statusTitle,
                    tone: branch.status.openNow
                        ? BBBadgeTone.green
                        : BBBadgeTone.gray,
                  ),
                  Text(hours, style: BBText.small.merge(BBText.numeric)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: BBSpacing.md),
        Row(
          children: [
            _Action(
              icon: BBIcons.pin,
              label: l10n.branchDirections,
              onTap: lat == null || lng == null
                  ? null
                  : () => links.open(
                      ExternalLinks.maps(lat, lng, branch.name.of(context)),
                    ),
            ),
            _Action(
              icon: BBIcons.whatsapp,
              label: l10n.homeWhatsapp,
              onTap: whatsapp == null
                  ? null
                  : () => links.open(ExternalLinks.whatsapp(whatsapp)),
            ),
            _Action(
              icon: BBIcons.phone,
              label: l10n.branchCall,
              onTap: phone == null
                  ? null
                  : () => links.open(ExternalLinks.call(phone)),
            ),
            _Action(
              icon: BBIcons.instagram,
              // "@bellebiens" stays left to right inside Arabic.
              label: instagram == null
                  ? l10n.branchInstagram
                  : '\u2066@$instagram\u2069',
              onTap: instagram == null
                  ? null
                  : () => links.open(ExternalLinks.instagram(instagram)),
            ),
          ],
        ),
        if (phone == null || whatsapp == null) ...[
          const SizedBox(height: BBSpacing.sm),
          Text(l10n.branchContactSoon, style: BBText.xs.muted),
        ],
        const SizedBox(height: BBSpacing.section),
        BBSectionHeader(title: l10n.branchPolicies),
        const SizedBox(height: BBSpacing.sm),
        BBListGroup(
          children: [
            for (final page in branch.pages)
              BBListTile(
                title: page.title.of(context),
                onTap: () => context.push(Routes.page(page.slug)),
              ),
          ],
        ),
        if (branch.partners.isNotEmpty) ...[
          const SizedBox(height: BBSpacing.md),
          Text(
            l10n.branchPartners(branch.partners.join(' · ')),
            style: BBText.small.muted,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const new({required this.icon, required this.label, required this.onTap});

  final BBIcons icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Opacity(
        opacity: onTap == null ? 0.45 : 1,
        child: Semantics(
          button: true,
          enabled: onTap != null,
          label: label,
          excludeSemantics: true,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(BBRadius.card),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 72),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BBIconBox(icon, size: 40),
                  const SizedBox(height: BBSpacing.xs),
                  Text(
                    label,
                    style: BBText.xs,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

/// A policy page (FR-CON-04): delivery, cancellation, privacy, terms.
class PolicyPageScreen extends ConsumerWidget {
  const new({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(pageProvider(slug));
    return Scaffold(
      appBar: BBTopBar(
        title: page.value?.data.title.of(context) ?? '',
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(BBSpacing.page),
        children: [
          CachedAsync<PageDto>(
            value: page,
            onRetry: () => ref.invalidate(pageProvider(slug)),
            builder: (context, cached) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (cached.offline) ...[
                  const OfflineBanner(),
                  const SizedBox(height: BBSpacing.gutter),
                ],
                Text(cached.data.body.of(context), style: BBText.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
