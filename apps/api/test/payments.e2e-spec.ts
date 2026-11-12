import { randomUUID } from 'node:crypto';
import sharp from 'sharp';
import { PaymentsService } from '../src/modules/orders/payments/payments.service.js';
import {
  OrderEvents,
  type OrderEvent,
} from '../src/modules/orders/order-events.js';
import { checkout, latteLine } from './support/carts.js';
import { createTestApp, TEST_NOW, type TestApp } from './support/test-app.js';

let ipCounter = 0;
const nextIp = () => {
  ipCounter += 1;
  return `10.6.${Math.floor(ipCounter / 250)}.${ipCounter % 250}`;
};

describe('Payments (e2e)', () => {
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

  const place = (body: object, token?: string) => {
    const req = t
      .http()
      .post('/v1/orders')
      .set('Idempotency-Key', randomUUID())
      .set('X-Forwarded-For', nextIp());
    if (token) req.set('Authorization', `Bearer ${token}`);
    return req.send(body);
  };
  const shamcash = () =>
    place(checkout({ paymentMethod: 'SHAMCASH' })).expect(201);
  const post = (path: string, body: object = {}, token?: string) => {
    const req = t.http().post(path).set('X-Forwarded-For', nextIp());
    if (token) req.set('Authorization', `Bearer ${token}`);
    return req.send(body);
  };
  const daily = async (slug: string) =>
    (
      await t.prisma.designerItem.findUniqueOrThrow({
        where: { slug },
        include: { daily: true },
      })
    ).daily[0]?.quantity;

  describe('UC-02: Sham Cash with a receipt (FR-PAY-03)', () => {
    it('placed unpaid with a two-hour deadline, the receipt sent, the shop confirms', async () => {
      const placed = await shamcash();
      expect(placed.body).toMatchObject({
        number: 'BB-1001',
        status: 'NEW',
        paymentMethod: 'SHAMCASH',
        paymentStatus: 'PENDING',
        paymentDueAt: '2026-11-11T14:00:00.000Z',
      });

      // The receipt: a phone photo, re-encoded by the server.
      const photo = await sharp({
        create: { width: 40, height: 60, channels: 3, background: '#ddd' },
      })
        .jpeg()
        .toBuffer();
      const upload = await t
        .http()
        .post('/v1/uploads/receipt')
        .attach('file', photo, 'receipt.jpg')
        .expect(201);
      expect(upload.body.url).toMatch(
        /^https:\/\/media\.test\/receipts\/.+\.webp$/,
      );

      const sent = await post('/v1/orders/BB-1001/payment/proof', {
        phone: '0944123456',
        reference: '784512',
        receiptUrl: upload.body.url,
      }).expect(200);
      expect(sent.body.paymentStatus).toBe('SUBMITTED');
      expect(sent.body).not.toHaveProperty('paymentDueAt');

      const manager = await t.signInAs('MANAGER');
      const confirmed = await post(
        '/v1/admin/orders/BB-1001/payment/confirm',
        {},
        manager.token,
      ).expect(200);
      expect(confirmed.body).toMatchObject({
        status: 'CONFIRMED',
        paymentStatus: 'PAID',
      });
      expect(
        confirmed.body.payments.map((p: { kind: string }) => p.kind),
      ).toEqual(['created', 'submitted', 'confirmed']);
      expect(confirmed.body.payments[1]).toMatchObject({
        method: 'SHAMCASH',
        reference: '784512',
        receiptUrl: upload.body.url,
        amountMinor: 726_600,
        currency: 'SYP',
      });
      const audit = await t.prisma.auditLog.findFirst({
        where: { action: 'order.payment.confirm', actorId: manager.id },
      });
      expect(audit).not.toBeNull();
      expect(t.orders.sent.map((n) => n.status)).toEqual(['NEW', 'CONFIRMED']);
    });

    it('a receipt from somewhere else is not taken; a stranger cannot send one', async () => {
      await shamcash();
      const res = await post('/v1/orders/BB-1001/payment/proof', {
        phone: '0944123456',
        receiptUrl: 'https://evil.example/receipt.png',
      }).expect(400);
      expect(res.body.code).toBe('VALIDATION_FAILED');
      await post('/v1/orders/BB-1001/payment/proof', {
        phone: '0933000000',
        reference: '784512',
      }).expect(404);
    });

    it("rejected with the shop's note (screen 38), then paid on delivery instead", async () => {
      await shamcash();
      await post('/v1/orders/BB-1001/payment/proof', {
        phone: '0944123456',
        reference: '111',
      }).expect(200);
      const manager = await t.signInAs('MANAGER');
      await post(
        '/v1/admin/orders/BB-1001/payment/reject',
        {},
        manager.token,
      ).expect(400);
      await post(
        '/v1/admin/orders/BB-1001/payment/reject',
        { note: 'رقم العملية لا يطابق المبلغ' },
        manager.token,
      ).expect(200);
      const seen = await post('/v1/orders/lookup', {
        number: 'BB-1001',
        phone: '0944123456',
      }).expect(200);
      expect(seen.body).toMatchObject({
        paymentStatus: 'FAILED',
        paymentNote: 'رقم العملية لا يطابق المبلغ',
        paymentDueAt: '2026-11-11T14:00:00.000Z',
      });

      const cash = await post('/v1/orders/BB-1001/payment/cash', {
        phone: '0944123456',
      }).expect(200);
      expect(cash.body).toMatchObject({
        paymentMethod: 'CASH',
        paymentStatus: 'PENDING',
      });
      expect(cash.body).not.toHaveProperty('paymentDueAt');
      expect(cash.body).not.toHaveProperty('paymentNote');
    });

    it('a florist cannot confirm money; cash has nothing to confirm', async () => {
      await shamcash();
      const florist = await t.signInAs('FLORIST');
      await post(
        '/v1/admin/orders/BB-1001/payment/confirm',
        {},
        florist.token,
      ).expect(403);
      await place(
        checkout({
          lines: [latteLine],
          slot: { date: '2026-11-11', start: '20:00' },
        }),
      ).expect(201);
      const owner = await t.signInAs('OWNER');
      const res = await post(
        '/v1/admin/orders/BB-1002/payment/confirm',
        {},
        owner.token,
      ).expect(409);
      expect(res.body.code).toBe('PAYMENT_NOT_EXPECTED');
    });
  });

  describe('unpaid orders expire (FR-PAY-10)', () => {
    it('after two hours unpaid: cancelled, stock back; a receipt waiting is kept', async () => {
      await shamcash(); // BB-1001, never paid
      await place(
        checkout({
          paymentMethod: 'SHAMCASH',
          lines: [latteLine],
          slot: { date: '2026-11-11', start: '20:00' },
        }),
      ).expect(201); // BB-1002, receipt sent
      await post('/v1/orders/BB-1002/payment/proof', {
        phone: '0944123456',
        reference: '555',
      }).expect(200);
      expect(await daily('white_gypsophila')).toBe(0);

      const payments = t.app.get(PaymentsService);
      t.clock.advance({ minutes: 119 });
      expect(await payments.expireUnpaid()).toEqual([]);
      t.clock.advance({ minutes: 2 });
      expect(await payments.expireUnpaid()).toEqual(['BB-1001']);

      const first = await t.prisma.order.findUniqueOrThrow({
        where: { number: 'BB-1001' },
        include: { history: true, payments: true },
      });
      expect(first.status).toBe('CANCELLED');
      expect(first.history.at(-1)).toMatchObject({
        to: 'CANCELLED',
        byUserId: null,
        note: 'not paid in time',
      });
      expect(first.payments.map((p) => p.kind)).toEqual(['created', 'expired']);
      expect(await daily('white_gypsophila')).toBe(6);
      const second = await t.prisma.order.findUniqueOrThrow({
        where: { number: 'BB-1002' },
      });
      expect(second.status).toBe('NEW');

      // A late receipt for the cancelled order is refused.
      const late = await post('/v1/orders/BB-1001/payment/proof', {
        phone: '0944123456',
        reference: '999',
      }).expect(409);
      expect(late.body.code).toBe('PAYMENT_NOT_EXPECTED');
    });

    it('cash orders never expire', async () => {
      await place(checkout()).expect(201);
      t.clock.advance({ hours: 5 });
      expect(await t.app.get(PaymentsService).expireUnpaid()).toEqual([]);
    });
  });

  describe('refunds (FR-PAY-11)', () => {
    it('a paid order cancelled by the shop is refunded with a reason', async () => {
      await shamcash();
      const owner = await t.signInAs('OWNER');
      await post(
        '/v1/admin/orders/BB-1001/payment/confirm',
        {},
        owner.token,
      ).expect(200);
      await t
        .http()
        .patch('/v1/admin/orders/BB-1001/status')
        .set('Authorization', `Bearer ${owner.token}`)
        .send({ to: 'CANCELLED', note: 'نفدت الورود' })
        .expect(200);
      const res = await post(
        '/v1/admin/orders/BB-1001/payment/refund',
        { note: 'أُعيد المبلغ عبر شام كاش' },
        owner.token,
      ).expect(200);
      expect(res.body.paymentStatus).toBe('REFUNDED');
      expect(res.body.payments.at(-1)).toMatchObject({
        kind: 'refunded',
        note: 'أُعيد المبلغ عبر شام كاش',
      });
      await post(
        '/v1/admin/orders/BB-1001/payment/refund',
        { note: 'again' },
        owner.token,
      ).expect(409);
    });
  });

  describe('the shop prints and listens (FR-DSG-16, FR-ORD-08)', () => {
    it('recipe and slip as HTML for staff only', async () => {
      await place(checkout()).expect(201);
      const florist = await t.signInAs('FLORIST');
      const recipe = await t
        .http()
        .get('/v1/admin/orders/BB-1001/recipe')
        .set('Authorization', `Bearer ${florist.token}`)
        .expect(200)
        .expect('Content-Type', /text\/html/);
      expect(recipe.text).toContain('وصفة الطلب BB-1001');
      expect(recipe.text).toContain('<td>جوري أحمر</td><td class="n">12</td>');
      expect(recipe.text).toContain('بطاقة: كل عام وأنتِ أجمل يا لين');
      const slip = await t
        .http()
        .get('/v1/admin/orders/BB-1001/slip')
        .set('Authorization', `Bearer ${florist.token}`)
        .expect(200);
      expect(slip.text).toContain('لا تُظهر اسم المرسل');
      const customer = await t.signInAs('CUSTOMER');
      await t
        .http()
        .get('/v1/admin/orders/BB-1001/recipe')
        .set('Authorization', `Bearer ${customer.token}`)
        .expect(403);
    });

    it('new orders and moves reach the stream; customers cannot open it', async () => {
      const seen: OrderEvent[] = [];
      const sub = t.app.get(OrderEvents).stream.subscribe((e) => seen.push(e));
      await place(checkout()).expect(201);
      const manager = await t.signInAs('MANAGER');
      await t
        .http()
        .patch('/v1/admin/orders/BB-1001/status')
        .set('Authorization', `Bearer ${manager.token}`)
        .send({ to: 'CONFIRMED' })
        .expect(200);
      sub.unsubscribe();
      expect(seen.map((e) => [e.type, e.status])).toEqual([
        ['order.placed', 'NEW'],
        ['order.status', 'CONFIRMED'],
      ]);
      const customer = await t.signInAs('CUSTOMER');
      await t
        .http()
        .get('/v1/admin/orders/stream')
        .set('Authorization', `Bearer ${customer.token}`)
        .expect(403);
      await t.http().get('/v1/admin/orders/stream').expect(401);
    });
  });

  it('the app learns the deadline and the account from its config', async () => {
    await t.prisma.setting.create({
      data: { key: 'payments.shamcashAccount', value: '0991234567' },
    });
    const res = await t.http().get('/v1/app/config').expect(200);
    expect(res.body.payments).toMatchObject({
      shamcash: true,
      shamcashAccount: '0991234567',
      unpaidTimeoutMinutes: 120,
    });
  });

  it('a placed order carries its lines as ordered, for "order again" (FR-ORD-07)', async () => {
    await place(checkout()).expect(201);
    const res = await post('/v1/orders/lookup', {
      number: 'BB-1001',
      phone: '0944123456',
    }).expect(200);
    expect(res.body.lines[1].choice).toMatchObject({
      id: 'l2',
      kind: 'product',
      qty: 2,
      product: { slug: 'iced-rose-matcha-latte' },
    });
  });
});
