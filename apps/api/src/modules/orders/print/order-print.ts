// FR-DSG-16 and UC-04 step 3: the florist's recipe (A4) and the order slip
// (80 mm receipt printer), as HTML the dashboard prints. Arabic, right to
// left; every value from the order is escaped.

export interface PrintLine {
  position: number;
  kind: string;
  title: string;
  summary: string;
  qty: number;
  imageUrl: string | null;
  choice: Record<string, unknown>;
}

export interface PrintOrder {
  number: string;
  fulfillment: 'DELIVERY' | 'PICKUP';
  slotDate: string;
  slotStart: string;
  slotEnd: string;
  customerName: string;
  customerPhone: string;
  recipientName: string;
  recipientPhone: string;
  hideSender: boolean;
  callBeforeArrival: boolean;
  address: {
    label: string;
    area: string;
    landmark: string;
    building: string;
    floor: string;
    details: string;
    zoneName: string;
  } | null;
  notes: string;
  paymentMethod: string;
  paymentStatus: string;
  totalMinor: number;
  lines: PrintLine[];
}

/** Arabic names of designer items, by id ("red_rose" -> "جوري أحمر"). */
export type ItemNames = (id: string) => string;

/** Text for the page: strings and numbers as they are, anything else empty. */
function plain(value: unknown): string {
  return typeof value === 'string' ||
    typeof value === 'number' ||
    typeof value === 'boolean'
    ? String(value)
    : '';
}

