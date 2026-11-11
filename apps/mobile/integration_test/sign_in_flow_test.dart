// End-to-end on a device or emulator against the real local API (S1 exit).
//
// 1. API:  OTP_FIXED_CODE=4827 pnpm --filter @belle/api start:dev
// 2. App:  flutter test integration_test/sign_in_flow_test.dart \
//            --flavor dev --dart-define-from-file=env/dev.json
//
// The fixed code works only when the API runs in development or test.
import 'dart:math';

import 'package:belle_biens/app/app.dart';
import 'package:belle_biens/app/bootstrap.dart';
import 'package:belle_biens/app/env.dart';
import 'package:belle_biens/core/storage/token_store.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

const _fixedCode = '4827';

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Waits for a real network round trip to show its result.
Future<void> _waitFor(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 100 && finder.evaluate().isEmpty; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(finder, findsWidgets);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('a new customer signs up with a phone code, then signs out', (
    tester,
  ) async {
    // A new number every run, so the account is always new.
    final phone = '0944${Random().nextInt(900000) + 100000}';
    await SecureTokenStore().clear();

    final overrides = await appOverrides(AppEnv.fromDefines());
    await tester.pumpWidget(
      ProviderScope(overrides: overrides, child: const BelleApp()),
    );
    await tester.pumpAndSettle();

    // Screen 01 on a fresh install; returning runs start at home.
    if (find.text('أهلاً بك في Belle Biens').evaluate().isNotEmpty) {
      await _tap(tester, find.text('تسجيل الدخول'));
    } else {
      await _tap(tester, find.text('حسابي').last);
      await _tap(tester, find.text('تسجيل الدخول').first);
    }

    // Screen 02 -> real POST /v1/auth/otp/request
    await tester.enterText(find.byType(TextField).first, phone);
    await _tap(tester, find.text('إرسال رمز التحقق'));
    await _waitFor(tester, find.text('أدخل الرمز المرسل إليك'));

    // Screen 04 -> real POST /v1/auth/otp/verify
    await tester.enterText(
      find.descendant(
        of: find.byType(BBOtpInput),
        matching: find.byType(TextField),
      ),
      _fixedCode,
    );
    await _waitFor(tester, find.text('خطوة أخيرة'));

    // New account from the login screen: name and terms -> PATCH /v1/me
    await tester.enterText(find.byType(TextField).first, 'تجربة آلية');
    await _tap(tester, find.text('أوافق على شروط الاستخدام وسياسة الخصوصية.'));
    await _tap(tester, find.text('حفظ والمتابعة'));
    await _waitFor(tester, find.text('ابقَ على اطلاع بطلباتك'));

    // Screen 05: skip the system prompt in automation.
    await _tap(tester, find.text('لاحقاً'));
    await _tap(tester, find.text('حسابي').last);
    expect(find.text('أهلاً تجربة آلية'), findsOneWidget);

    await _tap(tester, find.text('تسجيل الخروج'));
    expect(find.text('أنت تتصفّح كضيف'), findsOneWidget);
    expect(await SecureTokenStore().read(), isNull);
  });
}
