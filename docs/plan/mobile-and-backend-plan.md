# خطة تنفيذ Belle Biens: الباك إند (NestJS) وتطبيق الموبايل (Flutter) مع خطة الاختبارات

## 0. السياق

- **المصادر:** الـ SRS (BB-SRS-001 v0.1) ومخططات التصميم (14 مخطط) وواجهات الموبايل الـ 39 بصيغة HTML في `C:\Users\Moham\Desktop\Belle-SRS\belle_biens_mobile_screens` (مع `DESIGN.md` و`README.md`).
- **الوضع الحالي:** `c:\Users\Moham\Desktop\Belle` مشروع Flutter فارغ (قالب العدّاد). فيه Android فقط، ولا يوجد iOS ولا Git. الـ applicationId هو `com.belle.belle`.
- **المطلوب:** خطة كاملة لبناء الباك إند المشترك وتطبيق الموبايل، مع خطة اختبارات شاملة.
- **خارج هذه الخطة:** الموقع ولوحة الإدارة (Next.js) لهما خطة منفصلة. لكن هذه الخطة تبني كل الـ API الذي ستستخدمه اللوحة.
- **قرارات المستخدم:**
  - الباك إند يُبنى ضمن هذه الخطة.
  - إدارة الحالة Riverpod مع go_router.
  - مطوّر واحد، بلا موعد ثابت.
  - بناء iOS عبر Codemagic.
- **تغيير على ترتيب الإصدارات في SRS 2.7:** صار ترتيب البناء الباك إند ثم الموبايل ثم الويب، بدل ترتيب الـ SRS (الويب أولاً). يُسجَّل هذا كطلب تغيير حسب 6.4 وكقرار جديد في الملحق D.

---

## 1. القرارات الأساسية

| المجال | القرار | السبب |
|---|---|---|
| المستودع | Monorepo واحد (Git) | عقود ومتجهات اختبار مشتركة (NFR-MNT-03، NFR-MNT-04) |
| الباك إند | NestJS + TypeScript، وPostgreSQL 16 عبر Prisma، وRedis + BullMQ للمهام | DC-01 وDC-04 والمخطط 6 |
| الموبايل | Flutter (Android 9+ / iOS 15+)، وRiverpod 3 (codegen)، وgo_router، وfreezed | DC-03 وقرار المستخدم |
| العقد | Contract-first: ملف OpenAPI مولّد من Nest ومحفوظ في المستودع، وعميل Dart مولّد منه | EI-CM-02 وNFR-MNT-04 |
| التسعير | الخادم هو المرجع. التطبيق يحسب تقديراً فورياً بنفس الخوارزمية، ويتأكد من الخادم بعد توقف قصير (debounce) | NFR-SEC-06 وNFR-PERF-03 (200ms) وNFR-FUN-01 |
| معاينة 2D | خوارزمية توزيع حتمية (Pure function) على Dart وTS، تُثبت بمتجهات مشتركة | FR-D2D-02 إلى 04 |
| 3D (R3) | عارض ويب (Three.js/R3F) داخل WebView مع جسر JS | القرار D-05 |
| iOS / CI | GitHub Actions لفحوص الـ PR، وCodemagic لبناء التطبيق وتوزيعه على TestFlight وPlay | قرار المستخدم |
| الخرائط | `flutter_map` مع مزوّد بلاطات تجاري (MapTiler/Stadia). لا Google Maps | توفر خدمات Google في سوريا غير مضمون (R-01) |
| المال | كل مبلغ يُخزَّن كعدد صحيح بأصغر وحدة مع رمز العملة (`Money`)، وسعر الصرف `Decimal` | دقة حتى آخر رقم (6.2، FR-PAY-06) |

---

## 2. هيكل المستودع

```
Belle/                         ← git init هنا (DC-08)
  apps/
    mobile/                    ← مشروع Flutter جديد (android + ios)
    api/                       ← NestJS
  packages/
    contracts/                 ← openapi.yaml + JSON Schemas + متجهات الاختبار المشتركة
    viewer3d/                  ← (R3) عارض 3D (Vite + R3F) يُضمَّن في WebView
  infra/
    docker-compose.yml         ← postgres, redis, seaweedfs (S3), mailpit
    k6/                        ← اختبارات الحمل
  docs/                        ← SRS، المخططات، ADRs، runbook، نسخة من واجهات HTML
  .github/workflows/  codemagic.yaml  pnpm-workspace.yaml  README.md
```

**ما يحدث للمجلد الحالي:** محتوى Flutter الحالي قالب افتراضي بلا كود مخصّص. لذلك:

1. نحذف ملفات القالب من الجذر: `lib/` و`test/` و`android/` و`build/` و`.dart_tool/` و`.idea/` و`pubspec.*` و`analysis_options.yaml` و`belle.iml` و`README.md` و`.metadata`.
2. ننشئ المشروع من جديد بهذا الأمر:
   `flutter create --org com.bellebiens --project-name belle_biens --platforms android,ios apps/mobile`

معرّف التطبيق في الإنتاج يصبح `com.bellebiens.app`، مع لاحقة `.dev` لبيئة dev و`.stg` لـ staging.

### packages/contracts (العقود المشتركة)

| الملف | المحتوى | من يستخدمه |
|---|---|---|
| `openapi.yaml` | مولّد من Nest. يفشل الـ CI إذا اختلف عن الـ API الفعلي | توليد عميل Dart وTS |
| `schemas/bouquet-spec.v1.json` و`box-spec.v1.json` | الملحق B بصيغة JSON Schema | Ajv في الخادم، و`json_schema` في Dart |
| `vectors/pricing.json` | مدخلات ومخرجات خط التسعير (المخطط 9)، ومنها سلة README: 2,676 + 1,080 + 3,360 + 150 = **7,266 ل.س ≈ $60.55** بسعر 120 | Jest وflutter test |
| `vectors/layout.json` | spec + slot layout ← مواقع الطبقات المتوقعة | FR-D2D-03 و04 |
| `vectors/spec-hash.json` | الـ hash عبر JSON مقنّن (RFC 8785)، بدون `cardMessage` و`previewMode` | FR-DAI-06 |
| `vectors/arabic-normalize.json` | إزالة التشكيل وتوحيد أ/إ/آ←ا وة←ه وى←ي | FR-CAT-04 |
| `vectors/phone.json` | قبول `09XXXXXXXX` و`+9639XXXXXXXX` | FR-CRT-09 |
| `vectors/delivery-calendar.json` | مدة التجهيز وساعات العمل والأيام المغلقة ونافذة الـ 60 يوماً | FR-DLV-03 و05 و09 |

---

## 3. الباك إند (NestJS)

### 3.1 التقنيات

- **الأساس:** Node 24 LTS، وNestJS (أحدث إصدار مستقر)، وpnpm workspaces، وPrisma، وPostgreSQL 16، وRedis 7، وBullMQ.
- **التحقق من المدخلات:**
  - `class-validator` مع `whitelist` و`forbidNonWhitelisted`، فأي حقل سعر يرسله العميل يُرفض (NFR-SEC-06).
  - Ajv لفحص الـ spec.
- **المصادقة:**
  - `@nestjs/jwt` وargon2id (NFR-SEC-02) و`google-auth-library`.
  - `otplib` للتحقق الثنائي TOTP للمالك والمدير (FR-ADM-11).
- **الحماية والتوثيق:** `@nestjs/throttler` مع Redis، و`@nestjs/swagger`.
- **السجلات والمراقبة:** `nestjs-pino`، و`@sentry/nestjs`، و`@nestjs/terminus` لفحص الصحة.
- **أدوات العمل:**
  - luxon لمنطقة Asia/Damascus.
  - `@turf/boolean-point-in-polygon` لمناطق التوصيل.
  - `libphonenumber-js` للهواتف.
  - `sharp` و`file-type` للملفات المرفوعة.
  - `stripe` في R3.
- **الاختبار:** Jest وSupertest وTestcontainers و`jest-openapi` وk6.

### 3.2 الوحدات (حسب المخطط 6)

البنية: `src/modules/<module>/{controller, service, domain, repository}`، و`src/adapters/*` خلف واجهات DI. الوحدات لا تستدعي مزوّداً خارجياً مباشرة (NFR-FLX-02).

