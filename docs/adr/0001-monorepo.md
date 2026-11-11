# ADR 0001: مستودع واحد (Monorepo)

- **الحالة:** مقبول · 2026-11-11 · S0
- **السياق:** الباك إند والتطبيق (ولاحقاً الموقع) يجب أن يعطوا نفس السعر ونفس فحص الـ spec (NFR-FUN-01، NFR-MNT-03)، وأن يتطابق العقد مع الـ API (NFR-MNT-04).
- **القرار:** مستودع Git واحد: `apps/api` (NestJS) و`apps/mobile` (Flutter) و`packages/contracts` (OpenAPI وJSON Schemas ومتجهات الاختبار) و`infra` و`docs`. أجزاء TypeScript تُدار بـ pnpm workspaces، وFlutter مستقل داخل `apps/mobile`.
- **النتائج:** تغيير العقد والتطبيقين يتم في PR واحد، والـ CI يفحص كل جزء حسب المسارات التي تغيّرت. قالب Flutter القديم في جذر المجلد نُقل إلى نسخة احتياطية وأُنشئ المشروع من جديد.
