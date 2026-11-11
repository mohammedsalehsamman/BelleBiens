/**
 * Environment for every test run. e2e tests use their own database (belle_test),
 * created and migrated by global-setup.ts, so they never touch development data.
 * CI points TEST_DATABASE_URL at its Postgres service.
 */
export const TEST_DATABASE_URL =
  process.env['TEST_DATABASE_URL'] ??
  'postgresql://belle:belle@localhost:5433/belle_test?schema=public';

export const TEST_ENV: Record<string, string> = {
  NODE_ENV: 'test',
  LOG_LEVEL: 'silent',
  DATABASE_URL: TEST_DATABASE_URL,
  JWT_ACCESS_SECRET: 'test-only-secret-test-only-secret-0000',
  // Tests read sent codes and emails from fakes; nothing leaves the machine.
  MAIL_SMTP_URL: 'smtp://127.0.0.1:1',
  // High enough that functional tests never trip it; rate-limit.e2e-spec.ts lowers it.
  AUTH_RATE_LIMIT_PER_MINUTE: '1000',
};