| الوحدة | ما تملكه | المتطلبات |
|---|---|---|
| accounts | التسجيل والدخول (بريد، Google، OTP)، والجلسات وتجديد التوكن، والأجهزة (FCM token)، والملف، والعناوين، والمفضلة، والمناسبات، والتصاميم المحفوظة، والحذف والتصدير | FR-ACC-*، EI-SW-06، DC-07 |
| catalog | التصنيفات، والمنتجات والخيارات والصور، والفلاتر، والبحث العربي، وصفحات المناسبات، وتجميعة الرئيسية | FR-CAT-*، FR-CKE-01..05 |
| designer | عناصر المصمّم، والأحجام (حد أدنى وأعلى للسيقان)، ولوحات الألوان، وقواعد الدمج، وslot layouts بإصدارات، وفحص الـ spec، والوصفة | FR-DSG-*، FR-D2D-*، FR-BOX-* |
| pricing | خط التسعير خطوة بخطوة (المخطط 9)، وQuote، وتثبيت السعر وسعر الصرف في الطلب | FR-DSG-08، FR-PAY-05/06، NFR-SEC-06 |
| inventory | مستويات المخزون والحجز والحركات، وورد اليوم، وحد التنبيه، والنوافذ الموسمية | FR-INV-*، FR-DLY-* |
| delivery | المناطق (polygons)، وفحص النقطة، والرسوم، والمواعيد والسعة، وحجز الموعد مؤقتاً، وتقويم العمل | FR-DLV-*، المخطط 10 |
| orders | السلة (للحساب)، والطلب، والترقيم `BB-####`، وIdempotency، والنسخة المحفوظة وقت الطلب، وآلة الحالات وسجلها، والإلغاء، وإعادة الطلب | FR-CRT-*، FR-ORD-* |
| payments | `PaymentProvider` (Cash وShamCash وStripe)، وحالات الدفع، والإيصالات، والـ webhooks، والاسترداد | FR-PAY-*، EI-CM-03 |
| notifications | قوالب عربي وإنكليزي، و`MessagingProvider` (WhatsApp وSMS وFCM)، والإعادة، والسجل، وتفضيلات الإلغاء | FR-NTF-* |
| content | الصفحات والبانرات والفرع والسياسات، والتقييمات (R3) | FR-CON-* |
| settings | سعر الصرف، والساعات، والأيام المغلقة، ووضع المحل، والحدود، وطرق الدفع المفعّلة، و`/app/config` | FR-ADM-05/07/12، FR-PAY-01، NFR-CMP-01 |
| reports / audit / media | التقارير وتصدير CSV، وسجل التدقيق (إضافة فقط)، ورفع الوسائط وفحصها | FR-RPT-*، FR-ADM-09، NFR-SEC-08/12 |
| ai-previews (R3) | بناء الـ prompt من الـ spec فقط، والكاش بالـ hash، والحدود والميزانية | FR-DAI-* |

### 3.3 نموذج البيانات (Prisma)

النماذج تغطي DR-01 إلى DR-21، وفيها حقل `branchId` على الطلبات والمخزون (NFR-FLX-03):

- **الحسابات:** `User`، `RefreshToken`، `OtpCode`، `Device`، `Address`، `Favorite`، `OccasionReminder`.
- **الكتالوج:** `Category`، `Product`، `ProductOption`، `ProductImage`، `Page`، `Banner`، `Branch`.
- **المصمّم:** `DesignerItem`، `SizeConfig`، `Palette`، `DesignRule`، `SlotLayout`، `BoxType`، `BouquetDesign` (لا يتغيّر بعد الطلب).
- **المخزون:** `StockLevel(quantity, reserved)`، `StockMovement`، `StockReservation`، `DailyAvailability`.
- **التوصيل:** `DeliveryZone(polygon GeoJSON, fee, eta)`، `TimeSlot(capacity)`، `SlotHold(expiresAt)`، `ClosedDay`.
- **الطلبات:** `Cart`، `CartLine`، `Order`، `OrderLine(priceSnapshot, optionsSnapshot)`، `OrderStatusHistory`، `IdempotencyKey`.
- **الدفع:** `Payment`، `PaymentEvent`، `Refund`، `Coupon`، `CouponRedemption`.
- **النظام:** `Setting`، `NotificationTemplate`، `NotificationLog`، `AuditLog`، `Review` (R3)، `AiPreview` (R3).

### 3.4 قواعد العمل الحرجة وكيف تُنفَّذ

1. **حجز المخزون دون بيع زائد (FR-INV-02/03، NFR-FUN-02):**
   - داخل معاملة واحدة: `UPDATE stock_level SET reserved = reserved + n WHERE item_id = $1 AND quantity - reserved >= n`.
   - إذا لم يتأثر أي صف، يرجع الخطأ `STOCK_INSUFFICIENT` مع بدائل مقترحة.
   - يُحرَّر الحجز عند الإلغاء أو انتهاء المهلة. اقتراح للتأكيد مع المحل: يتحول الحجز إلى خصم فعلي عند الانتقال إلى "قيد التحضير".
2. **منع تكرار الطلب (FR-CRT-10):** ترويسة `Idempotency-Key` يولّدها التطبيق عند مراجعة الطلب. جدول بمفتاح فريد يخزّن الرد مدة 24 ساعة.
3. **آلة حالات الطلب (FR-ORD-02/03، المخطط 3):**
   - `Order.advance(to, by)` تتحقق من جدول الانتقالات المسموحة ومن جدول الأدوار في المخطط 13.
   - كل تغيير يُكتب في `OrderStatusHistory` وفي سجل التدقيق.
   - حالة الدفع (Pending وPaid وFailed وRefunded) منفصلة عن حالة الطلب.
4. **التسعير (المخطط 9):**
   - الخطوات بالترتيب: فحص ← أسعار من قاعدة البيانات ← مجموع العناصر ← رسوم التنسيق (إعداد، افتراضيها 0) ← الكوبون ← رسوم المنطقة ← التحويل للعملة ← التقريب (إعداد) ← Quote.
   - كل خطوة دالة نقية مختبرة بالمتجهات.
   - عند الطلب يُثبَّت السعر وسعر الصرف في الطلب.
5. **الوقت والتقويم (FR-DLV-03/05/09، FR-LOC-03):**
   - خدمة `Clock` قابلة للحقن، وتُثبَّت قيمتها في الاختبارات.
   - أبكر موعد = الآن + أطول مدة تجهيز بين عناصر السلة، ثم تُطبَّق ساعات العمل والأيام المغلقة.
   - التخزين بصيغة `timestamptz`، والمنطق والعرض بتوقيت Asia/Damascus.
6. **المواعيد والسعة (FR-DLV-04):** يُحجز الموعد مؤقتاً (`SlotHold`) لمدة 15 دقيقة، وهي قابلة للضبط. الموعد الممتلئ لا يُعرض.
7. **فحص الـ spec (NFR-SEC-07، FR-DSG-14):**
   - Ajv حسب المخطط، ثم قواعد الحجم والدمج، ثم المخزون.
   - رقم إصدار مخطط غير معروف يُرفض.
8. **الأخطاء (NFR-INT-05):** صيغة `application/problem+json` مع رمز ثابت، مثل `OUT_OF_ZONE` و`SLOT_FULL` و`SHOP_CLOSED` و`SPEC_INVALID` و`UPGRADE_REQUIRED`. التطبيق يترجم الرمز إلى رسالة بلغة الزبون.
9. **دعم الإصدارات القديمة (NFR-CMP-01):** التطبيق يرسل `X-App-Version`. إذا كان الإصدار أقدم من المدعوم يرد الخادم بـ `426`، ويعرض التطبيق شاشة التحديث.

### 3.5 الـ API (REST `/v1`، مختصر)

**للزبون:**

| المجال | النقاط |
|---|---|
| الإعداد العام | `GET app/config` (الحد الأدنى للإصدار، المزايا المفعّلة، طرق الدفع، وضع المحل، سعر الصرف، الساعات) |
| المصادقة | `auth/otp/request`، `auth/otp/verify`، `auth/google`، `auth/register`، `auth/login`، `auth/refresh`، `auth/logout`، `auth/password/*` |
| الحساب | `GET/PATCH me`، `me/addresses`، `me/favorites`، `me/occasions`، `me/designs`، `me/devices`، `me/preferences`، `POST me/export`، `DELETE me` |
| الكتالوج | `GET home`، `categories`، `products?filters`، `products/:slug`، `search?q`، `occasions/:slug`، `daily-flowers`، `branch`، `pages/:slug` |
| المصمّم | `GET designer/catalog` (العناصر والأسعار والمخزون والأحجام والقواعد وإصدار الـ layouts)، `GET designer/layouts/:size`، `POST designer/quote`، `POST designer/preview-image`، `GET box-types` |
| السلة والتوصيل | `GET/PUT cart`، `POST cart/quote`، `POST delivery/zone-check`، `GET delivery/dates`، `GET delivery/slots`، `POST delivery/slot-holds` |
| الطلبات | `POST orders` (Idempotency)، `GET orders`، `GET orders/:number`، `POST orders/lookup` (رقم الطلب + الهاتف للضيف)، `POST orders/:n/cancel`، `POST orders/:n/reorder` |
| الدفع | `POST orders/:n/payments`، `POST payments/:id/proof`، و`webhooks/shamcash` و`webhooks/stripe` و`webhooks/whatsapp` |
| R3 | `POST ai-previews`، `GET ai-previews/:id`، `POST orders/:n/review` |

