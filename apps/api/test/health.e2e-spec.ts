import { createTestApp, type TestApp } from './support/test-app.js';

describe('Platform: health, errors, app config, versions (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
  });
  beforeEach(async () => {
    await t.reset();
  });
  afterAll(async () => {
    await t.close();
  });

  it('GET /v1/health answers with the server time', async () => {
    const res = await t.http().get('/v1/health').expect(200);
    expect(res.body).toEqual({
      status: 'ok',
      time: '2026-11-11T12:00:00.000Z',
    });
  });

  it('GET /v1/health/ready checks the database', async () => {
    const res = await t.http().get('/v1/health/ready').expect(200);
    expect(res.body.details.database.status).toBe('up');
  });

  it('unknown routes answer with problem+json, Arabic by default and English on request', async () => {
    const ar = await t.http().get('/v1/does-not-exist').expect(404);
    expect(ar.headers['content-type']).toContain('application/problem+json');
    expect(ar.body).toMatchObject({
      status: 404,
      code: 'NOT_FOUND',
      instance: '/v1/does-not-exist',
    });
    expect(ar.body.title).toBe('لم نجد ما تبحث عنه.');

    const en = await t
      .http()
      .get('/v1/does-not-exist')
      .set('Accept-Language', 'en')
      .expect(404);
    expect(en.body.title).toBe('We could not find what you are looking for.');
  });

  it('sets security headers (helmet)', async () => {
    const res = await t.http().get('/v1/health');
    expect(res.headers['x-content-type-options']).toBe('nosniff');
  });

  it('GET /v1/app/config is public and reflects the shop settings', async () => {
    await t.prisma.setting.create({
      data: { key: 'shop.mode', value: 'busy' },
    });
    const res = await t.http().get('/v1/app/config').expect(200);
    expect(res.body).toMatchObject({
      minSupportedVersion: '1.0.0',
      shop: {
        mode: 'busy',
        workingHours: { open: '10:00', close: '24:00' },
        timeZone: 'Asia/Damascus',
      },
      currency: { base: 'SYP', usdRate: '120' },
      payments: { cash: true, shamcash: true, stripe: false },
      auth: { otpLength: 4, otpResendSeconds: 60, google: true },
      features: { designer3d: false, aiPreview: false },
    });
  });

  it('old app versions get 426 UPGRADE_REQUIRED; current ones pass (NFR-CMP-01)', async () => {
    const old = await t
      .http()
      .get('/v1/app/config')
      .set('X-App-Version', '0.9.9')
      .expect(426);
    expect(old.body).toMatchObject({
      code: 'UPGRADE_REQUIRED',
      minSupportedVersion: '1.0.0',
    });

    await t
      .http()
      .get('/v1/app/config')
      .set('X-App-Version', '1.0.0+7')
      .expect(200);
    await t.http().get('/v1/health').set('X-App-Version', '0.1.0').expect(200);
  });

  it('protected routes need a token', async () => {
    const res = await t.http().get('/v1/me').expect(401);
    expect(res.body.code).toBe('UNAUTHORIZED');
    const bad = await t
      .http()
      .get('/v1/me')
      .set('Authorization', 'Bearer not-a-jwt')
      .expect(401);
    expect(bad.body.code).toBe('TOKEN_INVALID');
  });
});
