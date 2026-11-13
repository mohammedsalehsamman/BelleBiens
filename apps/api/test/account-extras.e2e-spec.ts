import { randomUUID } from 'node:crypto';
import { MeService } from '../src/modules/accounts/me/me.service.js';
import { NotificationsService } from '../src/modules/notifications/notifications.service.js';
import {
  ABU_RUMMANEH,
  checkout,
  latteLine,
  README_SPEC,
} from './support/carts.js';
import { createTestApp, TEST_NOW, type TestApp } from './support/test-app.js';

/** Sorts [channel, recipient] pairs the same way every run. */
const byText = (a: string[], b: string[]) => a.join().localeCompare(b.join());

let ipCounter = 0;
const nextIp = () => {
  ipCounter += 1;
  return `10.7.${Math.floor(ipCounter / 250)}.${ipCounter % 250}`;
};

describe('Account extras, notifications and reports (e2e)', () => {
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
  const place = (body: object, token?: string) => {
    const req = t
      .http()
      .post('/v1/orders')
      .set('Idempotency-Key', randomUUID())
      .set('X-Forwarded-For', nextIp());
    if (token) req.set('Authorization', `Bearer ${token}`);
    return req.send(body);
  };
  const notifications = () => t.app.get(NotificationsService);

  describe('order messages (FR-NTF-01..03, 07)', () => {
    it('placed and confirmed: WhatsApp to the customer, push to their phone, WhatsApp to the shop', async () => {
      await t.prisma.setting.create({
        data: { key: 'shop.whatsapp', value: '+963944000000' },
      });
      const me = await t.signInAs('CUSTOMER', { phone: '+963944123456' });
      await t
        .http()
        .put('/v1/me/devices')
        .set(auth(me.token))
        .send({ platform: 'android', pushToken: 'fcm-token-0123456789' })
        .expect(204);
      await place(checkout(), me.token).expect(201);

      expect(await notifications().dispatchDue()).toEqual({
        sent: 3,
        failed: 0,
      });
      const sent = t.messages.sent;
      expect(sent.map((m) => [m.channel, m.recipient]).sort(byText)).toEqual([
        ['PUSH', 'fcm-token-0123456789'],
        ['WHATSAPP', '+963944000000'],
        ['WHATSAPP', '+963944123456'],
      ]);
      const customer = sent.find((m) => m.recipient === '+963944123456')!;
      expect(customer.body).toBe(
        'استلمنا طلبك BB-1001 من Belle Biens. الموعد: 12 تشرين الثاني 16:00 – 18:00. الإجمالي: 7,266 ل.س. يتصل بك المحل لتأكيده.',
      );
      expect(sent.find((m) => m.channel === 'PUSH')!.data).toEqual({
        route: '/orders/BB-1001',
      });
      expect(sent.find((m) => m.recipient === '+963944000000')!.body).toBe(
        'طلب جديد BB-1001 · توصيل · 12 تشرين الثاني 16:00 – 18:00 · 7,266 ل.س',
      );

      const manager = await t.signInAs('MANAGER');
      await t
        .http()
        .patch('/v1/admin/orders/BB-1001/status')
        .set(auth(manager.token))
        .send({ to: 'CONFIRMED' })
        .expect(200);
      // Preparing is not news for the customer.
      await t
        .http()
        .patch('/v1/admin/orders/BB-1001/status')
        .set(auth(manager.token))
        .send({ to: 'PREPARING' })
        .expect(200);
      t.messages.sent.length = 0;
      await notifications().dispatchDue();
      expect(t.messages.sent.map((m) => [m.channel, m.title])).toEqual(
        expect.arrayContaining([
          ['WHATSAPP', 'أكّد المحل طلبك'],
          ['PUSH', 'أكّد المحل طلبك'],
        ]),
      );
      expect(t.messages.sent).toHaveLength(2);
    });

    it('a guest gets WhatsApp; with WhatsApp turned off a customer gets SMS', async () => {
      await place(checkout()).expect(201);
      const me = await t.signInAs('CUSTOMER', { phone: '+963933765432' });
      await t
        .http()
        .patch('/v1/me')
        .set(auth(me.token))
        .send({ notifyWhatsapp: false })
        .expect(200);
      await place(
        checkout({
          customer: { name: 'لين', phone: '0933765432' },
          lines: [latteLine],
          slot: { date: '2026-11-11', start: '20:00' },
        }),
        me.token,
      ).expect(201);
      await notifications().dispatchDue();
      expect(
        t.messages.sent.map((m) => [m.channel, m.recipient]).sort(byText),
      ).toEqual([
        ['SMS', '+963933765432'],
        ['WHATSAPP', '+963944123456'],
      ]);
    });

    it('a failed send is tried again later, then marked failed with its error', async () => {
      await place(checkout()).expect(201);
      t.messages.failNext = 10;
      await notifications().dispatchDue();
      let row = await t.prisma.notification.findFirstOrThrow();
      expect(row).toMatchObject({ status: 'PENDING', attempts: 1 });
      expect(row.lastError).toContain('provider down');

      // Not due again before its wait.
      await notifications().dispatchDue();
      expect((await t.prisma.notification.findFirstOrThrow()).attempts).toBe(1);

      for (const minutes of [1, 5, 30, 120]) {
        t.clock.advance({ minutes });
        await notifications().dispatchDue();
      }
      row = await t.prisma.notification.findFirstOrThrow();
      expect(row).toMatchObject({ status: 'FAILED', attempts: 5 });

      // A provider that recovers sends the next message at once.
      t.messages.failNext = 0;
      await place(
        checkout({
          lines: [latteLine],
          slot: { date: '2026-11-12', start: '20:00' },
        }),
      ).expect(201);
      await notifications().dispatchDue();
      expect(t.messages.sent).toHaveLength(1);
    });

    it('a rejected receipt tells the customer (screen 38)', async () => {
      await place(checkout({ paymentMethod: 'SHAMCASH' })).expect(201);
      await t
        .http()
        .post('/v1/orders/BB-1001/payment/proof')
        .set('X-Forwarded-For', nextIp())
        .send({ phone: '0944123456', reference: '111' })
        .expect(200);
      const manager = await t.signInAs('MANAGER');
      await t
        .http()
        .post('/v1/admin/orders/BB-1001/payment/reject')
        .set(auth(manager.token))
        .send({ note: 'لا يطابق' })
        .expect(200);
      const templates = (await t.prisma.notification.findMany()).map(
        (n) => n.template,
      );
      expect(templates.sort()).toEqual([
        'order.placed.shamcash',
        'payment.rejected',
      ]);
    });
  });

  describe('occasions (FR-ACC-07, screen 31)', () => {
    it('saved with the days left, reminded once in the window, by push only', async () => {
      const me = await t.signInAs('CUSTOMER');
      await t
        .http()
        .put('/v1/me/devices')
        .set(auth(me.token))
        .send({ platform: 'ios', pushToken: 'apns-token-0123456789' })
        .expect(204);
      const created = await t
        .http()
        .post('/v1/me/occasions')
        .set(auth(me.token))
        .send({ person: 'ماما', type: 'BIRTHDAY', date: '1965-11-20' })
        .expect(201);
      expect(created.body).toMatchObject({
        person: 'ماما',
        remindDaysBefore: 7,
        next: '2026-11-20',
        daysLeft: 9,
      });

      // 9 days left: not yet.
      expect(await notifications().remindOccasions()).toBe(0);
      t.clock.advance({ days: 2 });
      expect(await notifications().remindOccasions()).toBe(1);
      expect(await notifications().remindOccasions()).toBe(0);
      await notifications().dispatchDue();
      expect(t.messages.sent).toEqual([
        expect.objectContaining({
          channel: 'PUSH',
          recipient: 'apns-token-0123456789',
          title: 'عيد ميلاد ماما',
          body: 'بعد 7 أيام: عيد ميلاد ماما. صمّم باقة الآن.',
          data: { route: '/designer' },
        }),
      ]);
    });

    it('turned off in settings: no reminder (FR-NTF-05); only my own occasions', async () => {
      const me = await t.signInAs('CUSTOMER');
      const other = await t.signInAs('CUSTOMER');
      const created = await t
        .http()
        .post('/v1/me/occasions')
        .set(auth(me.token))
        .send({
          person: 'لين',
          type: 'GRADUATION',
          date: '2026-11-12',
          remindDaysBefore: 3,
        })
        .expect(201);
      await t
        .http()
        .patch('/v1/me')
        .set(auth(me.token))
        .send({ notifyOccasions: false })
        .expect(200);
      expect(await notifications().remindOccasions()).toBe(0);
      await t
        .http()
        .delete(`/v1/me/occasions/${created.body.id}`)
        .set(auth(other.token))
        .expect(404);
      await t
        .http()
        .put(`/v1/me/occasions/${created.body.id}`)
        .set(auth(me.token))
        .send({ person: 'لين', type: 'GRADUATION', date: '2026-13-40' })
        .expect(400);
    });
  });

  describe('saved designs (FR-DSG-12, screen 30)', () => {
    it("kept with today's price; a bad spec is refused", async () => {
      const me = await t.signInAs('CUSTOMER');
      await t
        .http()
        .post('/v1/me/designs')
        .set(auth(me.token))
        .send({ name: 'عيد ميلاد لين', spec: README_SPEC })
        .expect(201);
      const list = await t
        .http()
        .get('/v1/me/designs')
        .set(auth(me.token))
        .expect(200);
      expect(list.body).toEqual([
        expect.objectContaining({
          name: 'عيد ميلاد لين',
          stems: 18,
          priceMinor: 267_600,
          available: true,
          wrap: expect.objectContaining({ ar: expect.any(String) }),
        }),
      ]);
      // The gypsophila sold out today: the design shows unavailable.
      await t.prisma.dailyAvailability.updateMany({
        where: { item: { slug: 'white_gypsophila' } },
        data: { quantity: 0 },
      });
      const later = await t
        .http()
        .get('/v1/me/designs')
        .set(auth(me.token))
        .expect(200);
      expect(later.body[0].available).toBe(false);

      const bad = await t
        .http()
        .post('/v1/me/designs')
        .set(auth(me.token))
        .send({ name: 'x', spec: { schemaVersion: 99 } })
        .expect(422);
      expect(bad.body.code).toBe('SPEC_INVALID');
    });
  });

  describe('addresses (FR-ACC-04, screen 29)', () => {
    it('the first is the default; a new default replaces it; deleting it promotes the next', async () => {
      const me = await t.signInAs('CUSTOMER');
      const add = (label: string, more: object = {}) =>
        t
          .http()
          .post('/v1/me/addresses')
          .set(auth(me.token))
          .send({ ...ABU_RUMMANEH, label, ...more })
          .expect(201);
      const home = await add('البيت', { callBeforeArrival: true });
      expect(home.body).toMatchObject({
        isDefault: true,
        callBeforeArrival: true,
      });
      const work = await add('العمل', { isDefault: true });
      const list = await t
        .http()
        .get('/v1/me/addresses')
        .set(auth(me.token))
        .expect(200);
      expect(
        list.body.map((a: { label: string; isDefault: boolean }) => [
          a.label,
          a.isDefault,
        ]),
      ).toEqual([
        ['العمل', true],
        ['البيت', false],
      ]);
      await t
        .http()
        .delete(`/v1/me/addresses/${work.body.id}`)
        .set(auth(me.token))
        .expect(204);
      const after = await t
        .http()
        .get('/v1/me/addresses')
        .set(auth(me.token))
        .expect(200);
      expect(after.body).toEqual([
        expect.objectContaining({ label: 'البيت', isDefault: true }),
      ]);
    });
  });

  describe('guest orders join the account (FR-ACC-09)', () => {
    it('signing in with the code for that phone claims them', async () => {
      await place(checkout()).expect(201);
      await t
        .http()
        .post('/v1/auth/otp/request')
        .send({ phone: '0944123456' })
        .expect(202);
      const code = t.otp.sent.at(-1)!.code;
      const session = await t
        .http()
        .post('/v1/auth/otp/verify')
        .send({ phone: '0944123456', code })
        .expect(200);
      const mine = await t
        .http()
        .get('/v1/me/orders')
        .set(auth(session.body.accessToken))
        .expect(200);
      expect(mine.body.map((o: { number: string }) => o.number)).toEqual([
        'BB-1001',
      ]);
    });
  });

  describe('export and deletion (FR-ACC-08)', () => {
    it('export has my data; deletion signs me out, a sign-in in 30 days keeps the account, after that it is erased', async () => {
      const phone = '+963955111222';
      const me = await t.signInAs('CUSTOMER', { phone, name: 'رنا' });
      await t
        .http()
        .post('/v1/me/occasions')
        .set(auth(me.token))
        .send({ person: 'ماما', type: 'BIRTHDAY', date: '1965-11-20' })
        .expect(201);
      await place(
        checkout({ customer: { name: 'رنا', phone } }),
        me.token,
      ).expect(201);

      const data = await t
        .http()
        .get('/v1/me/export')
        .set(auth(me.token))
        .expect(200)
        .expect('Content-Disposition', /belle-biens-my-data\.json/);
      expect(data.body.profile).toMatchObject({ name: 'رنا', phone });
      expect(data.body.occasions).toHaveLength(1);
      expect(data.body.orders[0].number).toBe('BB-1001');

      await t.http().delete('/v1/me').set(auth(me.token)).expect(204);
      await t.http().get('/v1/me').set(auth(me.token)).expect(401);

      // Changed their mind: signing in again keeps the account.
      await t.http().post('/v1/auth/otp/request').send({ phone }).expect(202);
      const back = await t
        .http()
        .post('/v1/auth/otp/verify')
        .send({ phone, code: t.otp.sent.at(-1)!.code })
        .expect(200);
      await t.http().get('/v1/me').set(auth(back.body.accessToken)).expect(200);

      // Asked again, and the 30 days pass while the order is still open.
      await t
        .http()
        .delete('/v1/me')
        .set(auth(back.body.accessToken))
        .expect(204);
      t.clock.advance({ days: 31 });
      const me2 = t.app.get(MeService);
      expect(await me2.eraseDeleted()).toBe(0);

      const owner = await t.signInAs('OWNER');
      await t
        .http()
        .patch('/v1/admin/orders/BB-1001/status')
        .set(auth(owner.token))
        .send({ to: 'CANCELLED', note: 'test' })
        .expect(200);
      expect(await me2.eraseDeleted()).toBe(1);

      const user = await t.prisma.user.findUniqueOrThrow({
        where: { id: me.id },
      });
      expect(user).toMatchObject({ name: '', phone: null, email: null });
      expect(await t.prisma.occasionReminder.count()).toBe(0);
      const order = await t.prisma.order.findUniqueOrThrow({
        where: { number: 'BB-1001' },
      });
      expect(order).toMatchObject({
        userId: null,
        customerPhone: '',
        recipientName: '',
        totalMinor: 726_600,
      });
    });
  });

  describe('reports and dashboard (FR-RPT-01/03/04, FR-ADM-10)', () => {
    it('sales by day, method and zone; CSV; owners only', async () => {
      await place(checkout({ couponCode: 'WELCOME10' })).expect(201);
      await place(
        checkout({
          lines: [latteLine],
          fulfillment: 'PICKUP',
          address: undefined,
          slot: { date: '2026-11-12', start: '20:00' },
        }),
      ).expect(201);
      const owner = await t.signInAs('OWNER');
      const res = await t
        .http()
        .get('/v1/admin/reports/sales?from=2026-11-01&to=2026-11-30')
        .set(auth(owner.token))
        .expect(200);
      expect(res.body).toMatchObject({
        orders: 2,
        totalMinor: 655_440 + 108_000,
      });
      expect(res.body.periods).toEqual([
        expect.objectContaining({ key: '2026-11-11', orders: 2 }),
      ]);
      expect(res.body.byZone.map((z: { key: string }) => z.key).sort()).toEqual(
        ['abu-rummaneh', 'pickup'],
      );
      expect(res.body.coupons).toEqual([
        expect.objectContaining({ key: 'WELCOME10', discountMinor: 71_160 }),
      ]);
      expect(
        res.body.byCategory.map((c: { key: string }) => c.key).sort(),
      ).toEqual(['cakes', 'coffee', 'designs']);

      const csv = await t
        .http()
        .get('/v1/admin/reports/sales?from=2026-11-01&to=2026-11-30&format=csv')
        .set(auth(owner.token))
        .expect(200)
        .expect('Content-Type', /text\/csv/);
      expect(csv.text).toContain('2026-11-11,2,7634.40,');

      const florist = await t.signInAs('FLORIST');
      await t
        .http()
        .get('/v1/admin/reports/sales?from=2026-11-01&to=2026-11-30')
        .set(auth(florist.token))
        .expect(403);
    });

    it("the dashboard: today's work, revenue and low stock", async () => {
      await place(
        checkout({
          lines: [latteLine],
          slot: { date: '2026-11-11', start: '20:00' },
        }),
      ).expect(201);
      const manager = await t.signInAs('MANAGER');
      const res = await t
        .http()
        .get('/v1/admin/dashboard')
        .set(auth(manager.token))
        .expect(200);
      expect(res.body).toMatchObject({
        date: '2026-11-11',
        ordersToday: 1,
        awaitingConfirmation: 1,
        paymentsToCheck: 0,
        revenueTodayMinor: 123_000,
      });
      // Products with 3 or 4 left in the seed, and gypsophila down to 2.
      const low = res.body.lowStock.map((i: { id: string }) => i.id);
      expect(low).toEqual(expect.arrayContaining(['spring-peony-bouquet']));
      expect(low).not.toContain('white_gypsophila');
      await t.prisma.dailyAvailability.updateMany({
        where: { item: { slug: 'white_gypsophila' } },
        data: { quantity: 2 },
      });
      const again = await t
        .http()
        .get('/v1/admin/dashboard')
        .set(auth(manager.token))
        .expect(200);
      expect(again.body.lowStock).toEqual(
        expect.arrayContaining([
          expect.objectContaining({
            id: 'white_gypsophila',
            left: 2,
            source: 'daily',
          }),
        ]),
      );
    });
  });
});