**لفريق المحل** (`/v1/admin/*`، مع حارس أدوار يطبّق جدول المخطط 13):

- الطلبات: قائمة، وفلترة، وتغيير الحالة، وتعيين المندوب، والملاحظات، والإلغاء والاسترداد، وطباعة الوصفة وقسيمة الطلب بصيغة HTML (A4 و80mm).
- التحقق من إيصالات شام كاش أو رفضها.
- ورد اليوم، وضبط المخزون، والمخزون المنخفض.
- CRUD للمنتجات وعناصر المصمّم وأنواع الصناديق والـ layouts، مع رفع الصور ومجسمات GLB.
- تعديل الأسعار جماعياً، وسعر الصرف، والكوبونات، والمناطق والمواعيد والساعات والأيام المغلقة ووضع المحل.
- الصفحات والبانرات، والتقارير وتصدير CSV، والمستخدمون والأدوار، وسجل التدقيق.
- بث SSE للطلبات الجديدة (FR-ORD-08).

### 3.6 الأمان (NFR-SEC)

| المتطلب | التنفيذ |
|---|---|
| SEC-01 | `RolesGuard` على كل نقطة، واختبار مصفوفة الأدوار مبني من جدول المخطط 13 |
| SEC-02 | argon2id، وكلمة المرور 8 أحرف على الأقل |
| SEC-03 | حدود معدل عبر Redis: طلب OTP 3 مرات كل 10 دقائق لكل رقم، والدخول 5 مرات كل 15 دقيقة، والكوبون 10 مرات في الساعة، وAI حسب FR-DAI-05 |
| SEC-05 | المفاتيح السرية في متغيرات البيئة أو مخزن أسرار فقط، وفحص gitleaks في الـ CI |
| SEC-06/07 | الخادم يتجاهل أي سعر من العميل، ويفحص الـ spec دائماً |
| SEC-08 | فحص نوع الملف من بايتاته الأولى، وحدود الحجم، وإعادة ترميز الصور بـ sharp لإزالة البيانات الوصفية، وفحص الشفافية للصور المقصوصة |
| SEC-09 | تشفير على مستوى التخزين للقاعدة والنسخ الاحتياطية، وTLS 1.2 أو أعلى |
| SEC-10 | رمز OTP يُخزَّن مُجزَّأً (hashed)، ويصلح 5 دقائق، و5 محاولات كحد أقصى |
| SEC-11/12 | جلسة اللوحة تنتهي بعد 30 دقيقة خمول، وجدول التدقيق يمنع التعديل والحذف بـ trigger وصلاحيات القاعدة |
| EI-CM-03 | فحص توقيع كل webhook على الجسم الخام، ومعالجة الحدث مرة واحدة حسب رقمه |

### 3.7 المهام الخلفية (worker بنفس الكود، المخطط 11)

- `cancel-unpaid`: إلغاء الطلب غير المدفوع بعد ساعتين افتراضياً (FR-PAY-10).
- `release-stock` و`release-slot-holds`.
- `expire-daily-flowers` عند 00:00 بتوقيت دمشق (FR-DLY-05).
- `retry-notifications` مع تأخير متزايد (FR-NTF-07).
- `occasion-reminders` (FR-ACC-07).
- `ai-preview` (R3) بمهلة 60 ثانية وإعادة واحدة.

### 3.8 البيئات

| البيئة | المحتوى |
|---|---|
| dev | `docker compose up` يشغّل Postgres وRedis وSeaweedFS (بديل S3) وMailpit. المزوّدون الخارجيون محاكون: رسائل OTP تُطبع في السجل، والدفع والإشعارات تمر عبر مزوّدات console |
| staging | نفس شكل الإنتاج، مع مزوّدات sandbox وبيانات تجريبية (NFR-MNT-02) |
| prod | مزوّد الاستضافة قرار مفتوح (OI-04). نسخ احتياطي يومي يُحفظ 30 يوماً، واختبار استعادة كل ربع سنة (NFR-REL-02) |

الـ API والـ worker صور Docker. التهجيرات بأمر `prisma migrate deploy` تُطبَّق على staging أولاً.

---

## 4. تطبيق الموبايل (Flutter)

### 4.1 الحزم

| المجال | الحزم |
|---|---|
| الحالة والتنقل | `flutter_riverpod`، `riverpod_annotation`، `riverpod_generator`، `go_router` |
| النماذج | `freezed`، `json_serializable`، `build_runner` |
| الشبكة | `dio`، وعميل retrofit مولّد من `openapi.yaml` عبر `swagger_parser` (إلى `lib/core/api/generated/`، ولا يُعدَّل يدوياً)، `connectivity_plus` |
| التخزين | `drift` لكاش الكتالوج وسلة الضيف ومسودة التصميم وطلبات الضيف، `flutter_secure_storage` للتوكنات، `shared_preferences` |
| اللغة والوقت | `flutter_localizations`، `intl` (ملفات ARB عربي وإنكليزي)، `timezone` |
| الواجهة | `flutter_svg`، `cached_network_image`، `skeletonizer` |
| الخطوط | IBM Plex Sans Arabic وPlayfair Display مضمّنة في التطبيق، لأن الشبكة غير مستقرة (LEG-04: رخصة OFL) |
| الخرائط | `flutter_map`، `latlong2` |
| الجهاز | `image_picker`، `url_launcher`، `share_plus`، `permission_handler`، `package_info_plus`، `app_links` |
| Firebase | `firebase_core`، `firebase_messaging`، `flutter_local_notifications`، `firebase_analytics` (بعد الموافقة فقط) |
| الأعطال والدخول | `sentry_flutter`، `google_sign_in` |
| R3 | `webview_flutter` |
| التطوير | `very_good_analysis`، `mocktail`، `alchemist` (golden)، `patrol`، `integration_test`، `json_schema`، `widgetbook` |

الإصدارات تُثبَّت في `pubspec.lock` عند السبرنت 0.

### 4.2 هيكل الكود

```
apps/mobile/lib/
  main.dart                    ← --dart-define-from-file=env/{dev,staging,prod}.json + flavors
  app/   app.dart · router/ (routes, guards: onboarding/auth/force-update/shop-closed) · theme/ · l10n/
  core/  network/ (interceptors: auth-refresh, retry, idempotency, locale, app-version, problem→AppError)
         api/generated/ · storage/ (drift db) · money/ · time/ · text/arabic_normalize.dart
         validation/phone.dart · analytics/ · notifications/ · deeplinks/ · whatsapp/ · widgets/ (نظام التصميم)
  features/<feature>/{data, domain, presentation}
     onboarding · auth · home · catalog · designer · box_builder · cart · checkout · orders · account · branch · system
```

### 4.3 نظام التصميم (من DESIGN.md وREADME)

- **الرموز (Tokens):** `ThemeExtension`s اسمها `BBColors` و`BBSpacing` و`BBRadius` و`BBShadows`، والخطوط `BBTypography`.
  - الألوان الأساسية: primary `#872341`، والخلفية `#FFF8F6`، والحدود `#EFE8E1`، والنص `#2C2422`.
  - النص الثانوي `#605856`، والشارات بالألوان الأغمق حسب README حتى تحقق تباين AA.
- **المكوّنات** (مأخوذة من CSS الشاشات):
  - `BBButton` بأنواعه: primary وsecondary وghost وwhatsapp وsm.
  - `BBChip`، `BBBadge` (sage وblush وamber وgreen وred وgray وdark)، `BBCard`.
  - `ProductCard`، `QtyStepper` (أزرار 40px داخل هدف لمس 48dp)، `OptionTile` (radio/checkbox)، `SegmentedPill`.
  - `BBToggle`، `BBField`، `NoticeBanner` (info وok وwarn وerr)، `StepsBar`، `StatusTimeline`، `KvRow`.
  - `BottomNav` مع زر "صمّم باقتك" المرتفع في الوسط، و`CartCapsule` فوق شريط التنقل، و`BottomCta`، و`BBSheet`.
- **الأيقونات:** الـ SVG المضمّنة في HTML تُستخرج إلى `assets/icons/*.svg` عبر `BBIcon` enum. الأيقونات الاتجاهية (الأسهم والرجوع) تنعكس في RTL، والأيقونات العامة لا تنعكس (FR-LOC-01).
- **مطابقة التصميم:** `widgetbook` يعرض كل المكوّنات للمقارنة مع HTML. كل شاشة تُقارن بملفها `code.html` بعرض 390، ثم تُفحص على 360 (NFR-INT-04).

