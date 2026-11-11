# ADR 0009: بناء iOS على Codemagic

- **الحالة:** مقبول · 2026-11-11 · S0
- **السياق:** التطوير على Windows ولا يوجد Mac.
- **القرار:** iOS يُبنى ويوقَّع ويُرفع إلى TestFlight على Codemagic. لا flavors لـ iOS حالياً لأن تعديل schemes في Xcode يحتاج Mac: staging والإنتاج يبنيان `com.bellebiens.app` ويختلفان بملف env فقط.
- **لاحقاً:** إضافة schemes لـ iOS (dev/stg) عند توفر Mac أو عبر سكربت على Codemagic.