export function escapeHtml(value: unknown): string {
  return plain(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

const e = escapeHtml;

/** Only http(s) images may become an <img>. */
function image(url: string | null | undefined, alt: string): string {
  if (!url || !/^https?:\/\//.test(url)) return '';
  return `<img src="${e(url)}" alt="${e(alt)}">`;
}

const money = (minor: number) =>
  `${Math.round(minor / 100).toLocaleString('en-US')} ل.س`;

const PAYMENT: Record<string, string> = {
  CASH: 'الدفع عند الاستلام',
  SHAMCASH: 'شام كاش',
  STRIPE: 'بطاقة (Stripe)',
};
const PAYMENT_STATUS: Record<string, string> = {
  PENDING: 'غير مدفوع',
  SUBMITTED: 'بانتظار التحقق',
  PAID: 'مدفوع',
  FAILED: 'لم يُطابق',
  REFUNDED: 'مُسترد',
};

function page(title: string, size: 'A4' | '80mm', body: string): string {
  const width = size === 'A4' ? '' : 'width:72mm;font-size:12px;';
  return `<!doctype html>
<html lang="ar" dir="rtl">
<head>
<meta charset="utf-8">
<title>${e(title)}</title>
<style>
@page { size: ${size === 'A4' ? 'A4' : '80mm auto'}; margin: ${size === 'A4' ? '14mm' : '4mm'}; }
body { font-family: 'IBM Plex Sans Arabic', Tahoma, sans-serif; color: #2C2422; margin: 0; ${width} }
h1 { font-size: ${size === 'A4' ? '22px' : '16px'}; margin: 0 0 4px; }
h2 { font-size: ${size === 'A4' ? '16px' : '13px'}; margin: 14px 0 6px; border-bottom: 1px solid #ccc; }
table { width: 100%; border-collapse: collapse; }
td { padding: 3px 0; vertical-align: top; }
td.n { text-align: left; font-variant-numeric: tabular-nums; white-space: nowrap; }
.muted { color: #605856; }
.card { border: 1px dashed #999; padding: 8px; margin-top: 6px; white-space: pre-wrap; }
img { max-width: ${size === 'A4' ? '60mm' : '0'}; ${size === 'A4' ? '' : 'display:none;'} border-radius: 6px; }
.line { page-break-inside: avoid; margin-bottom: 12px; }
</style>
</head>
<body>
${body}
</body>
</html>`;
}

function when(o: PrintOrder): string {
  return `${e(o.slotDate)} · ${e(o.slotStart)} – ${e(o.slotEnd)}`;
}

function parts(
  rows: { id?: unknown; qty?: unknown }[] | undefined,
  names: ItemNames,
): string {
  return (rows ?? [])
    .map(
      (r) =>
        `<tr><td>${e(names(plain(r.id)))}</td><td class="n">${e(r.qty)}</td></tr>`,
    )
    .join('');
}

/** The florist's sheet: stems per flower, greens, wrap, ribbon, extras, card. */
function recipeLine(line: PrintLine, names: ItemNames): string {
  const choice = line.choice;
  const spec = (choice['spec'] ?? null) as Record<string, unknown> | null;
  const head = `<h2>${e(line.position)}. ${e(line.title)} × ${e(line.qty)}</h2>`;
  if (line.kind === 'design' && spec) {
    const single = (id: unknown) =>
      id ? `<tr><td>${e(names(plain(id)))}</td><td class="n">1</td></tr>` : '';
    const card = spec['cardMessage']
      ? `<div class="card">بطاقة: ${e(spec['cardMessage'])}</div>`
      : '';
    return `<div class="line">${head}
<p class="muted">الحجم: ${e(spec['size'])}</p>
<table>
${parts(spec['flowers'] as { id: unknown; qty: unknown }[], names)}
${parts(spec['greens'] as { id: unknown; qty: unknown }[], names)}
${single(spec['wrap'])}
${single(spec['ribbon'])}
${parts(spec['extras'] as { id: unknown; qty: unknown }[], names)}
</table>
${card}
${image(line.imageUrl ?? (choice['previewUrl'] as string | undefined), 'المعاينة')}
</div>`;
  }
  if (line.kind === 'box' && spec) {
    const compartments = (spec['compartments'] ?? []) as {
      index?: unknown;
      items?: { id: unknown; qty: unknown }[];
    }[];
    return `<div class="line">${head}
${compartments
  .map(
    (c) =>
      `<p class="muted">الركن ${e(c.index)}</p><table>${parts(c.items, names)}</table>`,
  )
  .join('')}
</div>`;
  }
  const product = (choice['product'] ?? {}) as Record<string, unknown>;
  const inscription = product['inscription']
    ? `<div class="card">على الكيك: ${e(product['inscription'])}</div>`
    : '';
  return `<div class="line">${head}
<p>${e(line.summary)}</p>
${inscription}
${image(product['referenceImageUrl'] as string | undefined, 'الصورة المرجعية')}
</div>`;
}

export function recipeHtml(o: PrintOrder, names: ItemNames): string {
  return page(
    `وصفة ${o.number}`,
    'A4',
    `<h1>وصفة الطلب ${e(o.number)}</h1>
<p class="muted">${o.fulfillment === 'DELIVERY' ? 'توصيل' : 'استلام من الفرع'} · ${when(o)}</p>
${o.lines.map((l) => recipeLine(l, names)).join('\n')}
${o.notes ? `<h2>ملاحظات الزبون</h2><p>${e(o.notes)}</p>` : ''}`,
  );
}

export function slipHtml(o: PrintOrder): string {
  const a = o.address;
  const address = a
    ? [
        a.zoneName,
        a.area,
        a.details,
        a.building && `بناء ${a.building}`,
        a.floor && `طابق ${a.floor}`,
        a.landmark && `قرب ${a.landmark}`,
      ]
        .filter(Boolean)
        .map(e)
        .join('، ')
    : 'استلام من الفرع';
  return page(
    `قسيمة ${o.number}`,
    '80mm',
    `<h1>Belle Biens · ${e(o.number)}</h1>
<p>${when(o)}</p>
<h2>المستلم</h2>
<p>${e(o.recipientName)} · <span dir="ltr">${e(o.recipientPhone)}</span></p>
${o.hideSender ? '<p><b>لا تُظهر اسم المرسل</b></p>' : `<p class="muted">من: ${e(o.customerName)} · <span dir="ltr">${e(o.customerPhone)}</span></p>`}
<h2>${o.fulfillment === 'DELIVERY' ? 'العنوان' : 'الاستلام'}</h2>
<p>${address}</p>
${o.callBeforeArrival ? '<p><b>اتصل قبل الوصول</b></p>' : ''}
<h2>المحتويات</h2>
<table>${o.lines.map((l) => `<tr><td>${e(l.title)}</td><td class="n">× ${e(l.qty)}</td></tr>`).join('')}</table>
<h2>الدفع</h2>
<table>
<tr><td>${e(PAYMENT[o.paymentMethod] ?? o.paymentMethod)} · ${e(PAYMENT_STATUS[o.paymentStatus] ?? o.paymentStatus)}</td><td class="n">${e(money(o.totalMinor))}</td></tr>
</table>
${o.notes ? `<h2>ملاحظات</h2><p>${e(o.notes)}</p>` : ''}`,
  );
}
