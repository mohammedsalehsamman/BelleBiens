# ADR 0002: تقنيات الباك إند

- **الحالة:** مقبول · 2026-11-11 · S0
- **القرار:** NestJS 12 (TypeScript، ESM)، PostgreSQL 16 عبر Prisma 7، وRedis مع BullMQ للمهام الخلفية (DC-01، DC-04، المخطط 6).
- **تفاصيل ظهرت عند التنفيذ:**
  - NestJS 12 ينشئ المشروع بـ **Vitest** و**oxlint** بدل Jest وESLint. اعتمدنا الافتراضي؛ في الخطة كلمة Jest تعني Vitest الآن.
  - وسم `latest` لحزمة prisma على npm يشير إلى نسخة 8.0 تجريبية (RC)، فثبّتنا **7.10.x** المستقرة.
  - Prisma 7 يتطلب driver adapter (`@prisma/adapter-pg`) وملف `prisma.config.ts`، والعميل يُولَّد في `src/generated/prisma` عند التثبيت.
  - `tsx` لا يصدر decorator metadata، لذلك يعمل تصدير OpenAPI من ناتج `nest build`.
  - `prisma init` أضاف مجلدات agent skills (`.claude/skills` وغيرها) لم نطلبها؛ حُذفت.
- **النتائج:** أخطاء موحّدة بصيغة problem+json مع رمز ثابت ورسالة عربية/إنكليزية، و`Clock` قابلة للحقن لكل منطق الوقت.
