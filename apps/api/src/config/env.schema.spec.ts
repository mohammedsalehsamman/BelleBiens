import { validateEnv } from './env.schema.js';

describe('validateEnv', () => {
  const minimal = {
    DATABASE_URL: 'postgresql://belle:belle@localhost:5432/belle',
  };

  it('applies defaults', () => {
    expect(validateEnv(minimal)).toEqual({
      NODE_ENV: 'development',
      PORT: 3000,
      DATABASE_URL: minimal.DATABASE_URL,
      REDIS_URL: 'redis://localhost:6379',
      APP_MIN_SUPPORTED_VERSION: '1.0.0',
      LOG_LEVEL: 'info',
    });
  });

  it('coerces PORT from a string', () => {
    expect(validateEnv({ ...minimal, PORT: '8080' }).PORT).toBe(8080);
  });

  it('fails fast without a database URL', () => {
    expect(() => validateEnv({})).toThrow(/DATABASE_URL/);
  });

  it('rejects a non-postgres database URL', () => {
    expect(() => validateEnv({ DATABASE_URL: 'mysql://x' })).toThrow(
      /postgres/,
    );
  });

  it('rejects a malformed minimum app version', () => {
    expect(() =>
      validateEnv({ ...minimal, APP_MIN_SUPPORTED_VERSION: 'v1' }),
    ).toThrow(/APP_MIN_SUPPORTED_VERSION/);
  });
});
