import 'dart:async';

import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/preferences.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/text/digits.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/account/application/account_providers.dart';
import 'package:belle_biens/features/auth/application/after_sign_in.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/auth/data/auth_repository.dart';
import 'package:belle_biens/features/auth/domain/otp_challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen 04: type the code; resend after the countdown, by SMS or WhatsApp.
class OtpScreen extends ConsumerStatefulWidget {
  const new({required this.challenge, super.key});

  final OtpChallenge challenge;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  late OtpChallenge _challenge = widget.challenge;
  Timer? _timer;
  late int _secondsLeft = _challenge.resendAfterSeconds;
  String _code = '';
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    _secondsLeft = _challenge.resendAfterSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      setState(() => _secondsLeft = _secondsLeft > 0 ? _secondsLeft - 1 : 0);
      if (_secondsLeft == 0) timer.cancel();
    });
  }

  Future<void> _confirm() async {
    if (_code.length != _challenge.codeLength || _busy) return;
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final session = await ref
          .read(authRepositoryProvider)
          .verifyOtp(
            phone: _challenge.phone,
            code: _code,
            account: _challenge.account,
          );
      await ref.read(sessionControllerProvider.notifier).signedIn(session);
      if (!mounted) return;
      context.go(
        routeAfterSignIn(session.user, ref.read(appPreferencesProvider)),
      );
    } on ApiError catch (error) {
      if (!mounted) return;
      final left = error.attemptsLeft;
      setState(
        () => _error = left == null
            ? errorText(l10n, error)
            : '${errorText(l10n, error)} ${l10n.otpAttemptsLeft(left)}',
      );
    } on Object catch (error) {
      if (mounted) setState(() => _error = errorText(l10n, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend({required bool whatsapp}) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final sent = await ref
          .read(authRepositoryProvider)
          .requestOtp(_challenge.phone, whatsapp: whatsapp);
      if (!mounted) return;
      setState(
        () => _challenge = _challenge.resent(
          resendAfterSeconds: sent.resendAfterSeconds.toInt(),
          whatsapp: whatsapp,
        ),
      );
      _startCountdown();
    } on Object catch (error) {
      if (mounted) setState(() => _error = errorText(l10n, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final numerals = ref.watch(displayNumeralsProvider);
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    final canResend = _secondsLeft == 0 && !_busy;

    return BBScreen(
      topBar: BBTopBar(
        title: l10n.otpTitle,
        onBack: context.canPop() ? context.pop : null,
      ),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const BBHeroIcon(BBIcons.shieldCheck),
        Column(
          children: [
            Text(
              l10n.otpHeading,
              style: BBText.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BBSpacing.sm),
            Text(
              _challenge.whatsapp
                  ? l10n.otpSentWhatsapp(_challenge.codeLength)
                  : l10n.otpSentSms(_challenge.codeLength),
              style: BBText.body.muted,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    _challenge.maskedPhone,
                    style: BBText.bodyBold
                        .merge(BBText.numeric)
                        .copyWith(fontSize: 18),
                  ),
                ),
                const SizedBox(width: BBSpacing.sm),
                BBLink(
                  label: l10n.commonEdit,
                  leading: BBIcons.edit,
                  onPressed: context.canPop() ? context.pop : null,
                ),
              ],
            ),
          ],
        ),
        BBOtpInput(
          length: _challenge.codeLength,
          semanticLabel: l10n.otpFieldLabel,
          hasError: _error != null,
          onChanged: (code) => setState(() {
            _code = code;
            _error = null;
          }),
          onCompleted: (_) => _confirm(),
        ),
        if (_error != null)
          BBNotice(text: _error!, tone: BBNoticeTone.error)
        else if (_secondsLeft > 0)
          Text(
            l10n.otpResendIn(localizeDigits('$minutes:$seconds', numerals)),
            style: BBText.small.muted,
            textAlign: TextAlign.center,
          )
        else
          BBLink(
            label: l10n.otpResendSms,
            leading: BBIcons.refresh,
            onPressed: canResend ? () => _resend(whatsapp: false) : null,
          ),
        BBButton(
          label: l10n.otpSendWhatsapp,
          leading: BBIcons.whatsapp,
          variant: BBButtonVariant.soft,
          expand: true,
          onPressed: canResend ? () => _resend(whatsapp: true) : null,
        ),
        BBButton(
          label: l10n.otpConfirm,
          trailing: BBIcons.forward,
          expand: true,
          loading: _busy,
          onPressed: _code.length == _challenge.codeLength ? _confirm : null,
        ),
        BBNotice(text: l10n.otpNotice, icon: BBIcons.info),
        const SizedBox(height: BBSpacing.sm),
        Text('', style: BBText.xs.withColor(BBColors.textMuted)),
      ],
    );
  }
}
