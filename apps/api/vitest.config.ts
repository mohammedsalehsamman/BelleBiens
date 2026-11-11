import { defineConfig } from 'vitest/config';

export default defineConfig({
  // Resolves the path aliases declared in tsconfig.json, including the ones
  // added by `nest g library`. Requires Vite 8, which ships this option.
  resolve: { tsconfigPaths: true },
  test: {
    globals: true,
    root: './',
    include: ['src/**/*.spec.ts'],
    env: { NODE_ENV: 'test', LOG_LEVEL: 'silent' },
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
      // Plan 5.1 / NFR-MNT-01: 70% overall. Pricing, stock and delivery get their own
      // 90% thresholds when those modules land (S3 to S5).
      thresholds: { lines: 70, branches: 70, functions: 70, statements: 70 },
    },
  },
});