### 4.4 محرك المصمّم 2D (أهم جزء)

- **الحالة:**
  - `DesignerController` (Riverpod Notifier) يحمل `BouquetSpec` غير قابل للتعديل (freezed، مطابق للملحق B).
  - سجل `History` للتراجع والإعادة والإعادة للبداية، بحد أقصى 50 خطوة (FR-DSG-10).
  - حفظ تلقائي للمسودة في drift واستعادتها (FR-DSG-11). المسودة لا تضيع عند تبديل اللغة (EI-UI-01).
- **التوزيع:**
  - `layoutBouquet(spec, slotLayout, items) → List<PlacedLayer>` دالة نقية بلا عشوائية.
  - ترتيب الطبقات ثابت: خلفية التغليف ← الخضرة ← الورد ← واجهة التغليف ← الشريط ← الإضافات (FR-D2D-01).
  - الإحداثيات نسبية (0..1) على لوحة بنسبة 4:5، فتكون النتيجة متطابقة على كل جهاز (FR-D2D-03).
  - تمر بنفس متجهات `layout.json` التي تمر بها نسخة TS.
- **الرسم:**
  - `BouquetPainter` (CustomPainter) يرسم `ui.Image` محمّلة مسبقاً.
  - إذا فشل تحميل صورة يظهر بديل محايد بدلها (FR-D2D-06).
  - التصدير عبر `PictureRecorder` بحجم ثابت 1080×1350 بصيغة PNG، ثم رفع إلى `designer/preview-image`. الرابط الناتج يُستخدم في السلة والطلب والوصفة ورسالة واتساب (FR-D2D-05).
- **السعر:**
  - `PricingEstimator` (Dart) يعطي السعر فوراً بعد كل تغيير، في أقل من 200ms (NFR-PERF-03).
  - بعد 400ms من آخر تغيير يُطلب `designer/quote`، وقيمة الخادم هي المعتمدة.
  - أي اختلاف بين التقدير وقيمة الخادم يُسجَّل في Sentry.
  - رد الخادم يتضمن التوفر والبدائل، ويظهر عند النقص الإشعار 37 (FR-DSG-03).
- **الإرسال:**
  - "أضف إلى السلة" تُحفظ كسطر واحد فيه الـ spec والمعاينة والسعر (FR-CRT-02).
  - "أرسل للمحل" تفتح رابط `wa.me` فيه الملخص ورابط صورة المعاينة (FR-DSG-13، EI-SW-01).
  - "خصّصها في المصمّم" تفتح باقة جاهزة كنقطة بداية (FR-CAT-07).
- **الإشعار الدائم:** "قد تختلف الباقة النهائية قليلاً…" يظهر مع كل معاينة (FR-DSG-15).

### 4.5 الشبكة والعمل دون اتصال

- **interceptors:** تجديد التوكن مرة واحدة مع قفل، وإعادة المحاولة مع تأخير متزايد للطلبات الآمنة فقط (NFR-REL-05)، وترويستا `Accept-Language` و`X-App-Version`.
- **كاش الكتالوج:** آخر كتالوج محمّل يُعرض عند انقطاع الاتصال، مع شريط "غير متصل" (الشاشة 39).
- **السلة:**
  - سلة الضيف محلية.
  - سلة الحساب تتزامن مع الخادم وتُدمج مع السلة المحلية عند الدخول (FR-CRT-03).
- **طلبات الضيف:** أرقامها تُحفظ محلياً لتظهر في "طلباتي"، مع إمكانية البحث برقم الطلب والهاتف (FR-ORD-04).

### 4.6 اللغة والاتجاه والأرقام والوقت

- العربية افتراضياً واتجاهها RTL، والإنكليزية LTR. التبديل فوري ولا يضيع السلة أو التصميم (EI-UI-01).
- `MoneyFormatter`:
  - الأرقام غربية افتراضياً، والهندية خيار في الإعدادات (FR-LOC-02).
  - العرض بالليرة أو الدولار مع خانات بعرض ثابت (tabular).
- التاريخ والوقت بتوقيت Asia/Damascus والتقويم الميلادي، مثل "11 تشرين الثاني" (FR-LOC-03).
- إذا غاب نص الحقل بلغة يُعرض نصه باللغة الأخرى (FR-LOC-04).

### 4.7 التكاملات

| التكامل | التنفيذ |
|---|---|
| Push (EI-SW-09، FR-NTF-04) | FCM (يغطي APNs في iOS)، والـ token يُسجَّل في `me/devices`. النقر على الإشعار يفتح `/orders/:number` عبر go_router. طلب الإذن من الشاشة 05 فقط |
| واتساب | روابط `wa.me` مع رسائل مُعدّة مسبقاً (EI-SW-01، FR-CRT-12) |
| الخرائط | `flutter_map` لدبوس العنوان (الشاشة 22)، و`delivery/zone-check` فوري، وفتح تطبيق الخرائط للاتجاهات (EI-SW-07) |
| الكاميرا | `image_picker` لإيصال شام كاش فقط (EI-HW-02) |
| التحليلات | شاشة موافقة أولاً (FR-ANL-01)، ثم أحداث FR-ANL-02 الستة |
| الروابط العميقة | تتبع الطلب، والعودة من Stripe (R3)، ومشاركة التصميم (R3) |
| فرض التحديث | `app/config` أو رد `426` يعرض شاشة "حدّث التطبيق" (NFR-CMP-01) |
| وضع المحل | "مشغول" أو "مغلق" يعرض الشاشة 39 ويوقف الدفع (FR-ADM-12) |

### 4.8 خريطة الشاشات ← المسارات ← السبرنت

| # | الشاشة | المسار | سبرنت |
|---|---|---|---|
| 01–05 | الترحيب، الدخول، التسجيل، OTP، الإشعارات | `/onboarding`، `/auth/login`، `/auth/register`، `/auth/otp`، `/permissions/notifications` | S1 |
| 06 | الرئيسية (تبويب) | `/` | S2 |
| 07–09 | المتجر (تبويب)، البحث، الفلاتر (لوحة سفلية) | `/shop`، `/search`، `/shop?filters` | S2 |
| 10–11 | ورد اليوم، صفحة المناسبة | `/today`، `/occasions/:slug` | S2 |
| 12–14 | صفحة المنتج (باقة، كيك، مشروب) | `/p/:slug`، والأقسام تختلف حسب نوع المنتج | S2 (خيارات الكيك في S4) |
| 15–18 | المصمّم، الخطوات 1 إلى 4 (تبويب) | `/designer/step/:n` | S3 |
| 37 | وردة لم تعد متوفرة (لوحة سفلية) | ضمن المصمّم والسلة | S3 |
| 19 | صندوق ورد وحلويات | `/designer/box` | S4 |
| 20 و35 | السلة والسلة الفارغة | `/cart` | S4 |
| 21–23 | التوصيل، العنوان على الخريطة، طريقة الدفع | `/checkout/delivery`، `/checkout/address`، `/checkout/payment` | S5 |
| 25، 36، 39 | تم الطلب، خارج المنطقة، المحل مغلق أو لا يوجد اتصال | `/orders/:n/confirmed`، `/checkout/out-of-zone`، `/system/closed` | S5 |
| 24 و38 | شام كاش، مشكلة في الدفع | `/checkout/shamcash/:n`، `/checkout/payment-failed/:n` | S6 |
| 26–27 | طلباتي (تبويب) مع بحث الضيف، تتبّع الطلب | `/orders`، `/orders/:n` | S6 |
| 28–33 | حسابي، العناوين، تصاميمي، المناسبات، المفضلة، الإعدادات | `/account/*`، `/settings` | S7 (المفضلة في S2) |
| 34 | الفرع والتواصل | `/branch` | S2 |

---

## 5. خطة الاختبارات

### 5.1 الهرم والأدوات

