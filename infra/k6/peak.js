// NFR-PERF-08: the busiest hour, 500 visitors and 50 orders, run ten times
// faster (6 minutes). Orders are real: pickup, cash, one iced latte each, so
// stock and slot capacity do not run out. Use a disposable database.
import { check, sleep } from 'k6';
import { browse, get, post, LATTE_LINE, tomorrow } from './common.js';

const SPEED = Number(__ENV.SPEED || 10);
const MINUTES = 60 / SPEED;

export const options = {
  scenarios: {
    visitors: {
      executor: 'constant-arrival-rate',
      rate: 500,
      timeUnit: `${MINUTES * 60}s`,
      duration: `${MINUTES}m`,
      preAllocatedVUs: 50,
      maxVUs: 200,
      exec: 'visitor',
    },
    orders: {
      executor: 'constant-arrival-rate',
      rate: 50,
      timeUnit: `${MINUTES * 60}s`,
      duration: `${MINUTES}m`,
      preAllocatedVUs: 10,
      maxVUs: 50,
      exec: 'order',
    },
  },
  thresholds: {
    http_req_duration: ['p(95)<500'],
    'http_req_duration{name:/orders}': ['p(95)<1000'],
    http_req_failed: ['rate<0.01'],
    checks: ['rate>0.99'],
  },
};

export function visitor() {
  browse();
  sleep(1);
}

export function order() {
  const date = tomorrow();
  const slots = get(`/delivery/slots?date=${date}&fulfillment=PICKUP`, '/delivery/slots');
  const open = (slots.json('slots') || []).filter((s) => s.available);
  if (!open.length) return;
  const slot = open[__ITER % open.length];
  const res = post(
    '/orders',
    {
      lines: [LATTE_LINE],
      fulfillment: 'PICKUP',
      customer: { name: 'Load test', phone: `09${String(44000000 + ((__VU * 1000 + __ITER) % 9999999)).padStart(8, '0')}` },
      slot: { date, start: slot.start },
      paymentMethod: 'CASH',
    },
    '/orders',
    { 'Idempotency-Key': `k6-${__VU}-${__ITER}-${Date.now()}` },
  );
  check(res, { 'order placed': (r) => r.status === 201 });
}
