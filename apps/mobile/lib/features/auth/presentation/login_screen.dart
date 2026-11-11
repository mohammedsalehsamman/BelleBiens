import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/preferences.dart';
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
import 'package:belle_biens/features/auth/application/after_sign_in.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/auth/data/auth_repository.dart';
import 'package:belle_biens/features/auth/domain/otp_challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _Method { phone, email }

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Screen 02: sign in with a phone code, or with email and password.
class LoginScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  _Method _method = _Method.phone;
  bool _busy = false;
  String? _fieldError;
  String? _formError;

  @override
  void dispose() {
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final l10n = AppLocalizations.of(context);
    final phone = normalizePhone(_phone.text);
    if (phone == null) {
      setState(() => _fieldError = l10n.phoneInvalid);
      return;
    }
    setState(() {
      _busy = true;
      _fieldError = null;
      _formError = null;
    });
    try {
      final sent = await ref.read(authRepositoryProvider).requestOtp(phone);
      if (!mounted) return;
      await context.push(
        Routes.otp,
        extra: OtpChallenge(
          phone: sent.phone,
          maskedPhone: sent.maskedPhone,
          codeLength: sent.codeLength.toInt(),
          resendAfterSeconds: sent.resendAfterSeconds.toInt(),
          whatsapp: false,
        ),
      );
    } on Object catch (error) {
      if (mounted) setState(() => _formError = errorText(l10n, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signInWithEmail() async {
    final l10n = AppLocalizations.of(context);
    final email = _email.text.trim();
    if (!_emailPattern.hasMatch(email)) {
      setState(() => _fieldError = l10n.emailInvalid);
      return;
    }
    if (_password.text.isEmpty) {
      setState(() => _fieldError = l10n.passwordRequired);
      return;
    }
    setState(() {
      _busy = true;
      _fieldError = null;
      _formError = null;
    });
    try {
      final session = await ref
          .read(authRepositoryProvider)
          .login(email, _password.text);
      await ref.read(sessionControllerProvider.notifier).signedIn(session);
      if (!mounted) return;
      context.go(
        routeAfterSignIn(session.user, ref.read(appPreferencesProvider)),
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
    final isPhone = _method == _Method.phone;

    return BBScreen(
      topBar: BBTopBar(
        title: l10n.loginTitle,
        onBack: context.canPop() ? context.pop : null,
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.loginHeading, style: BBText.h1),
            const SizedBox(height: BBSpacing.sm),
            Text(l10n.loginBody, style: BBText.body.muted),
          ],
        ),
        BBSegmented<_Method>(
          segments: [
            (_Method.phone, l10n.loginTabPhone),
            (_Method.email, l10n.loginTabEmail),
          ],
          selected: _method,
          onChanged: (method) => setState(() {
            _method = method;
            _fieldError = null;
            _formError = null;
          }),
        ),
        BBCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isPhone)
                PhoneField(
                  controller: _phone,
                  label: l10n.phoneLabel,
                  hint: l10n.phoneHint,
                  helper: l10n.phoneHelper,
                  error: _fieldError,
                  onSubmitted: (_) => _sendCode(),
                )
              else ...[
                BBTextField(
                  label: l10n.emailLabel,
                  controller: _email,
                  hint: l10n.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textDirection: TextDirection.ltr,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: BBSpacing.md),
                BBTextField(
                  label: l10n.passwordLabel,
                  controller: _password,
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  error: _fieldError,
                  onSubmitted: (_) => _signInWithEmail(),
                ),
              ],
              const SizedBox(height: BBSpacing.md),
              BBButton(
                label: isPhone ? l10n.loginSendCode : l10n.loginWithEmail,
                trailing: BBIcons.forward,
                expand: true,
                loading: _busy,
                onPressed: isPhone ? _sendCode : _signInWithEmail,
              ),
              if (_formError != null) ...[
                const SizedBox(height: BBSpacing.gutter),
                BBNotice(text: _formError!, tone: BBNoticeTone.error),
              ],
            ],
          ),
        ),
        Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(l10n.loginNoAccount, style: BBText.small.muted),
                BBLink(
                  label: l10n.registerTitle,
                  onPressed: () => context.pushReplacement(Routes.register),
                ),
              ],
            ),
            BBLink(
              label: l10n.loginBrowseAsGuest,
              color: BBColors.textMuted,
              onPressed: () => context.go(Routes.home),
            ),
          ],
        ),
      ],
    );
  }
}

/// Phone input with the +963 hint, typed left to right (screens 02 and 03).
class PhoneField extends StatelessWidget {
  const new({
    required this.controller,
    required this.label,
    required this.hint,
    super.key,
    this.helper,
    this.error,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? helper;
  final String? error;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return BBTextField(
      label: label,
      controller: controller,
      hint: hint,
      helper: helper,
      error: error,
      keyboardType: TextInputType.phone,
      autofillHints: const [AutofillHints.telephoneNumber],
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.done,
      onSubmitted: onSubmitted,
      // Screen 02: the number starts on the reading side, the country code
      // sits apart at the other end.
      textAlign: Directionality.of(context) == TextDirection.rtl
          ? TextAlign.right
          : TextAlign.left,
      suffix: Padding(
        padding: const EdgeInsetsDirectional.only(end: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 1,
              height: 24,
              color: BBColors.borderStrong,
              margin: const EdgeInsetsDirectional.only(end: 10),
            ),
            Text(
              '+963',
              textDirection: TextDirection.ltr,
              style: BBText.body.muted.merge(BBText.numeric),
            ),
          ],
        ),
      ),
    );
  }
}
