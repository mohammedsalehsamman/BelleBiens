import { ABU_RUMMANEH, OUTSIDE } from './support/carts.js';
import { createTestApp, TEST_NOW, type TestApp } from './support/test-app.js';

describe('Delivery (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
  });
  beforeEach(async () => {
    await t.reset();
    await t.seedCatalog();
  });
  afterEach(() => {
    t.clock.set(TEST_NOW);
  });
  afterAll(async () => {
    await t.close();
  });

  const auth = (token: string) => ({ Authorization: `Bearer ${token}` });

  describe('zones (FR-DLV-01/02)', () => {
    it('a pin in Abu Rummaneh: inside, 150 SYP', async () => {
      const res = await t
        .http()
        .post('/v1/delivery/zone-check')
        .send(ABU_RUMMANEH)
        .expect(200);
      expect(res.body).toEqual({
        inZone: true,
        zone: {
          slug: 'abu-rummaneh',
          name: { ar: 'أبو رمانة', en: 'Abu Rummaneh' },
          feeMinor: 15_000,
          eta: { ar: '30 – 45 دقيقة', en: '30–45 minutes' },
        },
      });
    });

    it('a pin outside every zone (screen 36)', async () => {
      const res = await t
        .http()
        .post('/v1/delivery/zone-check')
        .send(OUTSIDE)
        .expect(200);
      expect(res.body).toEqual({ inZone: false });
    });

    it('a switched-off zone no longer counts', async () => {
      await t.prisma.deliveryZone.update({
        where: { slug: 'abu-rummaneh' },
        data: { active: false },
      });
      const res = await t
        .http()
        .post('/v1/delivery/zone-check')
        .send(ABU_RUMMANEH)
        .expect(200);
      expect(res.body.inZone).toBe(false);
      const zones = await t.http().get('/v1/delivery/zones').expect(200);
      expect(zones.body.map((z: { slug: string }) => z.slug)).not.toContain(
        'abu-rummaneh',
      );
      expect(zones.body[0].polygon[0]).toHaveLength(2);
    });

    it('rejects a pin that is not on Earth', async () => {
      await t
        .http()
        .post('/v1/delivery/zone-check')
        .send({ latitude: 120, longitude: 36 })
        .expect(400);
    });
  });

  describe('the calendar (FR-DLV-03/04/05/09)', () => {
    it('a 24 hour cake at 15:00: today is too soon, tomorrow from 16:00, 61 days', async () => {
      const res = await t
        .http()
        .get('/v1/delivery/dates?leadTimeHours=24')
        .expect(200);
      expect(res.body.days).toHaveLength(61);
      expect(res.body.days[0]).toEqual({
        date: '2026-11-11',
        inDays: 0,
        available: false,
        problem: 'TOO_SOON',
      });
      expect(res.body.days[1]).toEqual({
        date: '2026-11-12',
        inDays: 1,
        available: true,
      });
      const slots = await t
        .http()
        .get('/v1/delivery/slots?date=2026-11-12&leadTimeHours=24')
        .expect(200);
      expect(
        slots.body.slots.map((s: { problem?: string }) => s.problem ?? 'OK'),
      ).toEqual(['TOO_SOON', 'TOO_SOON', 'OK', 'OK', 'OK']);
    });

    it('a closed day, set by the shop, has nothing', async () => {
      const owner = await t.signInAs('OWNER');
      await t
        .http()
        .put('/v1/admin/settings/delivery')
        .set(auth(owner.token))
        .send({
          slots: [
            { start: '18:00', end: '20:00', capacity: 2 },
            { start: '12:00', end: '14:00', capacity: 2 },
          ],
          closedDays: ['2026-11-13'],
          windowDays: 30,
          slotHoldMinutes: 10,
        })
        .expect(200);
      const res = await t.http().get('/v1/delivery/dates').expect(200);
      expect(res.body.days).toHaveLength(31);
      expect(res.body.days[2]).toMatchObject({
        available: false,
        problem: 'CLOSED',
      });
      const slots = await t
        .http()
        .get('/v1/delivery/slots?date=2026-11-12')
        .expect(200);
      expect(slots.body.slots.map((s: { start: string }) => s.start)).toEqual([
        '12:00',
        '18:00',
      ]);
      const audit = await t.prisma.auditLog.findFirst({
        where: { action: 'setting.update', actorId: owner.id },
      });
      expect(audit).not.toBeNull();
    });

    it('slot settings are checked', async () => {
      const owner = await t.signInAs('OWNER');
      const res = await t
        .http()
        .put('/v1/admin/settings/delivery')
        .set(auth(owner.token))
        .send({
          slots: [{ start: '14:00', end: '12:00', capacity: 2 }],
          closedDays: [],
          windowDays: 60,
          slotHoldMinutes: 15,
        })
        .expect(400);
      expect(res.body.code).toBe('VALIDATION_FAILED');
      const florist = await t.signInAs('FLORIST');
      await t
        .http()
        .put('/v1/admin/settings/delivery')
        .set(auth(florist.token))
        .send({
          slots: [],
          closedDays: [],
          windowDays: 60,
          slotHoldMinutes: 15,
        })
        .expect(403);
    });
  });

  describe('slot holds (FR-DLV-04)', () => {
    it('the last place is held for 15 minutes, then free again', async () => {
      await t.prisma.setting.create({
        data: {
          key: 'delivery.slots',
          value: [{ start: '20:00', end: '22:00', capacity: 1 }],
        },
      });
      const hold = () =>
        t
          .http()
          .post('/v1/delivery/slot-holds')
          .send({ date: '2026-11-11', start: '20:00' });
      const first = await hold().expect(201);
      expect(first.body.expiresAt).toBe('2026-11-11T12:15:00.000Z');
      expect((await hold().expect(409)).body.code).toBe('SLOT_FULL');
      const slots = await t
        .http()
        .get('/v1/delivery/slots?date=2026-11-11')
        .expect(200);
      expect(slots.body.slots[0]).toMatchObject({
        available: false,
        problem: 'FULL',
      });

      t.clock.advance({ minutes: 16 });
      await hold().expect(201);
    });

    it('a slot that has started cannot be held', async () => {
      const res = await t
        .http()
        .post('/v1/delivery/slot-holds')
        .send({ date: '2026-11-11', start: '12:00' })
        .expect(422);
      expect(res.body).toMatchObject({
        code: 'SLOT_UNAVAILABLE',
        reason: 'TOO_SOON',
      });
    });
  });

  describe('shop mode (FR-ADM-12, screen 39)', () => {
    it('busy needs a time; the app is told the message and the time', async () => {
      const manager = await t.signInAs('MANAGER');
      await t
        .http()
        .put('/v1/admin/settings/shop-mode')
        .set(auth(manager.token))
        .send({ mode: 'busy' })
        .expect(400);
      await t
        .http()
        .put('/v1/admin/settings/shop-mode')
        .set(auth(manager.token))
        .send({
          mode: 'busy',
          acceptsFrom: '20:00',
          message: {
            ar: 'عندنا طلبات كثيرة اليوم',
            en: 'We are very busy today',
          },
        })
        .expect(200);
      const config = await t.http().get('/v1/app/config').expect(200);
      expect(config.body.shop).toMatchObject({
        mode: 'busy',
        acceptsFrom: '20:00',
        message: { ar: 'عندنا طلبات كثيرة اليوم' },
      });
      const today = await t
        .http()
        .get('/v1/delivery/slots?date=2026-11-11')
        .expect(200);
      expect(
        today.body.slots.map((s: { problem?: string }) => s.problem ?? 'OK'),
      ).toEqual(['TOO_SOON', 'TOO_SOON', 'BUSY', 'BUSY', 'OK']);

      await t
        .http()
        .put('/v1/admin/settings/shop-mode')
        .set(auth(manager.token))
        .send({ mode: 'open' })
        .expect(200);
      const open = await t.http().get('/v1/app/config').expect(200);
      expect(open.body.shop).not.toHaveProperty('message');
      expect(open.body.shop).not.toHaveProperty('acceptsFrom');
    });
  });

  describe('zones by the shop (FR-DLV-02)', () => {
    it('an owner adds a zone (audited); a florist cannot', async () => {
      const owner = await t.signInAs('OWNER');
      const zone = {
        slug: 'kafr-souseh',
        nameAr: 'كفرسوسة',
        nameEn: 'Kafr Souseh',
        polygon: [
          [36.27, 33.49],
          [36.29, 33.49],
          [36.29, 33.5],
          [36.27, 33.5],
        ],
        feeMinor: 20_000,
      };
      await t
        .http()
        .put('/v1/admin/delivery/zones/kafr-souseh')
        .set(auth(owner.token))
        .send(zone)
        .expect(200);
      const check = await t
        .http()
        .post('/v1/delivery/zone-check')
        .send({ latitude: 33.495, longitude: 36.28 })
        .expect(200);
      expect(check.body.zone).toMatchObject({
        slug: 'kafr-souseh',
        feeMinor: 20_000,
      });

      await t
        .http()
        .put('/v1/admin/delivery/zones/kafr-souseh')
        .set(auth(owner.token))
        .send({ ...zone, polygon: [[500, 33]] })
        .expect(400);

      const florist = await t.signInAs('FLORIST');
      await t
        .http()
        .put('/v1/admin/delivery/zones/kafr-souseh')
        .set(auth(florist.token))
        .send(zone)
        .expect(403);
      const audit = await t.prisma.auditLog.findFirst({
        where: { action: 'delivery.zone.create', actorId: owner.id },
      });
      expect(audit).not.toBeNull();
    });
  });

  describe('saved addresses (FR-ACC-04)', () => {
    it('add, change, list with the zone, and remove; only my own', async () => {
      const me = await t.signInAs('CUSTOMER');
      const other = await t.signInAs('CUSTOMER');
      const created = await t
        .http()
        .post('/v1/me/addresses')
        .set(auth(me.token))
        .send({ ...ABU_RUMMANEH, label: 'البيت', landmark: 'قرب الحديقة' })
        .expect(201);
      expect(created.body.zone.slug).toBe('abu-rummaneh');

      await t
        .http()
        .put(`/v1/me/addresses/${created.body.id}`)
        .set(auth(me.token))
        .send({ ...OUTSIDE, label: 'المزرعة' })
        .expect(200);
      const list = await t
        .http()
        .get('/v1/me/addresses')
        .set(auth(me.token))
        .expect(200);
      expect(list.body).toHaveLength(1);
      expect(list.body[0]).toMatchObject({ label: 'المزرعة' });
      expect(list.body[0]).not.toHaveProperty('zone');

      await t
        .http()
        .delete(`/v1/me/addresses/${created.body.id}`)
        .set(auth(other.token))
        .expect(404);
      await t
        .http()
        .delete(`/v1/me/addresses/${created.body.id}`)
        .set(auth(me.token))
        .expect(204);
      await t.http().get('/v1/me/addresses').expect(401);
    });
  });
});