| المستوى | الباك إند | الموبايل |
|---|---|---|
| Unit | Jest: التسعير، والمخزون، وقواعد التوصيل، وآلات الحالات، وفحص الـ spec، وبناء الـ prompt | flutter_test: محرك التوزيع، و`PricingEstimator`، و`MoneyFormatter`، والتطبيع العربي، والهاتف، والتراجع والإعادة، وتحويل الـ spec إلى JSON مطابق للمخطط |
| المتجهات المشتركة | `contracts/vectors/*` في Jest | نفس الملفات في flutter_test، لضمان النتيجة نفسها حتى آخر رقم (NFR-FUN-01، NFR-MNT-03) |
| Integration | Testcontainers (Postgres وRedis) مع Supertest | Provider tests عبر `ProviderContainer` مع overrides وmocktail |
| Contract | `jest-openapi` يفحص الردود مقابل `openapi.yaml`. فحص في الـ CI يمنع اختلاف العقد | توليد العميل يجب أن ينجح، و`flutter analyze` بلا أخطاء |
| Widget / Golden | لا ينطبق | كل شاشة بحالاتها: تحميل وفارغ وخطأ وبيانات، بالعربية والإنكليزية، وبحجم خط 1.0 و2.0، وبعرض 360 بلا overflow. Goldens عبر alchemist للمكوّنات والشاشات الرئيسية |
| A11y | لا ينطبق | `androidTapTargetGuideline` و`iOSTapTargetGuideline` و`labeledTapTargetGuideline` و`textContrastGuideline` (NFR-INT-02/03) |
| E2E | e2e على API مزروع ببيانات تجريبية | `integration_test` مع Patrol على محاكي Android وAPI محلي في docker: UC-01 وUC-02 وUC-04 وUC-05 (R3) |
| الأداء | k6 | `traceAction` لقياس إطارات المصمّم وزمن الإقلاع وحجم التطبيق |
| الأمان | مصفوفة الأدوار، وحدود المعدل، ورفع الملفات، والـ webhooks، وOWASP ZAP على staging، وفحص الاعتماديات وgitleaks | التخزين الآمن للتوكنات، وعدم وجود أسرار في التطبيق (NFR-SEC-05)، وفحص APK/IPA |
| قابلية الاستخدام | لا ينطبق | 5 مستخدمين جدد أو أكثر (NFR-INT-01)، وUAT مع فريق المحل، وبيتا على TestFlight وPlay Internal |

**نسب التغطية:**

| الجزء | النسبة المطلوبة |
|---|---|
| الباك إند (عام) | 70% أو أكثر |
| التسعير والمخزون والتوصيل | 90% أو أكثر (NFR-MNT-01) |
| الموبايل: `domain/` ومحرك المصمّم | 85% أو أكثر (اقتراح) |
| الموبايل (عام) | 60% أو أكثر (اقتراح) |

### 5.2 بيانات الاختبار (seed)

`apps/api/prisma/seed.ts` يطابق أمثلة شاشات HTML:

| الفئة | البيانات |
|---|---|
| الورد | جوري أحمر 90 (مخزون 120)، جوري وردي 90 (60)، ليزيانثوس 120 (30)، بيوني غير متوفر |
| الخضرة | جيبسوفيلا 60، أوكاليبتوس 40، روسكوس 30 |
| التغليف والشريط والإضافات | تغليف ساتان بوردو 120، شريط ساتان وردي 36، دبدوب صغير 960 |
| الأحجام والعملة | الحجم المتوسط 15–30 ساقاً، وسعر الصرف 120 |
| التوصيل | منطقة أبو رمانة برسوم 150 |
| المنتجات | كيكة 22 سم (مدة تجهيز 24 ساعة)، لاتيه الورد بالماتشا |

**المتجه الذهبي:** باقة README تساوي 12×90 + 6×60 + 3×40 + 120 + 36 + 960 = **2,676**، والسلة الكاملة **7,266 ل.س / $60.55**.

الصور مؤقتة (placeholders) حتى تصل صور التصوير (5.6، R-02).

### 5.3 ربط معايير القبول (SRS 6.2) بالاختبارات

| المعيار | الاختبار الآلي |
|---|---|
| FR-DSG-03 (6 جيبسوفيلا وطُلب 8) | API: `designer-quote.int-spec` يرجع `STOCK_INSUFFICIENT` مع المتوفر 6. موبايل: widget test يوقف `QtyStepper` عند 6 ويعرض الكمية المتوفرة |
| FR-DSG-08، NFR-FUN-01 | `vectors/pricing.json` في Jest وDart، والنتيجة متطابقة حتى آخر رقم |
| FR-D2D-03 | `vectors/layout.json` بالإضافة إلى golden للوحة على جهازين بقياسين مختلفين (360 و412) تعطي مواقع متطابقة |
| FR-DLV-05 | `Clock` مثبتة على 15:00 وكيكة مدتها 24 ساعة، فلا يُعرض أي موعد قبل 15:00 من اليوم التالي (API وDart) |
| FR-DLV-01 | integration `zone-check` يرجع `OUT_OF_ZONE`. Patrol: يظهر 36 مع زر واتساب |
| FR-PAY-03 | integration: الموظف يقبل الإيصال، فيصبح الدفع `Paid` ويُضاف إشعار إلى الطابور. Patrol: UC-02 |
| FR-PAY-06 | integration: تغيير سعر الصرف بعد الطلب لا يغيّر مجموعه |
| FR-INV-03 | integration: `Promise.all` لطلبين على آخر قطعة، ينجح أحدهما فقط ويرجع الآخر `409` |
| FR-DAI-02 (R3) | unit: رسالة بطاقة فيها تعليمات لا يظهر أي جزء منها في الـ prompt |
| FR-DAI-05 (R3) | integration: عند بلوغ الميزانية يرجع `429` برسالة واضحة. widget: المصمّم يستمر بمعاينة 2D |
| NFR-SEC-06 | e2e: طلب فيه حقل `price` يُرفض بـ `400`، والإجمالي دائماً من الخادم |
| FR-LOC-01 | goldens بالعربية مع RTL لكل الشاشات، بلا overflow وبلا نص مقطوع |
| NFR-PERF-01 | خاص بالويب، خارج هذه الخطة |

### 5.4 الأداء والأجهزة

**أهداف الباك إند (k6):**

- `p95 < 500ms` مع 100 مستخدم متزامن (NFR-PERF-06).
- سيناريو الذروة: 500 زائر و50 طلباً في الساعة (NFR-PERF-08).
- مزيج الطلبات: تصفح، وquote للمصمّم، وإتمام طلب.

**أهداف الموبايل:**

- المعاينة والسعر خلال 200ms أو أقل على هاتف Android متوسط من 2020 (NFR-PERF-03).
- اقتراحات إضافية للتأكيد:
  - إقلاع بارد أقل من 2.5 ثانية.
  - حجم APK أقل من 30MB لكل ABI.
  - لا إطارات أبطأ من 16ms في التمرير.

**مصفوفة الأجهزة (2.4):**

- Android 9 ضعيف (2GB RAM).
- Android متوسط من 2020، مثل Galaxy A51.
- Android 14 أو 15.
- iPhone بنظام iOS 15 أو 16 (مثل SE أو 8).
- iPhone حديث.
- العروض: 360 و390 و412.

**فحوص يدوية لكل إصدار:**

- إبطاء الشبكة، ووضع الطيران أثناء الدفع.
- قتل التطبيق أثناء الدفع.
- النقر على الإشعارات، والروابط العميقة.
- انعكاس RTL، وتكبير الخط إلى 200%.

### 5.5 بوابات CI وتعريف "منجز"

**بوابة كل PR** (يجب أن تنجح كلها):

- lint وتنسيق الكود.
- unit وintegration.
- goldens.
- فحص عدم اختلاف OpenAPI.
- نسب التغطية.
- البناء.

**تعريف "منجز" لكل قصة:**

- كود مع اختبارات.
- نصوص عربية وإنكليزية.
- Semantics labels.
- goldens محدّثة.
- OpenAPI محدّث.
- مراجعة مقابل `code.html`.
- صفر تحذيرات من المحلل.
- رقم المتطلب مذكور في الـ commit أو الـ PR.

---

## 6. CI/CD

| الأداة | ما تشغّله |
|---|---|
| GitHub Actions `api.yml` | pnpm، وlint، وtypecheck، وunit، وintegration (services: postgres وredis)، وتصدير openapi ومقارنته، وبناء Docker، ونشر تلقائي إلى staging من `main` |
| GitHub Actions `mobile.yml` | `flutter analyze`، وفحص التنسيق، و`flutter test --coverage` مع goldens على Linux بخطوط مضمّنة، وبناء APK debug |
| GitHub Actions `contracts.yml` | فحص المخططات والمتجهات |
| GitHub Actions (أمان) | Dependabot وOSV-Scanner وgitleaks |
| Codemagic `codemagic.yaml` | `android-staging` و`ios-staging` من `main` إلى Play Internal وTestFlight. `release` من وسم `v*` إلى Play بنشر تدريجي وإلى App Store. اختبارات Patrol على المحاكي |
| التوقيع | مفتاح Android وApp Store Connect API key في متغيرات Codemagic، وليس في المستودع |
| الإنتاج | يتطلب موافقة يدوية بعد staging (المخطط 11) |

