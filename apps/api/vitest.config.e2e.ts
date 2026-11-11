import { defineConfig } from 'vitest/config';

export default defineConfig({
  resolve: { tsconfigPaths: true },
  test: {
    globals: true,
    root: './',
    include: ['**/*.e2e-spec.ts'],
    env: {
      NODE_ENV: 'test',
      LOG_LEVEL: 'silent',
      // e2e tests that need a real database start one with Testcontainers (from S1).
      DATABASE_URL: 'postgresql://test:test@localhost:5432/test',
    },
  },
});
