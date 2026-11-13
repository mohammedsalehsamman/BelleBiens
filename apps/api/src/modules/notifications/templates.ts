// FR-NTF-01..05: what the customer and the shop are told, in both languages.
// Editing these from the dashboard is FR-NTF-06 (Could, R3); until then they
// live here, next to their tests.

export type Language = 'ar' | 'en';

export type TemplateKey =
  | 'order.placed'
  | 'order.placed.shamcash'
  | 'order.confirmed'
  | 'order.ready.pickup'
  | 'order.out'
  | 'order.delivered'
  | 'order.cancelled'
  | 'payment.rejected'
  | 'shop.new_order'
  | 'occasion.reminder';

/** Values a template may use; each is already formatted for the language. */
export interface TemplateVars {
  number?: string;
  when?: string;
  total?: string;
  due?: string;
  person?: string;
  occasion?: string;
  days?: number;
  fulfillment?: string;
}

interface Rendered {
  title: string;
  body: string;
}

type Template = (v: TemplateVars) => Rendered;

const TEMPLATES: Record<TemplateKey, Record<Language, Template>> = {
  'order.placed': {
    ar: (v) => ({
      title: 'استلمنا طلبك',
      body: `استلمنا طلبك ${v.number} من Belle Biens. الموعد: ${v.when}. الإجمالي: ${v.total}. يتصل بك المحل لتأكيده.`,
    }),
    en: (v) => ({
      title: 'We have your order',
      body: `Belle Biens received your order ${v.number}. Time: ${v.when}. Total: ${v.total}. The shop will call you to confirm it.`,
    }),
  },
  'order.placed.shamcash': {
    ar: (v) => ({
      title: 'أكمل الدفع بشام كاش',
      body: `استلمنا طلبك ${v.number} بقيمة ${v.total}. أكمل الدفع بشام كاش قبل ${v.due} وأرسل الإيصال من التطبيق، وإلا يُلغى الطلب.`,
    }),
    en: (v) => ({
      title: 'Finish paying with Sham Cash',
      body: `We received your order ${v.number} for ${v.total}. Pay with Sham Cash before ${v.due} and send the receipt in the app, or the order is cancelled.`,
    }),
  },
  'order.confirmed': {
    ar: (v) => ({
      title: 'أكّد المحل طلبك',
      body: `أكّد المحل طلبك ${v.number}، وسيجهّزه للموعد: ${v.when}.`,
    }),
    en: (v) => ({
      title: 'Your order is confirmed',
      body: `The shop confirmed your order ${v.number} and will have it ready for ${v.when}.`,
    }),
  },
  'order.ready.pickup': {
    ar: (v) => ({
      title: 'طلبك جاهز',
      body: `طلبك ${v.number} جاهز للاستلام من الفرع.`,
    }),
    en: (v) => ({
      title: 'Your order is ready',
      body: `Your order ${v.number} is ready to pick up at the branch.`,
    }),
  },
  'order.out': {
    ar: (v) => ({
      title: 'طلبك في الطريق',
      body: `خرج طلبك ${v.number} للتوصيل.`,
    }),
    en: (v) => ({
      title: 'Your order is on the way',
      body: `Your order ${v.number} is out for delivery.`,
    }),
  },
  'order.delivered': {
    ar: (v) => ({
      title: 'تم التسليم',
      body: `تم تسليم طلبك ${v.number}. شكراً لاختيارك Belle Biens.`,
    }),
    en: (v) => ({
      title: 'Delivered',
      body: `Your order ${v.number} was handed over. Thank you for choosing Belle Biens.`,
    }),
  },
  'order.cancelled': {
    ar: (v) => ({
      title: 'أُلغي الطلب',
      body: `أُلغي طلبك ${v.number}. للاستفسار راسل المحل على واتساب.`,
    }),
    en: (v) => ({
      title: 'Order cancelled',
      body: `Your order ${v.number} was cancelled. Message the shop on WhatsApp with any question.`,
    }),
  },
  'payment.rejected': {
    ar: (v) => ({
      title: 'لم نتمكن من تأكيد الدفعة',
      body: `لم يتمكن المحل من مطابقة دفعة طلبك ${v.number}. افتح الطلب في التطبيق لإعادة إرسال الإيصال أو الدفع عند الاستلام.`,
    }),
    en: (v) => ({
      title: 'We could not confirm the payment',
      body: `The shop could not match the payment for order ${v.number}. Open the order in the app to send the receipt again or pay on delivery.`,
    }),
  },
  'shop.new_order': {
    ar: (v) => ({
      title: 'طلب جديد',
      body: `طلب جديد ${v.number} · ${v.fulfillment} · ${v.when} · ${v.total}`,
    }),
    en: (v) => ({
      title: 'New order',
      body: `New order ${v.number} · ${v.fulfillment} · ${v.when} · ${v.total}`,
    }),
  },
  'occasion.reminder': {
    ar: (v) => ({
      title: `${v.occasion} ${v.person}`,
      body:
        v.days === 0
          ? `اليوم ${v.occasion} ${v.person}. ما زال بإمكانك طلب باقة.`
          : `${arabicDaysAhead(v.days ?? 0)}: ${v.occasion} ${v.person}. صمّم باقة الآن.`,
    }),
    en: (v) => ({
      title: `${v.person}'s ${v.occasion}`,
      body:
        v.days === 0
          ? `Today is ${v.person}'s ${v.occasion}. There is still time to order flowers.`
          : `In ${v.days} day${v.days === 1 ? '' : 's'}: ${v.person}'s ${v.occasion}. Design a bouquet now.`,
    }),
  },
};

/** "غداً", "بعد يومين", "بعد 3 أيام", "بعد 11 يوماً". */
export function arabicDaysAhead(days: number): string {
  if (days === 1) return 'غداً';
  if (days === 2) return 'بعد يومين';
  if (days <= 10) return `بعد ${days} أيام`;
  return `بعد ${days} يوماً`;
}

export function render(
  key: TemplateKey,
  language: Language,
  vars: TemplateVars,
): Rendered {
  return TEMPLATES[key][language](vars);
}

/** Which order status tells the customer something (FR-NTF-02). */
export function templateForStatus(
  status: string,
  fulfillment: 'DELIVERY' | 'PICKUP',
): TemplateKey | null {
  switch (status) {
    case 'CONFIRMED':
      return 'order.confirmed';
    case 'READY':
      return fulfillment === 'PICKUP' ? 'order.ready.pickup' : null;
    case 'OUT_FOR_DELIVERY':
      return 'order.out';
    case 'DELIVERED':
    case 'PICKED_UP':
      return 'order.delivered';
    case 'CANCELLED':
      return 'order.cancelled';
    default:
      return null;
  }
}

/** FR-NTF-05: order messages always go; the rest honour the opt-outs. */
export function isOrderMessage(key: TemplateKey): boolean {
  return key !== 'occasion.reminder';
}
