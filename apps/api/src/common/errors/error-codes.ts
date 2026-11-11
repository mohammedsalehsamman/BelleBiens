/**
 * Stable error codes returned in problem+json bodies (plan 3.4, rule 8).
 * The app maps each code to its own localized message; the titles here are the
 * server's fallback text, in the customer's language and saying what to do next
 * (NFR-INT-05). Never rename a code: the app depends on it.
 */
export const ERROR_CATALOG = {
  INTERNAL: {
    status: 500,
    ar: 'حدث خطأ غير متوقع. حاول مرة أخرى بعد قليل.',
    en: 'Something went wrong. Please try again in a moment.',
  },
  VALIDATION_FAILED: {
    status: 400,
    ar: 'بعض البيانات غير صحيحة. راجع الحقول المحددة وحاول مرة أخرى.',
    en: 'Some details are not valid. Check the highlighted fields and try again.',
  },
  BAD_REQUEST: {
    status: 400,
    ar: 'الطلب غير صحيح. حدّث التطبيق أو حاول مرة أخرى.',
    en: 'The request is not valid. Update the app or try again.',
  },
  UNAUTHORIZED: {
    status: 401,
    ar: 'انتهت جلستك. سجّل الدخول مرة أخرى.',
    en: 'Your session has ended. Please sign in again.',
  },
  FORBIDDEN: {
    status: 403,
    ar: 'لا تملك صلاحية لهذا الإجراء.',
    en: 'You do not have permission to do this.',
  },
  NOT_FOUND: {
    status: 404,
    ar: 'لم نجد ما تبحث عنه.',
    en: 'We could not find what you are looking for.',
  },
  CONFLICT: {
    status: 409,
    ar: 'تغيّرت البيانات أثناء طلبك. حدّث الصفحة وحاول مرة أخرى.',
    en: 'The data changed while you were working. Refresh and try again.',
  },
  UPGRADE_REQUIRED: {
    status: 426,
    ar: 'هذه النسخة من التطبيق قديمة. حدّث التطبيق للمتابعة.',
    en: 'This version of the app is no longer supported. Please update to continue.',
  },
  RATE_LIMITED: {
    status: 429,
    ar: 'محاولات كثيرة. انتظر قليلاً ثم حاول مرة أخرى.',
    en: 'Too many attempts. Please wait a little and try again.',
  },
  // Domain codes used from S3 onwards. Listed now so the app can ship their messages early.
  STOCK_INSUFFICIENT: {
    status: 409,
    ar: 'الكمية المطلوبة غير متوفرة الآن. اختر كمية أقل أو بديلاً مقترحاً.',
    en: 'That quantity is not available right now. Choose fewer or a suggested substitute.',
  },
  SPEC_INVALID: {
    status: 422,
    ar: 'التصميم لا يطابق قواعد الباقة. راجع عدد الورود والاختيارات.',
    en: 'The design does not meet the bouquet rules. Check the stem count and choices.',
  },
  OUT_OF_ZONE: {
    status: 422,
    ar: 'العنوان خارج مناطق التوصيل. تواصل معنا على واتساب أو اختر الاستلام من الفرع.',
    en: 'This address is outside our delivery zones. Message us on WhatsApp or choose pickup.',
  },
  SLOT_FULL: {
    status: 409,
    ar: 'هذا الموعد امتلأ. اختر موعداً آخر.',
    en: 'This time slot is full. Please choose another one.',
  },
  SHOP_CLOSED: {
    status: 503,
    ar: 'المحل لا يستقبل طلبات جديدة الآن. حاول لاحقاً أو راسلنا على واتساب.',
    en: 'The shop is not taking new orders right now. Try later or message us on WhatsApp.',
  },
  SERVICE_UNAVAILABLE: {
    status: 503,
    ar: 'الخدمة غير متاحة مؤقتاً. حاول مرة أخرى بعد قليل.',
    en: 'The service is temporarily unavailable. Please try again shortly.',
  },

  // Accounts and sign-in (S1)
  PHONE_INVALID: {
    status: 400,
    ar: 'رقم الهاتف غير صحيح. اكتبه بالشكل 09XXXXXXXX أو +9639XXXXXXXX، أو رقماً دولياً يبدأ بـ +.',
    en: 'This phone number is not valid. Use 09XXXXXXXX, +9639XXXXXXXX or an international number starting with +.',
  },
  OTP_RATE_LIMITED: {
    status: 429,
    ar: 'طلبت رموزاً كثيرة. انتظر بضع دقائق ثم اطلب رمزاً جديداً.',
    en: 'Too many codes requested. Wait a few minutes, then ask for a new one.',
  },
  OTP_RESEND_TOO_SOON: {
    status: 429,
    ar: 'انتظر قليلاً قبل طلب رمز جديد.',
    en: 'Please wait a moment before asking for a new code.',
  },
  OTP_INVALID: {
    status: 400,
    ar: 'الرمز غير صحيح. تأكد منه وحاول مرة أخرى.',
    en: 'That code is not correct. Check it and try again.',
  },
  OTP_EXPIRED: {
    status: 400,
    ar: 'انتهت صلاحية الرمز. اطلب رمزاً جديداً.',
    en: 'This code has expired. Ask for a new one.',
  },
  OTP_TOO_MANY_ATTEMPTS: {
    status: 429,
    ar: 'استنفدت المحاولات لهذا الرمز. اطلب رمزاً جديداً.',
    en: 'Too many attempts for this code. Ask for a new one.',
  },
  INVALID_CREDENTIALS: {
    status: 401,
    ar: 'البريد أو كلمة المرور غير صحيحة.',
    en: 'The email or password is not correct.',
  },
  EMAIL_TAKEN: {
    status: 409,
    ar: 'هذا البريد مسجّل بحساب آخر. سجّل الدخول أو استخدم بريداً آخر.',
    en: 'This email belongs to another account. Sign in or use another email.',
  },
  PHONE_TAKEN: {
    status: 409,
    ar: 'هذا الرقم مسجّل بحساب آخر. سجّل الدخول برمز التحقق.',
    en: 'This phone number belongs to another account. Sign in with a code instead.',
  },
  PASSWORD_TOO_WEAK: {
    status: 400,
    ar: 'كلمة المرور قصيرة. استخدم 8 أحرف على الأقل.',
    en: 'The password is too short. Use at least 8 characters.',
  },
  TERMS_NOT_ACCEPTED: {
    status: 400,
    ar: 'يجب الموافقة على شروط الاستخدام وسياسة الخصوصية لإنشاء حساب.',
    en: 'Please accept the terms of use and the privacy policy to create an account.',
  },
  TOKEN_INVALID: {
    status: 401,
    ar: 'انتهت جلستك. سجّل الدخول مرة أخرى.',
    en: 'Your session has ended. Please sign in again.',
  },
  RESET_TOKEN_INVALID: {
    status: 400,
    ar: 'رابط استعادة كلمة المرور غير صالح أو انتهت صلاحيته. اطلب رابطاً جديداً.',
    en: 'This password reset link is invalid or has expired. Ask for a new one.',
  },
  ACCOUNT_DISABLED: {
    status: 403,
    ar: 'هذا الحساب موقوف. تواصل مع المحل على واتساب.',
    en: 'This account is disabled. Please contact the shop on WhatsApp.',
  },
  GOOGLE_SIGN_IN_UNAVAILABLE: {
    status: 503,
    ar: 'الدخول بحساب Google غير متاح الآن. استخدم رقم الهاتف.',
    en: 'Google sign-in is not available right now. Use your phone number instead.',
  },
  GOOGLE_TOKEN_INVALID: {
    status: 401,
    ar: 'تعذّر التحقق من حساب Google. حاول مرة أخرى.',
    en: 'We could not verify your Google account. Please try again.',
  },
} as const satisfies Record<string, { status: number; ar: string; en: string }>;

export type ErrorCode = keyof typeof ERROR_CATALOG;

export type Language = 'ar' | 'en';

/** Arabic is the default; English only when the client asks for it first (FR-LOC). */
export function pickLanguage(
  acceptLanguage: string | string[] | undefined,
): Language {
  const header = Array.isArray(acceptLanguage)
    ? acceptLanguage[0]
    : acceptLanguage;
  if (!header) return 'ar';
  const first = header.split(',')[0]?.trim().toLowerCase() ?? '';
  return first.startsWith('en') ? 'en' : 'ar';
}

export function codeForStatus(status: number): ErrorCode {
  switch (status) {
    case 400:
      return 'BAD_REQUEST';
    case 401:
      return 'UNAUTHORIZED';
    case 403:
      return 'FORBIDDEN';
    case 404:
      return 'NOT_FOUND';
    case 409:
      return 'CONFLICT';
    case 426:
      return 'UPGRADE_REQUIRED';
    case 429:
      return 'RATE_LIMITED';
    case 503:
      return 'SERVICE_UNAVAILABLE';
    default:
      return 'INTERNAL';
  }
}
