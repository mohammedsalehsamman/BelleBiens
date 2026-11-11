import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/preferences.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/notifications/notification_permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen 05: explains notifications, then opens the system prompt. Asked once;
/// marketing stays off unless the customer agreed (FR-NTF-05).
class NotificationPermissionScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<NotificationPermissionScreen> createState() =>
      _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState
    extends ConsumerState<NotificationPermissionScreen> {
  bool _busy = false;

  Future<void> _finish({required bool ask}) async {
    setState(() => _busy = true);
    try {
      if (ask) await ref.read(notificationPermissionProvider).request();
    } finally {
      await ref.read(appPreferencesProvider).setNotificationsAsked();
      if (mounted) context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BBScreen(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: BBLink(
            label: l10n.notifyLater,
            color: BBColors.textMuted,
            onPressed: _busy ? null : () => _finish(ask: false),
          ),
        ),
        const BBHeroIcon(BBIcons.bell),
        Column(
          children: [
            Text(
              l10n.notifyHeading,
              style: BBText.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BBSpacing.sm),
            Text(
              l10n.notifyBody,
              style: BBText.body.muted,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        _Reason(
          icon: BBIcons.truck,
          title: l10n.notifyOrderTitle,
          body: l10n.notifyOrderBody,
        ),
        _Reason(
          icon: BBIcons.calendar,
          title: l10n.notifyOccasionTitle,
          body: l10n.notifyOccasionBody,
        ),
        _Reason(
          icon: BBIcons.flower,
          title: l10n.notifyOffersTitle,
          body: l10n.notifyOffersBody,
          tone: BBTone.sage,
        ),
        BBButton(
          label: l10n.notifyEnable,
          leading: BBIcons.bell,
          expand: true,
          loading: _busy,
          onPressed: () => _finish(ask: true),
        ),
        Text(
          l10n.notifySystemHint,
          style: BBText.xs.muted,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _Reason extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.body,
    this.tone = BBTone.blush,
  });

  final BBIcons icon;
  final String title;
  final String body;
  final BBTone tone;

  @override
  Widget build(BuildContext context) {
    return BBCard(
      child: Row(
        children: [
          BBIconBox(icon, tone: tone),
          const SizedBox(width: BBSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: BBText.bodyBold),
                Text(body, style: BBText.small.muted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
