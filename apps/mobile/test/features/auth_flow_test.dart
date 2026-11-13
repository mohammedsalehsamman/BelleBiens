import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/features/auth/data/auth_repository.dart';
import 'package:belle_biens/features/auth/domain/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/test_app.dart';

Finder _otpField() => find.descendant(
  of: find.byType(BBOtpInput),
  matching: find.byType(TextField),
);

Future<void> _openLogin(WidgetTester tester) async {
  await tapText(tester, 'حسابي', last: true);
  await tapText(tester, 'تسجيل الدخول');
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const NewAccountFields(
        name: '',
        acceptTerms: false,
        marketingOptIn: false,
      ),
    );
  });

  testWidgets('phone sign-in: code, session saved, notifications asked once '
      '(screens 02, 04, 05)', (tester) async {
    final t = await pumpTestApp(tester);
    when(() => t.auth.requestOtp('+963944123456'))
        .thenAnswer((_) async => testOtpRequested());
    when(() => t.auth.verifyOtp(phone: '+963944123456', code: '4827'))
        .thenAnswer((_) async => testSession());

    await _openLogin(tester);
    await tester.enterText(find.byType(TextField).first, '0944 123 456');
    await tapText(tester, 'إرسال رمز التحقق');

    // Screen 04 shows where the code went.
    expect(find.text('+963 944 *** 456'), findsOneWidget);
    expect(find.text('أرسلنا رمزاً من 4 أرقام برسالة SMS إلى'), findsOneWidget);

    await tester.enterText(_otpField(), '4827');
    await tester.pumpAndSettle();

    // Signed in: the session is in secure storage, then screen 05.
    final stored = Session.fromJson(t.tokens.value!);
    expect(stored.accessToken, 'access-1');
    expect(stored.user.name, 'سارة');
    expect(find.text('ابقَ على اطلاع بطلباتك'), findsOneWidget);

    await tapText(tester, 'تفعيل الإشعارات');
    expect(t.permission.requests, 1);
    expect(t.prefs.values['notifications.asked'], true);
    expect(find.text('صمّم باقتك على ذوقك'), findsOneWidget);
  });

  testWidgets('a wrong code shows the server message and the tries left', (
    tester,
  ) async {
    final t = await pumpTestApp(tester);
    when(() => t.auth.requestOtp(any()))
        .thenAnswer((_) async => testOtpRequested());
    when(
      () => t.auth.verifyOtp(
        phone: any(named: 'phone'),
        code: any(named: 'code'),
      ),
    ).thenThrow(
      const ApiError(
        code: 'OTP_INVALID',
        status: 400,
        title: 'الرمز غير صحيح. تأكد منه وحاول مرة أخرى.',
        extra: {'attemptsLeft': 3},
      ),
    );

    await _openLogin(tester);
    await tester.enterText(find.byType(TextField).first, '0944123456');
    await tapText(tester, 'إرسال رمز التحقق');
    await tester.enterText(_otpField(), '1111');
    await tester.pumpAndSettle();

    expect(
      find.text('الرمز غير صحيح. تأكد منه وحاول مرة أخرى. بقيت 3 محاولات.'),
      findsOneWidget,
    );
    expect(t.tokens.value, isNull);
  });

  testWidgets('invalid numbers are caught before calling the server '
      '(FR-CRT-09)', (tester) async {
    final t = await pumpTestApp(tester);
    await _openLogin(tester);
    await tester.enterText(find.byType(TextField).first, '0833000000');
    await tapText(tester, 'إرسال رمز التحقق');

    expect(find.textContaining('رقم الهاتف غير صحيح'), findsOneWidget);
    verifyNever(() => t.auth.requestOtp(any()));
  });

  testWidgets('register: terms are required, then the fields go with the code '
      '(screen 03)', (tester) async {
    final t = await pumpTestApp(tester);
    when(() => t.auth.requestOtp('+963944123456'))
        .thenAnswer((_) async => testOtpRequested());
    when(
      () => t.auth.verifyOtp(
        phone: '+963944123456',
        code: '4827',
        account: any(named: 'account'),
      ),
    ).thenAnswer(
      (_) async => testSession(user: testUser(name: 'لين'), isNewUser: true),
    );

    await tapText(tester, 'حسابي', last: true);
    await tapText(tester, 'إنشاء حساب');

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'لين');
    await tester.enterText(fields.at(1), '0944123456');
    await tapText(tester, 'إنشاء الحساب والتحقق');
    expect(
      find.text('يجب الموافقة على شروط الاستخدام وسياسة الخصوصية لإنشاء حساب.'),
      findsOneWidget,
    );
    verifyNever(() => t.auth.requestOtp(any()));

    await tapText(tester, 'المزة');
    await tapText(tester, 'أوافق على شروط الاستخدام وسياسة الخصوصية.');
    await tapText(tester, 'إنشاء الحساب والتحقق');
    await tester.enterText(_otpField(), '4827');
    await tester.pumpAndSettle();

    final account =
        verify(
              () => t.auth.verifyOtp(
                phone: '+963944123456',
                code: '4827',
                account: captureAny(named: 'account'),
              ),
            ).captured.single
            as NewAccountFields;
    expect(account.name, 'لين');
    expect(account.homeArea, 'المزة');
    expect(account.acceptTerms, isTrue);
    expect(account.marketingOptIn, isFalse);
  });

  testWidgets('a first sign-in without a name asks to finish the profile', (
    tester,
  ) async {
    final t = await pumpTestApp(tester, notificationsAsked: true);
    when(() => t.auth.requestOtp(any()))
        .thenAnswer((_) async => testOtpRequested());
    when(
      () => t.auth.verifyOtp(
        phone: any(named: 'phone'),
        code: any(named: 'code'),
      ),
    ).thenAnswer(
      (_) async => testSession(
        user: testUser(name: '', profileComplete: false),
        isNewUser: true,
      ),
    );
    when(
      () => t.auth.completeProfile(
        name: 'سارة',
        homeArea: any(named: 'homeArea'),
        marketingOptIn: any(named: 'marketingOptIn'),
      ),
    ).thenAnswer((_) async => testUser());

    await _openLogin(tester);
    await tester.enterText(find.byType(TextField).first, '0944123456');
    await tapText(tester, 'إرسال رمز التحقق');
    await tester.enterText(_otpField(), '4827');
    await tester.pumpAndSettle();

    expect(find.text('خطوة أخيرة'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'سارة');
    await tapText(tester, 'أوافق على شروط الاستخدام وسياسة الخصوصية.');
    await tapText(tester, 'حفظ والمتابعة');

    // Notifications were already asked: straight home.
    expect(find.text('صمّم باقتك على ذوقك'), findsOneWidget);
    expect(Session.fromJson(t.tokens.value!).user.profileComplete, isTrue);
  });

  testWidgets('signing out clears the session', (tester) async {
    final session = Session.fromAuth(testSession());
    final t = await pumpTestApp(tester, storedSession: session.toJson());

    await tapText(tester, 'حسابي', last: true);
    expect(find.text('سارة'), findsOneWidget);
    expect(find.text('+963 944 *** 456'), findsOneWidget);

    await tapText(tester, 'تسجيل الخروج');
    expect(t.tokens.value, isNull);
    expect(find.text('أنت تتصفّح كضيف'), findsOneWidget);
  });
}
