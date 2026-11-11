import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/validation/phone.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/auth/data/auth_repository.dart';
import 'package:belle_biens/features/auth/domain/otp_challenge.dart';
import 'package:belle_biens/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Areas offered on the register screen. They become the shop's delivery
/// zones from the API in S5 (FR-DLV-02).
List<String> registerAreas(AppLocalizations l10n) => [
  l10n.areaAbuRummaneh,
  l10n.areaMalki,
  l10n.areaMazzeh,
  l10n.areaShaalan,
  l10n.areaQassaa,
  l10n.areaOther,
];

/// Screen 03: name, mobile, optional email and area, consent, then a code.
class RegisterScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  String? _area;
  bool _terms = false;
  bool _marketing = false;
  bool _busy = false;
  String? _nameError;
  String? _phoneError;
  String? _emailError;
  String? _formError;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final name = _name.text.trim();
    final phone = normalizePhone(_phone.text);
    final email = _email.text.trim();
    setState(() {
      _nameError = name.isEmpty ? l10n.nameRequired : null;
      _phoneError = phone == null ? l10n.phoneInvalid : null;
      _emailError = email.isNotEmpty && !_emailPattern.hasMatch(email)
          ? l10n.emailInvalid
          : null;
      _formError = _terms ? null : l10n.termsRequired;
    });
    if (_nameError != null ||
        _phoneError != null ||
        _emailError != null ||
        !_terms) {
      return;
    }

    setState(() => _busy = true);
    try {
      final sent = await ref.read(authRepositoryProvider).requestOtp(phone!);
      if (!mounted) return;
      await context.push(
        Routes.otp,
        extra: OtpChallenge(
          phone: sent.phone,
          maskedPhone: sent.maskedPhone,
          codeLength: sent.codeLength.toInt(),
          resendAfterSeconds: sent.resendAfterSeconds.toInt(),
          whatsapp: false,
          account: NewAccountFields(
            name: name,
            email: email.isEmpty ? null : email,
            homeArea: _area,
            acceptTerms: _terms,
            marketingOptIn: _marketing,
          ),
        ),
      );
    } on Object catch (error) {
      if (mounted) setState(() => _formError = errorText(l10n, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BBScreen(
      topBar: BBTopBar(
        title: l10n.registerTitle,
        onBack: context.canPop() ? context.pop : null,
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.registerHeading, style: BBText.h1),
            const SizedBox(height: BBSpacing.sm),
            Text(l10n.registerBody, style: BBText.body.muted),
          ],
        ),
        BBCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BBTextField(
                label: l10n.nameLabel,
                controller: _name,
                hint: l10n.nameHint,
                error: _nameError,
                autofillHints: const [AutofillHints.name],
                textInputAction: TextInputAction.next,
                maxLength: 80,
              ),
              const SizedBox(height: BBSpacing.md),
              PhoneField(
                controller: _phone,
                label: l10n.mobileLabel,
                hint: l10n.mobileHint,
                helper: l10n.mobileHelper,
                error: _phoneError,
              ),
              const SizedBox(height: BBSpacing.md),
              BBTextField(
                label: l10n.emailOptionalLabel,
                controller: _email,
                hint: l10n.emailHint,
                error: _emailError,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: BBSpacing.md),
              Text(l10n.areaLabel, style: BBText.label),
              const SizedBox(height: BBSpacing.sm),
              Wrap(
                spacing: BBSpacing.sm,
                runSpacing: BBSpacing.sm,
                children: [
                  for (final area in registerAreas(l10n))
                    BBChip(
                      label: area,
                      selected: _area == area,
                      onTap: () =>
                          setState(() => _area = _area == area ? null : area),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(l10n.areaHelper, style: BBText.xs.muted),
            ],
          ),
        ),
        Column(
          children: [
            BBCheckbox(
              value: _terms,
              onChanged: (value) => setState(() => _terms = value),
              label: Text(l10n.termsAccept, style: BBText.small),
            ),
            BBCheckbox(
              value: _marketing,
              onChanged: (value) => setState(() => _marketing = value),
              label: Text(l10n.marketingOptIn, style: BBText.small),
            ),
          ],
        ),
        if (_formError != null)
          BBNotice(text: _formError!, tone: BBNoticeTone.error),
        BBButton(
          label: l10n.registerSubmit,
          trailing: BBIcons.forward,
          expand: true,
          loading: _busy,
          onPressed: _submit,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(l10n.registerHaveAccount, style: BBText.small.muted),
            BBLink(
              label: l10n.loginTitle,
              onPressed: () => context.pushReplacement(Routes.login),
            ),
          ],
        ),
        const SizedBox(height: BBSpacing.sm),
        Center(
          child: BBLink(
            label: l10n.loginBrowseAsGuest,
            color: BBColors.textMuted,
            onPressed: () => context.go(Routes.home),
          ),
        ),
      ],
    );
  }
}
