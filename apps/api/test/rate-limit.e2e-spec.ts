import type { TestApp } from './support/test-app.js';

// Set before the app module is imported: ConfigModule reads the environment at import.
process.env['AUTH_RATE_LIMIT_PER_MINUTE'] = '3';
const { createTestApp } = await import('./support/test-app.js');

describe('Sign-in rate limit per IP (NFR-SEC-03)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
    await t.reset();
  });
  afterAll(async () => {
    await t.close();
  });

  it('allows 3 sign-in calls per minute, then answers 429 RATE_LIMITED', async () => {
    for (let i = 0; i < 3; i++) {
      await t
        .http()
        .post('/v1/auth/login')
        .send({ email: 'a@example.com', password: 'whatever-123' })
        .expect(401);
    }
    const limited = await t
      .http()
      .post('/v1/auth/login')
      .send({ email: 'a@example.com', password: 'whatever-123' })
      .expect(429);
    expect(limited.body.code).toBe('RATE_LIMITED');
  });

  it('does not apply the sign-in limit to other routes', async () => {
    for (let i = 0; i < 5; i++) {
      await t.http().get('/v1/app/config').expect(200);
    }
  });
});
