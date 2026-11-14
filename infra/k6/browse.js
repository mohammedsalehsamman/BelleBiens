// NFR-PERF-06: 100 customers at once, p95 under 500 ms. See README.md.
// STRESS=1 drops the time between screens to find one process's limit.
import { browse, think } from './common.js';

export const options = {
  scenarios: {
    customers: {
      executor: 'ramping-vus',
      stages: [
        { duration: '30s', target: 100 },
        { duration: '2m', target: 100 },
        { duration: '15s', target: 0 },
      ],
    },
  },
  thresholds: {
    http_req_duration: ['p(95)<500'],
    // One line per endpoint in the summary, to see which one is slow.
    ...Object.fromEntries(
      [
        '/app/config',
        '/home',
        '/products',
        '/products/:slug',
        '/designer/catalog',
        '/designer/quote',
        '/cart/quote',
      ].map((name) => [`http_req_duration{name:${name}}`, ['p(95)<500']]),
    ),
    http_req_failed: ['rate<0.01'],
    checks: ['rate>0.99'],
  },
};

export default function () {
  browse();
  think();
}
