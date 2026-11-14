// Shared by the k6 scripts (plan 5.4). Requests and bodies match the seed
// (apps/api/prisma/seed.ts) and the e2e tests (apps/api/test/support/carts.ts).
import http from 'k6/http';
import { check, sleep } from 'k6';

export const BASE = (__ENV.BASE_URL || 'http://localhost:3000') + '/v1';

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
};

export const LATTE_LINE = {
  id: 'l1',
  kind: 'product',
  qty: 1,
  product: { slug: 'iced-rose-matcha-latte', options: [] },
};

/**
 * Each virtual user looks like its own phone: a private address in
 * X-Forwarded-For (the API must trust the k6 network: TRUST_PROXY), so the
 * per-address limits apply per user as they would in production.
 */
export function headers(extra = {}) {
  const ip = `10.${(__VU >> 8) & 255}.${__VU & 255}.${(__ITER % 250) + 1}`;
  return {
    'Content-Type': 'application/json',
    'Accept-Language': __VU % 4 === 0 ? 'en' : 'ar',
    'X-Forwarded-For': ip,
    ...extra,
  };
}

export function get(path, name) {
  const res = http.get(`${BASE}${path}`, {
    headers: headers(),
    tags: { name: name || path },
  });
  check(res, { [`${name || path} 200`]: (r) => r.status === 200 });
  return res;
}

export function post(path, body, name, extraHeaders = {}) {
  const res = http.post(`${BASE}${path}`, JSON.stringify(body), {
    headers: headers(extraHeaders),
    tags: { name: name || path },
  });
  return res;
}

/**
 * Time on a screen before the next tap: 1 to 3 seconds, as a person would.
 * STRESS=1 fires the screens back to back instead, to find what one API
 * process can take.
 */
export function think() {
  if (__ENV.STRESS !== '1') sleep(1 + Math.random() * 2);
}

/** A customer looking around: home, the shop, a product, the designer. */
export function browse() {
  get('/app/config');
  get('/home');
  think();
  const list = get('/products?sort=popular&page=1&pageSize=20', '/products');
  const items = list.status === 200 ? list.json('items') || [] : [];
  const pick = items.length ? items[__ITER % items.length].slug : 'red-rose-bouquet';
  think();
  get(`/products/${pick}`, '/products/:slug');
  think();
  get('/designer/catalog');
  const quote = post('/designer/quote', { spec: README_SPEC });
  check(quote, { 'designer quote 2xx': (r) => r.status === 200 || r.status === 201 });
  think();
  const cart = post('/cart/quote', { lines: [LATTE_LINE] });
  check(cart, { 'cart quote 2xx': (r) => r.status === 200 || r.status === 201 });
}

/** Tomorrow in Damascus (UTC+3), "YYYY-MM-DD". */
export function tomorrow() {
  const d = new Date(Date.now() + 3 * 3600e3 + 24 * 3600e3);
  return d.toISOString().slice(0, 10);
}
