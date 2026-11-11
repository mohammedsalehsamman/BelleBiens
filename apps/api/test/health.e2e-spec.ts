import type { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import request from 'supertest';
import type { App } from 'supertest/types.js';
import { AppModule } from '../src/app.module.js';
import { configureApp } from '../src/bootstrap/configure-app.js';
import { Clock, FixedClock } from '../src/common/clock/clock.js';

describe('Health and error shape (e2e)', () => {
  let app: INestApplication<App>;

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({ imports: [AppModule] })
      .overrideProvider(Clock)
      .useValue(new FixedClock('2026-11-11T12:00:00+03:00'))
      .compile();
    app = configureApp(
      moduleRef.createNestApplication(),
    ) as INestApplication<App>;
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  it('GET /v1/health answers without a database', async () => {
    const res = await request(app.getHttpServer())
      .get('/v1/health')
      .expect(200);
    expect(res.body).toEqual({
      status: 'ok',
      time: '2026-11-11T09:00:00.000Z',
    });
  });

  it('unknown routes answer with problem+json in Arabic by default', async () => {
    const res = await request(app.getHttpServer())
      .get('/v1/does-not-exist')
      .expect(404);
    expect(res.headers['content-type']).toContain('application/problem+json');
    expect(res.body).toMatchObject({
      status: 404,
      code: 'NOT_FOUND',
      instance: '/v1/does-not-exist',
    });
    expect(res.body.title).toBe('لم نجد ما تبحث عنه.');
  });

  it('answers in English when asked', async () => {
    const res = await request(app.getHttpServer())
      .get('/v1/does-not-exist')
      .set('Accept-Language', 'en')
      .expect(404);
    expect(res.body.title).toBe('We could not find what you are looking for.');
  });

  it('sets security headers (helmet)', async () => {
    const res = await request(app.getHttpServer()).get('/v1/health');
    expect(res.headers['x-content-type-options']).toBe('nosniff');
  });
});