---

## 7. خطة السبرنتات (مطوّر واحد، أسبوعان لكل سبرنت)

في كل سبرنت يُبنى الـ API أولاً ثم الشاشات فوقه.

| سبرنت | الباك إند | الموبايل | معيار الخروج |
|---|---|---|---|
| **S0** (أسبوع) | git init وmonorepo وdocker-compose. هيكل Nest: config وhealth وpino وPrisma وفلتر problem+json و`Clock`. هيكل contracts. الـ CI | إنشاء `apps/mobile` (android وios وflavors). very_good_analysis، والهيكل، وربط Codemagic، وSentry | CI أخضر، والتطبيق يعمل على المحاكي بالثيم، وبناء iOS أول على Codemagic |
| **S1** | accounts: OTP وبريد/كلمة مرور وGoogle وJWT مع تجديد التوكن والأدوار، و`me` و`devices`، وsettings و`app/config`، وأساس interceptor التدقيق | الرموز وكل المكوّنات مع widgetbook، وl10n، وRTL، والأرقام، وshell للتبويبات الخمسة، وinterceptors، والشاشات 01–05 | تسجيل ودخول بـ OTP على API محلي. goldens المكوّنات بالعربية والإنكليزية |
| **S2** | catalog وmedia (SeaweedFS محلياً، Cloudinary أو S3 في الإنتاج)، وعناصر المصمّم، وورد اليوم، والمخزون، والبحث العربي، والرئيسية، والمناسبات، والفرع، وCRUD للإدارة، وseed | 06–12 و14 و32 و34، وكاش drift، والتطبيع العربي | تصفح كامل وبحث يطابق المتجهات، والكتالوج يعمل دون اتصال |
| **S3** | الأحجام واللوحات والقواعد والـ layouts، ومخطط الـ spec، وخط التسعير، و`designer/quote` مع البدائل، والـ hash، ورفع المعاينة | محرك المصمّم والتراجع والإعادة والمسودة، والشاشات 15–18 و37، وواتساب، و"خصّصها" | متجهات pricing وlayout وhash تمر في الطرفين، وقياس NFR-PERF-03 |
| **S4** | أنواع الصناديق، وخيارات الكيك ومدة تجهيزها، والسلة ودمجها، والكوبونات، و`cart/quote`، والعملة والتقريب | 19، وخيارات 13، و20 و35، والكوبون، وتبديل العملة، ومزامنة السلة | سلة README تساوي 7,266 / $60.55 على الخادم والتطبيق |
| **S5** | delivery (polygons وتقويم وسعة وحجز مؤقت)، وorders (الترقيم وIdempotency والنسخ المحفوظة والحجز الذري وآلة الحالات والإلغاء)، ووضع المحل، ومهام release وexpire، وإشعار التأكيد | 21–23 و25 و36 و39، والدفع عند الاستلام، والتأكيد عبر واتساب | UC-01 كاملاً بالدفع عند الاستلام، واختبار FR-INV-03 ينجح |
| **S6** | واجهة PaymentProvider بتطبيقَي Cash وShamCash (يدوي، مع محوّل callback حسب OI-09)، والإيصالات، والتحقق والرفض، وإلغاء غير المدفوع، والاسترداد، و`admin/orders` (الوصفة والقسيمة HTML)، وSSE | 24 و38 و26 و27، وبحث الضيف، وإعادة الطلب | UC-02 وUC-04 (عبر admin API) كاملين |
| **S7** | notifications (WhatsApp وSMS وFCM، والقوالب، والإعادة، والسجل، والتفضيلات)، وتذكير المناسبات، والتصدير والحذف، وتقارير FR-RPT-01/03 | FCM ومعالجة النقر، و28–31 و33، والموافقة والتحليلات، وتحويل الضيف إلى حساب | إشعار حالة يصل على Android وiOS (TestFlight) |
| **S8** | مراجعة أمان (ASVS L1 وZAP)، وk6، والنسخ الاحتياطي واختبار الاستعادة، والتنبيهات، والـ runbook | تدقيق a11y، وتحسين الأداء على جهاز ضعيف، وفرض التحديث، ونصوص المتاجر، وData safety وApp Privacy، واختبار 5 مستخدمين | كل متطلبات Must لإصدار الموبايل تمر (6.3) |
| **S9** (1–2 أسبوع) | نشر الإنتاج | بيتا وUAT مع المحل، وإصلاحات، ونشر تدريجي | تطبيق منشور |
| **S10** (R3) | رفع GLB وفحصه (FR-D3D-08) | `packages/viewer3d`، وWebView مع جسر، وخفض الجودة تلقائياً، والرجوع إلى 2D (FR-D3D-*) | تبديل 2D و3D دون فقدان التصميم |
| **S11** (R3) | ai-previews (المحوّل حسب OI-11، والـ prompt من الـ spec، والحدود، والكاش، والسجل) | وضع AI في 18، والتقدّم، والوسم، والإرفاق بالطلب | FR-DAI-02/05 تمر |
| **S12** (R3) | Stripe Checkout وwebhook وUSD، والتقييمات، ومشاركة التصميم | فتح Checkout في المتصفح والعودة برابط عميق ثم متابعة الحالة، والتقييم، والمشاركة | UC-05 كاملاً |

**التقدير:** حوالي 19 أسبوعاً حتى نشر إصدار الموبايل، و6 أسابيع إضافية لـ R3. هذا لمطوّر واحد بدوام كامل، ويُراجع بعد S2 (OI-02).

**اعتمادية الإطلاق:** المحل يحتاج لوحة الإدارة على الأقل لـ:

- الطلبات.
- ورد اليوم.
- التحقق من شام كاش.

الـ admin API جاهز بعد S6. نكتب خطة اللوحة المنفصلة عندها، ويجب أن تكون جاهزة قبل S9. حتى ذلك الوقت تجري الاختبارات الداخلية عبر Swagger UI وسكربتات seed.

---

## 8. ما نحتاجه من المحل ومتى

| البند | قبل |
|---|---|
| OI-05: مزوّد SMS/OTP وواتساب. قبله المزوّد console | S1، ويصبح حرجاً في S8 |
| OI-15: قائمة الورد والخضرة والتغليف والإضافات بالأسعار، وصور التصوير (5.6). قبلها seed وصور مؤقتة | S3 |
| OI-12: العملة الأساسية ومن يحدّث سعر الصرف | S4 |
| OI-13 وOI-14: مناطق التوصيل والرسوم والمواعيد والسعة، ومدد التجهيز وموعد الإغلاق | S5 |
| OI-09: طريقة تأكيد شام كاش | S6 |
| OI-04: مزوّد الاستضافة، ويُفضّل staging قبل S5 | S8 |
| حساب Apple Developer وحساب Google Play Console باسم جهة قانونية مناسبة (LEG-02) | S7 |
| OI-11: مزوّد صور AI والميزانية | S11 |
| OI-10: Stripe | S12 |
| اقتراحات تحتاج تأكيداً | ترتيب الكوبون مقابل رسوم التوصيل، ومدة حجز الموعد، ومتى يتحول الحجز إلى خصم، وصلاحيات الأدوار (المخطط 13) |

## 9. مخاطر خاصة بهذا الجزء

| الخطر | التخفيف |
|---|---|
| توفر Google Play وFCM وGoogle Sign-In في سوريا غير مضمون | OTP عبر الهاتف طريق الدخول الأساسي. إشعارات واتساب وSMS موجودة أصلاً. تحديث حالة الطلب المفتوح كل 60 ثانية. خيار APK موقّع من الموقع. نتحقق من ذلك في S0 |
| بلاطات الخرائط | مزوّد تجاري بمفتاح مقيّد، والتحقق من الشروط |
| تحميل حساب Apple Developer وحساب المتاجر | البدء بالإجراءات مبكراً (S0) |
| تفاوت السعر بين التطبيق والخادم | متجهات مشتركة في الـ CI، والخادم هو المرجع، والتسجيل في Sentry |
| حجم العمل على مطوّر واحد | Must أولاً، ومراجعة التقدير بعد S2، وتأجيل Could |
| تأخر صور المحل | صور مؤقتة، وطبقة layouts مستقلة عن الصور |

---

## 10. التحقق (كيف نتأكد أن كل شيء يعمل)

