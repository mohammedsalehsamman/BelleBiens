import { defineConfig } from 'vitest/config';
import { TEST_ENV } from './test/support/test-env.js';

export default defineConfig({
  // Resolves the path aliases declared in tsconfig.json, including the ones
  // added by `nest g library`. Requires Vite 8, which ships this option.
  resolve: { tsconfigPaths: true },
  test: {
    globals: true,
    root: './',
    env: TEST_ENV,
    // `pnpm test:unit` needs nothing running; `pnpm test:e2e` needs Postgres (`pnpm infra:up`).
    projects: [
      {
        extends: true,
        test: { name: 'unit', include: ['src/**/*.spec.ts'] },
      },
      {
        extends: true,
        test: {
          name: 'e2e',
          include: ['test/**/*.e2e-spec.ts'],
          globalSetup: ['test/support/global-setup.ts'],
          // Files share one test database, so they run one after another.
          fileParallelism: false,
          hookTimeout: 60_000,
          testTimeout: 30_000,
        },
      },
    ],
    coverage: {
      provider: 'v8',
      include: ['src/**/*.ts'],
      // Wiring that only does something inside a running app is covered by the e2e tests instead.
      exclude: [
        'src/generated/**',
        'src/main.ts',
        'src/openapi/**',
        'src/bootstrap/**',
        'src/infra/**',
        'src/**/*.module.ts',
      ],
      // Plan 5.1 / NFR-MNT-01: 70% overall, unit and e2e together. Pricing, stock and
      // delivery get their own 90% thresholds when those modules land (S3 to S5).
      thresholds: { lines: 70, branches: 70, functions: 70, statements: 70 },
    },
  },
});
