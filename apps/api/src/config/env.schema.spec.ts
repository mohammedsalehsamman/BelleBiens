import { validateEnv } from './env.schema.js';

describe('validateEnv', () => {
  const minimal = {
    DATABASE_URL: 'postgresql://belle:belle@localhost:5433/belle',
    JWT_ACCESS_SECRET: 'x'.repeat(32),
  };

  it('applies defaults', () => {
    expect(validateEnv(minimal)).toMatchObject({
      NODE_ENV: 'development',
      PORT: 3000,
      REDIS_URL: 'redis://localhost:6379',
      APP_MIN_SUPPORTED_VERSION: '1.0.0',
      LOG_LEVEL: 'info',
      JWT_ACCESS_TTL_SECONDS: 900,
      REFRESH_TOKEN_TTL_DAYS: 30,
      OTP_LENGTH: 4,
      OTP_TTL_SECONDS: 300,
      OTP_MAX_ATTEMPTS: 5,
      MESSAGING_PROVIDER: 'console',
    });
  });

  it('coerces numbers from strings', () => {
    const env = validateEnv({ ...minimal, PORT: '8080', OTP_LENGTH: '6' });
    expect(env.PORT).toBe(8080);
    expect(env.OTP_LENGTH).toBe(6);
  });

  it('fails fast without a database URL or a JWT secret', () => {
    expect(() =>
      validateEnv({ JWT_ACCESS_SECRET: minimal.JWT_ACCESS_SECRET }),
    ).toThrow(/DATABASE_URL/);
    expect(() => validateEnv({ DATABASE_URL: minimal.DATABASE_URL })).toThrow(
      /JWT_ACCESS_SECRET/,
    );
  });

  it('rejects a short JWT secret', () => {
    expect(() =>
      validateEnv({ ...minimal, JWT_ACCESS_SECRET: 'short' }),
    ).toThrow(/at least 32/);
  });

  it('rejects a non-postgres database URL', () => {
    expect(() =>
      validateEnv({ ...minimal, DATABASE_URL: 'mysql://x' }),
    ).toThrow(/postgres/);
  });

  it('rejects a malformed minimum app version', () => {
    expect(() =>
      validateEnv({ ...minimal, APP_MIN_SUPPORTED_VERSION: 'v1' }),
    ).toThrow(/APP_MIN_SUPPORTED_VERSION/);
  });

  it('allows a fixed OTP code only in development and test, with the right length', () => {
    expect(
      validateEnv({ ...minimal, NODE_ENV: 'test', OTP_FIXED_CODE: '4827' })
        .OTP_FIXED_CODE,
    ).toBe('4827');
    expect(() =>
      validateEnv({ ...minimal, NODE_ENV: 'staging', OTP_FIXED_CODE: '4827' }),
    ).toThrow(/only allowed in development and test/);
    expect(() =>
      validateEnv({ ...minimal, NODE_ENV: 'test', OTP_FIXED_CODE: '482799' }),
    ).toThrow(/OTP_LENGTH digits/);
    expect(() =>
      validateEnv({ ...minimal, NODE_ENV: 'test', OTP_FIXED_CODE: 'abcd' }),
    ).toThrow(/4 to 8 digits/);
  });

  it('refuses to print sign-in codes in production (console messaging provider)', () => {
    expect(() => validateEnv({ ...minimal, NODE_ENV: 'production' })).toThrow(
      /MESSAGING_PROVIDER/,
    );
    expect(
      validateEnv({ ...minimal, NODE_ENV: 'staging' }).MESSAGING_PROVIDER,
    ).toBe('console');
  });
});
