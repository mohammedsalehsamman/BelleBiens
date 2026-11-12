import {
  escapeHtml,
  recipeHtml,
  slipHtml,
  type PrintOrder,
} from './order-print.js';

const names = (id: string) =>
  ({
    red_rose: 'جوري أحمر',
    white_gypsophila: 'جيبسوفيلا',
    satin_bordeaux: 'ساتان بوردو',
  })[id] ?? id;

const order: PrintOrder = {
  number: 'BB-1001',
  fulfillment: 'DELIVERY',
  slotDate: '2026-11-12',
  slotStart: '16:00',
  slotEnd: '18:00',
  customerName: 'سارة',
  customerPhone: '+963944123456',
  recipientName: 'لين',
  recipientPhone: '+963933765432',
  hideSender: true,
  callBeforeArrival: true,
  address: {
    label: 'البيت',
    area: 'أبو رمانة',
    landmark: 'حديقة الجاحظ',
    building: '12',
    floor: '3',
    details: '',
    zoneName: 'أبو رمانة',
  },
  notes: '<script>alert(1)</script>',
  paymentMethod: 'CASH',
  paymentStatus: 'PENDING',
  totalMinor: 726_600,
  lines: [
    {
      position: 1,
      kind: 'design',
      title: 'باقتك المصمّمة',
      summary: '',
      qty: 1,
      imageUrl: 'https://media.test/previews/a.png',
      choice: {
        spec: {
          size: 'medium',
          flowers: [
            { id: 'red_rose', qty: 12 },
            { id: 'white_gypsophila', qty: 6 },
          ],
          wrap: 'satin_bordeaux',
          cardMessage: 'كل عام وأنتِ أجمل',
        },
      },
    },
    {
      position: 2,
      kind: 'product',
      title: 'كيكة الورد والفستق',
      summary: 'وسط · 22 سم',
      qty: 1,
      imageUrl: null,
      choice: {
        product: {
          inscription: 'مبروك',
          referenceImageUrl: 'javascript:alert(1)',
        },
      },
    },
  ],
};

describe('order print (FR-DSG-16, UC-04)', () => {
  it('the recipe lists stems by name, the card and the preview', () => {
    const html = recipeHtml(order, names);
    expect(html).toContain('<td>جوري أحمر</td><td class="n">12</td>');
    expect(html).toContain('<td>جيبسوفيلا</td><td class="n">6</td>');
    expect(html).toContain('ساتان بوردو');
    expect(html).toContain('بطاقة: كل عام وأنتِ أجمل');
    expect(html).toContain('على الكيك: مبروك');
    expect(html).toContain('src="https://media.test/previews/a.png"');
    expect(html).toContain('dir="rtl"');
  });

  it('the slip has the recipient, the address, and hides the sender', () => {
    const html = slipHtml(order);
    expect(html).toContain('لين');
    expect(html).toContain('لا تُظهر اسم المرسل');
    expect(html).not.toContain('من: سارة');
    expect(html).toContain('بناء 12');
    expect(html).toContain('اتصل قبل الوصول');
    expect(html).toContain('7,266 ل.س');
  });

  it('escapes what the customer wrote and drops unsafe image links', () => {
    expect(recipeHtml(order, names)).not.toContain('<script>');
    expect(recipeHtml(order, names)).toContain('&lt;script&gt;');
    expect(recipeHtml(order, names)).not.toContain('javascript:');
    expect(escapeHtml(`"'<>&`)).toBe('&quot;&#39;&lt;&gt;&amp;');
  });
});