1. **محلياً:** `docker compose -f infra/docker-compose.yml up -d` ثم `pnpm --filter api prisma migrate dev && pnpm --filter api seed && pnpm --filter api start:dev`. بعدها تُفتح `http://localhost:3000/docs` (Swagger).
2. **اختبارات الباك إند:** `pnpm --filter api test` (unit) و`pnpm --filter api test:int` (Testcontainers) و`pnpm --filter api test:e2e`، ثم `k6 run infra/k6/checkout.js` على staging.
3. **الموبايل:** `cd apps/mobile && dart run build_runner build -d && flutter analyze && flutter test --coverage`. الـ goldens تُحدَّث بأمر `flutter test --update-goldens` فقط عند تغيير مقصود.
4. **E2E على المحاكي:** `patrol test -t integration_test/uc01_design_order_cod_test.dart --dart-define-from-file=env/dev.json` مقابل الـ API المحلي المزروع ببيانات تجريبية. يتكرر لـ UC-02، والخروج من المنطقة، والوردة غير المتوفرة، وتبديل اللغة مع بقاء السلة، والعمل دون اتصال، وفرض التحديث.
5. **يدوياً في كل سبرنت:** تشغيل `flutter run --flavor dev` على جهاز Android حقيقي، ومقارنة كل شاشة جديدة بملف `code.html` المقابل بالعربية والإنكليزية وبعرض 360.
6. **قبل الإطلاق:**
   - Codemagic يبني نسخة staging على TestFlight وPlay Internal.
   - UAT مع المحل بسيناريوهات UC-01 إلى UC-04.
   - اختبار قابلية الاستخدام مع 5 مستخدمين.
   - كل المعايير في القسم 5.3 بحالة Pass في جدول القبول.
   - توقيع المالك (6.3).

**أول خطوة بعد الموافقة:** تنفيذ S0 بالكامل:

- إعادة هيكلة المجلد كما في القسم 2.
- إنشاء `apps/api` و`apps/mobile` و`packages/contracts` و`infra`.
- ضبط مسارات الـ CI.
- إعداد Codemagic.
- كتابة ADR لكل قرار في القسم 1.

---

## 11. سجل التنفيذ

### S0 (2026-11-11): الأساس

**ما أُنجز:**

- Monorepo مع Git، وقالب Flutter القديم نُقل إلى نسخة احتياطية خارج المستودع.
- `packages/contracts`: مخططا bouquet/box spec، وأمثلة صحيحة وخاطئة، ومتجهات التسعير (10 حالات منها سلة README: 7,266 ل.س / $60.55)، والتطبيع العربي، والهاتف، وhash الـ spec. 8 اختبارات تمر.
- `apps/api`: NestJS 12 مع env (zod) و`Clock` وأخطاء problem+json بالعربية والإنكليزية وPrisma 7 وhealth وhelmet وValidationPipe صارم، وتصدير OpenAPI، وأول migration، وseed. 24 اختبار unit و4 e2e، وlint وtypecheck وbuild كلها تمر.
- `apps/mobile`: Flutter بـ `com.bellebiens.app`، وflavors (dev/stg/prod)، وAndroid 9+ وiOS 15+، وRiverpod 3 وgo_router، وshell بخمسة تبويبات، والثيم من DESIGN.md، وl10n عربي/إنكليزي. 22 اختباراً تمر (RTL، تبديل اللغة، 48dp، 360dp، التباين)، و`app-dev-debug.apk` يُبنى.
- `infra/docker-compose.yml`، وGitHub Actions (api وmobile وcontracts وsecurity)، وDependabot، و`codemagic.yaml`، و11 ADR.

**انحرافات عن الخطة** (مسجّلة في ADR 0002 و0003):

- Vitest وoxlint بدل Jest وESLint (افتراضي NestJS 12).
- Prisma مثبّت على 7.10 لأن `latest` على npm نسخة RC.
- صيغة مُنشئات Dart 3.13 (`const new(...)`).

**لم يُنجز بعد:**

- تشغيل Docker محلياً، لأن Docker Desktop كان متوقفاً. لهذا لم تُطبَّق الـ migration على قاعدة حقيقية بعد.
- أول بناء iOS على Codemagic، ويحتاج حساب Apple Developer وربط المستودع.
- رفع المستودع إلى GitHub.
- الخطوط المضمّنة، وأيقونات SVG، وFirebase، كلها مخططة لـ S1/S7.

### S1 (2026-11-11): تسجيل الدخول ونظام التصميم

**الباك إند:**

- وحدة الحسابات: الدخول برمز الهاتف (4 أرقام، 5 دقائق، 5 محاولات، حدود الإرسال)، والبريد وكلمة المرور (Argon2id) مع استعادتها بالبريد، وGoogle خلف واجهة.
- JWT مع refresh tokens تتبدّل عند كل استخدام وتكشف إعادة الاستخدام.
- حراس عامّة: حد المعدل، ونسخة التطبيق (426)، والهوية، والأدوار.
- سجل تدقيق لا يُعدَّل بفضل triggers في القاعدة، و`/v1/app/config` و`/v1/me` والأجهزة.
- 114 اختباراً (unit وe2e على قاعدة حقيقية)، والتغطية 91.9%.

**الموبايل:**

- نظام التصميم: الخطوط المضمّنة، و56 أيقونة من الشاشات، والمكوّنات (الأزرار، الحقول، الخيارات، التبديل، العدّاد، حقل OTP، البطاقات، الإشعارات، الشارات، الشريط العلوي، شريط الخطوات، كبسولة السلة).
- الشاشات 01 إلى 05، وإكمال الملف، وتبويب الحساب (أساسي).
- عميل API مولّد من العقد، وطبقة شبكة تجدّد التوكن مرة واحدة، وتخزين آمن للجلسة، وحفظ اللغة.
- 72 اختباراً (منها goldens بالاتجاهين)، وتغطية كود التطبيق نحو 85%.
- اختبار كامل على محاكي Android مقابل الـ API الحقيقي ينجح.

**أخطاء اكتُشفت وأُصلحت أثناء الاختبار على الجهاز:**

- عرض الأرقام داخل النص العربي ("963+"، "9639XXXXXXXX+"): صار يُعزل بعلامات LRI/PDI.
- حقل الهاتف: الرقم صار على جهة القراءة، ورمز الدولة منفصل بخط.

**ملاحظات:**

- استبدلنا MinIO بـ SeaweedFS لأن صوره لم تعد منشورة.
- Postgres المحلي على المنفذ 5433 لأن PostgreSQL مثبّت على الجهاز ويستخدم 5432.
- أُزيلت `@nestjs/mau` لأنها كانت تجلب ثغرات معروفة.
- رُفع `compileSdk` إلى 37 من أجل permission_handler.

**مؤجّل:**

- المفضلة والإعدادات الكاملة (S7)، وبطاقة المنتج (S2).
- أيقونة التطبيق وشاشة البداية بالعلامة التجارية (S8).
- تفعيل Google فعلياً، ويحتاج client ids.

### S2 (2026-11-11): الكتالوج

**الباك إند:**

- نماذج: التصنيفات، والمناسبات، والمنتجات مع صورها ومجموعات خياراتها، وعناصر المصمّم، وورد اليوم، وحركات المخزون، والمفضلة، والصفحات، وبيانات تواصل الفرع.
- بيانات تجريبية (`prisma/seed-data/catalog.ts`) بأسماء الشاشات وأسعارها، ومنها 6 سيقان جيبسوفيلا لمعيار FR-DSG-03. التطبيق والاختبارات يستخدمان البيانات نفسها.
- للزبون: `home` و`categories` و`catalog/filters` و`products` (فلاتر وترتيب وصفحات) و`products/:slug` و`search` و`daily-flowers` و`occasions` و`branch` و`pages/:slug` و`me/favorites`.
- البحث العربي يطابق `vectors/arabic-normalize.json`، ويعيد عدد النتائج لكل تصنيف (تبويبات الشاشة 08).
- ورد اليوم ينتهي منتصف الليل بتوقيت دمشق دون أي مهمة خلفية، لأن كل سجل مربوط بتاريخه (FR-DLY-05).
- لفريق المحل: إضافة المنتجات وتعديلها (السعر المعروض ونص البحث يُحسبان تلقائياً)، وقائمة اليوم وسيقانها، وتعديل المخزون بشكل ذري مع السبب (FR-INV-05)، وعناصر المصمّم، ورفع الصور مع إعادة ترميزها (NFR-SEC-08). كل تعديل يُسجَّل في سجل التدقيق.
- 193 اختباراً، والتغطية 92%. منها اختبار طلبين متزامنين على آخر القطع: ينجح أحدهما فقط.

**الموبايل:**

