// Carts and checkout bodies the e2e tests share (README examples, screens 18-25).

/** The README bouquet (screen 18): 2,676 SYP. */
export const README_SPEC = {
  schemaVersion: 1,
  occasion: 'birthday',
  size: 'medium',
  flowers: [
    { id: 'red_rose', qty: 12 },
    { id: 'white_gypsophila', qty: 6 },
  ],
  greens: [{ id: 'eucalyptus', qty: 3 }],
  wrap: 'satin_bordeaux',
  ribbon: 'satin_pink',
  extras: [{ id: 'teddy_bear_small', qty: 1 }],
  cardMessage: 'كل عام وأنتِ أجمل يا لين',
};

export const designLine = {
  id: 'l1',
  kind: 'design',
  qty: 1,
  spec: README_SPEC,
  previewUrl: 'https://media.test/previews/readme.png',
};
export const latteLine = {
  id: 'l2',
  kind: 'product',
  qty: 2,
  product: { slug: 'iced-rose-matcha-latte', options: [] },
};
export const cakeLine = {
  id: 'l3',
  kind: 'product',
  qty: 1,
  product: {
    slug: 'rose-pistachio-cake',
    options: [
      { group: 'size', option: '22cm' },
      { group: 'extras', option: 'birthday-candle' },
    ],
    inscription: 'كل عام وأنت بخير',
  },
};

/** Screen 20: 2,676 + 2 x 540 + 3,360 = 7,116 SYP; 7,266 with Abu Rummaneh. */
export const README_CART = [designLine, latteLine, cakeLine];

/** A pin in Abu Rummaneh, by the branch. */
export const ABU_RUMMANEH = { latitude: 33.5155, longitude: 36.284 };
/** South of the city, outside every zone. */
export const OUTSIDE = { latitude: 33.42, longitude: 36.2 };

/** Screen 21 as the README fills it: delivery tomorrow 16:00 to Lin, sender hidden. */
export function checkout(overrides: Record<string, unknown> = {}) {
  return {
    lines: README_CART,
    fulfillment: 'DELIVERY',
    customer: { name: 'سارة', phone: '0944123456' },
    recipient: { name: 'لين', phone: '0933765432' },
    hideSender: true,
    address: {
      ...ABU_RUMMANEH,
      label: 'البيت',
      area: 'أبو رمانة',
      landmark: 'قرب حديقة الجاحظ',
      building: '12',
      floor: '3',
    },
    slot: { date: '2026-11-12', start: '16:00' },
    callBeforeArrival: true,
    notes: 'الرجاء الاتصال قبل الوصول',
    paymentMethod: 'CASH',
    ...overrides,
  };
}
