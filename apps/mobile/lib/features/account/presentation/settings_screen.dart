import 'dart:convert';
import 'dart:io';

import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/locale/app_locale.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/analytics/analytics.dart';
import 'package:belle_biens/core/api/api_providers.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/money/money.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/text/digits.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/account/application/account_providers.dart';
import 'package:belle_biens/features/account/presentation/occasions_screen.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/checkout/presentation/checkout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Writes a file and hands it to the phone's share sheet. Behind a
/// provider so tests see what was shared without a device.
final fileSharerProvider =
    Provider<Future<void> Function(String name, String content)>(
      (ref) => (name, content) async {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/$name');
        await file.writeAsString(content);
        await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
      },
    );

/// Screen 33: display, notifications and privacy (FR-LOC-02, FR-NTF-05,
/// FR-ANL-01, FR-ACC-08).
class SettingsScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;

  void _tell(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  /// One profile switch, saved on the server and in the session.
  Future<void> _update(Map<String, Object?> fields) async {
    final l10n = AppLocalizations.of(context);
    try {
      final me = await ref.read(accountRepositoryProvider).updateMe(fields);
      await ref.read(sessionControllerProvider.notifier).updateUser(me);
    } on Object catch (error) {
      _tell(errorText(l10n, error));
    }
  }

  Future<void> _export() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final data = await ref.read(accountRepositoryProvider).exportData();
      await ref.read(fileSharerProvider)(
        'belle-biens-my-data.json',
        const JsonEncoder.withIndent('  ').convert(data),
      );
      _tell(l10n.settingsExported);
    } on Object catch (error) {
      _tell(errorText(l10n, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final sure = await confirmDialog(
      context,
      l10n.settingsDeleteAsk,
      l10n.settingsDeleteYes,
    );
    if (!sure) return;
    setState(() => _busy = true);
    try {
      await ref.read(accountRepositoryProvider).deleteAccount();
      await ref.read(sessionControllerProvider.notifier).signOut();
      _tell(l10n.settingsDeleted);
      if (mounted) Navigator.of(context).maybePop();
    } on Object catch (error) {
      _tell(errorText(l10n, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(sessionControllerProvider).value?.user;
    final money = ref.watch(moneyFormatProvider);
    final numerals = ref.watch(numeralsProvider);

    return Scaffold(
      appBar: BBTopBar(
        title: l10n.settingsTitle,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(BBSpacing.page),
        children: [
          CheckoutSection(
            title: l10n.settingsDisplay,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.settingsLanguage, style: BBText.label),
                const SizedBox(height: BBSpacing.xs),
                BBSegmented<String>(
                  segments: [
                    ('ar', l10n.languageArabic),
                    ('en', l10n.languageEnglish),
                  ],
                  selected: ref.watch(appLocaleProvider).languageCode,
                  onChanged: (code) {
                    ref.read(appLocaleProvider.notifier).select(Locale(code));
                    if (user != null) _update({'language': code}).ignore();
                  },
                ),
                const SizedBox(height: BBSpacing.gutter),
                Text(l10n.settingsCurrency, style: BBText.label),
                const SizedBox(height: BBSpacing.xs),
                BBSegmented<DisplayCurrency>(
                  segments: [
                    (DisplayCurrency.syp, l10n.settingsCurrencySyp),
                    (DisplayCurrency.usd, l10n.settingsCurrencyUsd),
                  ],
                  selected: money.currency,
                  onChanged: (c) =>
                      ref.read(displayCurrencyProvider.notifier).select(c),
                ),
                const SizedBox(height: BBSpacing.xs),
                Text(l10n.settingsCurrencyNote, style: BBText.xs.muted),
                // Arabic-Indic digits are for the Arabic app only.
                if (ref.watch(appLocaleProvider).languageCode == 'ar') ...[
                  const SizedBox(height: BBSpacing.gutter),
                  Text(l10n.settingsDigits, style: BBText.label),
                  const SizedBox(height: BBSpacing.xs),
                  BBSegmented<Numerals>(
                    segments: const [
                      (Numerals.western, '1, 2, 3'),
                      (Numerals.arabic, '١، ٢، ٣'),
                    ],
                    selected: numerals,
                    onChanged: (n) =>
                        ref.read(numeralsProvider.notifier).select(n),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: BBSpacing.section),
          CheckoutSection(
            title: l10n.settingsNotifications,
            child: user == null
                ? BBNotice(text: l10n.settingsSignInFor, icon: BBIcons.bell)
                : Column(
                    children: [
                      // FR-NTF-05: order messages cannot be switched off.
                      ToggleRow(
                        label: l10n.settingsOrderStatus,
                        subtitle: l10n.settingsOrderStatusNote,
                        value: true,
                        onChanged: null,
                      ),
                      ToggleRow(
                        label: l10n.settingsOccasions,
                        value: user.notifyOccasions,
                        onChanged: (v) => _update({'notifyOccasions': v}),
                      ),
                      ToggleRow(
                        label: l10n.settingsOffers,
                        value: user.marketingOptIn,
                        onChanged: (v) => _update({'marketingOptIn': v}),
                      ),
                      ToggleRow(
                        label: l10n.settingsWhatsapp,
                        subtitle: l10n.settingsWhatsappNote,
                        value: user.notifyWhatsapp,
                        onChanged: (v) => _update({'notifyWhatsapp': v}),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: BBSpacing.section),
          CheckoutSection(
            title: l10n.settingsPrivacy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ToggleRow(
                  label: l10n.settingsAnalytics,
                  value: ref.watch(analyticsConsentProvider),
                  onChanged: (v) =>
                      ref.read(analyticsConsentProvider.notifier).set(value: v),
                ),
                if (user != null) ...[
                  const SizedBox(height: BBSpacing.sm),
                  BBButton(
                    label: l10n.settingsExport,
                    leading: BBIcons.share,
                    variant: BBButtonVariant.secondary,
                    expand: true,
                    loading: _busy,
                    onPressed: _export,
                  ),
                  const SizedBox(height: BBSpacing.sm),
                  BBButton(
                    label: l10n.settingsDelete,
                    leading: BBIcons.trash,
                    variant: BBButtonVariant.quiet,
                    expand: true,
                    onPressed: _busy ? null : _delete,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: BBSpacing.section),
          Text(
            l10n.settingsVersion(ref.watch(appVersionProvider)),
            style: BBText.xs.muted.merge(BBText.numeric),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: BBSpacing.lg),
        ],
      ),
    );
  }
}

/// The profile editor: name and email (FR-ACC-03).
class ProfileScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final MeDto? _user = ref.read(sessionControllerProvider).value?.user;
  late final _name = TextEditingController(text: _user?.name ?? '');
  late final _email = TextEditingController(text: _user?.email ?? '');
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (_name.text.trim().isEmpty) {
      setState(() => _error = l10n.nameRequired);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final email = _email.text.trim();
      final me = await ref.read(accountRepositoryProvider).updateMe({
        'name': _name.text.trim(),
        if (email.isNotEmpty) 'email': email,
      });
      await ref.read(sessionControllerProvider.notifier).updateUser(me);
      messenger.showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
      if (mounted) Navigator.of(context).maybePop();
    } on Object catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l10n, error))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final phone = _user?.phone;
    return Scaffold(
      appBar: BBTopBar(
        title: l10n.profileTitle,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(BBSpacing.page),
        children: [
          BBTextField(
            label: l10n.nameLabel,
            controller: _name,
            error: _error,
            autofillHints: const [AutofillHints.name],
          ),
          const SizedBox(height: BBSpacing.gutter),
          BBTextField(
            label: l10n.profileEmail,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textDirection: TextDirection.ltr,
            autofillHints: const [AutofillHints.email],
          ),
          if (phone != null) ...[
            const SizedBox(height: BBSpacing.gutter),
            BBCard(
              color: BBColors.surfaceLow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.phoneLabel, style: BBText.label),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(phone, style: BBText.bodyBold),
                  ),
                  const SizedBox(height: BBSpacing.xs),
                  Text(l10n.profilePhoneNote, style: BBText.xs.muted),
                ],
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: BBBottomCta(
        children: [
          Expanded(
            child: BBButton(
              label: l10n.profileSave,
              expand: true,
              loading: _saving,
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }
}
