import 'package:belle_biens/app/env.dart';
import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/theme/bb_theme.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Temporary screen for tabs whose real UI arrives in a later sprint
/// (plan 4.8).
class PlaceholderScreen extends ConsumerWidget {
  const new({required this.title, required this.sprint, super.key});

  final String title;
  final String sprint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final env = ref.watch(appEnvProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(BBSpacing.page),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.comingSoon, style: textTheme.titleMedium),
              const SizedBox(height: BBSpacing.sm),
              Text(
                l10n.comingSoonBody(sprint),
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: context.bb.textMuted,
                ),
              ),
              if (!env.isProduction) ...[
                const SizedBox(height: BBSpacing.md),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.bb.amber,
                    borderRadius: BorderRadius.circular(BBRadius.pill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    child: Text(
                      l10n.environmentBadge(env.flavor.name),
                      style: textTheme.labelMedium?.copyWith(
                        color: context.bb.onAmber,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
