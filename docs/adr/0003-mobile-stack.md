# ADR 0003: تقنيات تطبيق الموبايل

- **الحالة:** مقبول · 2026-11-11 · S0
- **القرار:** Flutter 3.47 (Dart 3.13)، Riverpod 3 مع codegen، go_router، very_good_analysis، ملفات ARB (العربية هي القالب والافتراضي).
- **تفاصيل:**
  - معرّف التطبيق `com.bellebiens.app`، وAndroid بثلاث flavors (`dev` و`stg` و`prod`)، والحد الأدنى Android 9 (API 28) وiOS 15 (SRS 2.4).
  - `dart fix` يحوّل المُنشئات إلى صيغة Dart 3.13 الجديدة (`const new(...)`)؛ نتبعها لأنها توصية المحلل.
  - AGP 9 يعطّل `resValue` افتراضياً، ففعّلناه لاسم التطبيق في كل flavor.
- **النتائج:** الإعدادات تمر عبر `--dart-define-from-file=env/<flavor>.json` بلا أسرار (NFR-SEC-05).