- الشاشات 06 و07 و08 و09 و10 و11 و12 و14 و32 و34، وصفحات السياسات. خيارات الكيك الكاملة (13) تبقى لـ S4.
- النصوص تصل باللغتين، فتبديل اللغة فوري. الأسعار بالليرة أو بالدولار حسب اختيار الزبون، والتحويل بأعداد صحيحة ونفس تقريب الخادم.
- التصفح بلا اتصال: آخر رد محفوظ على الجهاز مع شريط "غير متصل"، والبحث بلا اتصال في المنتجات المحفوظة (ADR 0013).
- 138 اختباراً، وتغطية كود التطبيق 88%. منها اختبار يفتح كل شاشات الكتالوج بعرض 360 بالعربية والإنكليزية وبحجم خط عادي ومضاعف، ويفشل عند أي overflow.
- الاختبارات تستخدم ردوداً مسجّلة من الـ API الحقيقي (`test/fixtures/catalog`)، فتمر عبر العميل المولّد نفسه.

**أخطاء اكتُشفت وأُصلحت:**

- مفتاح العملة وشريط زر الإضافة كانا يسببان خطأ layout يُفرغ الشاشة على الجهاز. اختبار العرض 360 صار يكشف هذا النوع.
- الشارات الطويلة وبطاقات الرئيسية كانت تتجاوز حدودها عند تكبير الخط.
- إعادة المحاولة التلقائية في Riverpod 3 كانت تكرر طلب 404. صارت تعيد المحاولة عند انقطاع الشبكة فقط.
- أسهم "التالي" كانت تشير لليمين في العربية.

**قرارات صغيرة:**

- كلمة "من" قبل السعر تظهر فقط حين يكون الحجم الافتراضي هو الأرخص (الكيك)، لا لإضافات مثل حليب الشوفان.
- صفّ المناسبات في الرئيسية غير موجود في التصميم، لكنه الطريق الوحيد الآن إلى الشاشة 11.

**مؤجّل:**

- "أضف إلى السلة" تعرض رسالة إلى أن تصل السلة (S4). "خصّصها" تفتح تبويب المصمّم (S3).
- صور المنتجات (R-02). رقم هاتف المحل وواتساب يحتاجان قيمة من المحل.
- drift للكاش مع السلة (S3/S4).

### S3 (2026-11-12): مصمّم الباقات

**العقود:**

- مواقع طبقات المعاينة لكل حجم: `layouts/bouquet-slots.v1.json`.
- متجهات التوزيع: `vectors/layout.json`، 5 حالات منها 100 ساق في الحجم الفخم.
- مرجع للخوارزمية بأعداد صحيحة فقط (ADR 0014).

**الباك إند:**

- أعيدت تسمية عناصر المصمّم إلى snake_case كما يطلب مخطط الـ spec.
- أُضيف نوع للورد المساعد (الجيبسوفيلا)، وأحجام بحدود سيقان يضبطها المحل: 8–14 و15–30 و31–50 و51–100.
- `GET /v1/designer/catalog` يعيد العناصر مع مخزون اليوم، والمواقع.
- `POST /v1/designer/quote`:
  - فحص المخطط (Ajv)، وفحص مكان كل عنصر.
  - تسعير من القاعدة بخط التسعير المشترك.
  - مشاكل المخزون والحجم تعود مع بدائل، ومعها hash الـ spec.
- رفع صورة المعاينة، وتعديل حدود الأحجام من الإدارة (مع سجل التدقيق).
- صفحة المنتج تعيد الـ spec الخاص بـ «خصّصها».
- 249 اختباراً. منها معيار FR-DSG-03: بقي 6 من الجيبسوفيلا وطُلب 8، فيقول الخادم 6 ويقترح بدائل.
- كل المتجهات المشتركة تمر في TypeScript: التسعير والـ hash والتوزيع.

**الموبايل:**

- الشاشات 15 إلى 18 والشاشة 37:
  - معاينة حية تُرسم من التوزيع المشترك، وسعر فوري ثم سعر الخادم.
  - العدّاد يقف عند المتوفر، ولا ينتقل التصميم للخطوة التالية قبل أن يطابق عدد السيقان الحجم.
  - تراجع وإعادة حتى 50 خطوة، والمسودة محفوظة على الجهاز.
  - رسالة البطاقة تُعدّ بالأحرف.
  - «أرسل للمحل» يرسل الصورة والملخص عبر واتساب.
  - «خصّصها» من صفحة الباقة، و«صمّم باقة» من صفحة المناسبة.
- المتجهات نفسها تمر في Dart: التسعير العشرة، والـ hash، والتوزيع. توزيع 100 ساق يستغرق أقل من 1ms (NFR-PERF-03).
- 188 اختباراً:
  - golden لرسم ثلاث باقات.
  - فحص كل خطوات المصمّم بعرض 360 باللغتين وبحجم خط مضاعف.
- جُرّب على المحاكي مقابل الـ API: الخطوات والمعاينة وسعر الخادم.

**ما وجدناه وأصلحناه:**

- مؤقّت طلب السعر كان يبقى بعد تغيير التصميم، فصار يُلغى.
- مربع «بدون بطاقة» وصف السعر في المعاينة كانا يتجاوزان العرض.
- «أرسل للمحل» كان يقرأ رقم الفرع قبل تحميله.
- المحاكي امتلأت ذاكرته (2GB) فتوقف العرض. أعيد تشغيله بـ 3GB.

**قرار يحتاج تأكيداً من المحل:** السعر في خطوة الورد يشمل التغليف والشريط الافتراضيين (1,656 بدل 1,560 في الشاشة)، لأن كل باقة تُغلَّف.

**مؤجّل:**

- السلة (S4)، و«احفظ في تصاميمي» في الحساب (S7).
- قواعد الدمج بين الورود.
- صور مقصوصة حقيقية للورد (R-02)، و3D والمعاينة الواقعية (R3).

### S4 (2026-11-12): السلة

**الباك إند:**

- `POST /v1/cart/quote` يسعّر المنتجات والباقات المصمّمة والصناديق من قاعدة البيانات.
  - يرجع المجموع بالليرة والدولار، ويطبّق الكوبون قبل التوصيل، وتقريب المحل.
  - يحسب أقرب موعد من أطول مدة تجهيز، ويقترح منتجات «قد يعجبك أيضاً».
  - مشاكل كل سطر تظهر على السطر نفسه.
- سلة الحساب: `GET` و`PUT /v1/me/cart` (FR-CRT-03).
- كوبونات بنسبة أو بمبلغ ثابت:
  - حد أدنى للطلب، وتواريخ، وحد للاستخدام.
  - المحاولات الخاطئة محدودة بعشر في الساعة لكل عنوان.
  - إدارتها مسجّلة في سجل التدقيق.
- صناديق الورد والحلويات بأنواعها وأركانها وسعة كل ركن، وحلويات بالقطعة (FR-BOX-01..04).
- الكيك:
  - ثلاثة أحجام ونكهات وإضافات.
  - رسالة على الكيك حتى 40 حرفاً مع اقتراحات.
  - رفع صورة مرجعية (FR-CKE-03/04).
- `TRUST_PROXY` حتى ترى حدود المعدّل عنوان الزبون خلف البروكسي.
- **معيار الخروج يمر:** سلة README تساوي 7,116 ل.س و$59.30 قبل التوصيل، وتصبح 7,266 / $60.55 حين تضاف رسوم المنطقة في S5. خط التسعير يمر بالحالتين في المتجهات.
- 271 اختباراً، والتغطية 93%.

**الموبايل:**

- الشاشات 13 و19 و20 و35:
  - سلة محفوظة على الهاتف، وتتزامن مع الحساب وتُدمج عند تسجيل الدخول.
  - كوبون، وملاحظة أقرب موعد، ومشاكل الأسطر، و«تعديل التصميم» يعيد الباقة إلى سطرها.
  - كبسولة السلة فوق التبويبات، وزر السلة في الرأس.
  - «أضف إلى السلة» من صفحة المنتج والمصمّم والصندوق. صورة المعاينة تُرفع في الخلفية.
- 208 اختبارات، وتغطية كود التطبيق 90%. اختبار العرض 360 يشمل السلة والصندوق.
- جُرّب على المحاكي، وأصلحنا عرض المبالغ داخل الجمل العربية (ADR 0015).

**ما وجدناه وأصلحناه:**

- نوع الخطأ الاختياري (nullable enum) داخل كائن اختياري كان يولّد في Dart حقلاً غير قابل لـ null. صار الحقل اختيارياً في الـ API بدل null.
- سعر «من» للصندوق كان يحسب الجيبسوفيلا كأرخص وردة، فصار يحسب الورد الأساسي فقط.
- حدود المعدّل كانت تعتبر كل الطلبات من 127.0.0.1، فأضفنا `TRUST_PROXY`.

**مؤجّل إلى S5:**

- رسوم المنطقة.
- الحجز الذري للمخزون على مستوى الطلب كله.
- عدّ استخدام الكوبون، و«متابعة للتوصيل».
