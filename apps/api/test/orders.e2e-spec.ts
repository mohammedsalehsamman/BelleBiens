import { randomUUID } from 'node:crypto';
import { ABU_RUMMANEH, checkout, latteLine, OUTSIDE } from './support/carts.js';
import { SettingsService as SettingsServiceToken } from '../src/modules/settings/settings.service.js';
import { createTestApp, TEST_NOW, type TestApp } from './support/test-app.js';

const bouquetLine = (qty = 1) => ({
  id: 'b1',
  kind: 'product',
  qty,
  product: { slug: 'red-rose-bouquet', options: [] },
});

let ipCounter = 0;
const nextIp = () => {
  ipCounter += 1;
  return `10.5.${Math.floor(ipCounter / 250)}.${ipCounter % 250}`;
};

describe('Orders (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
  });
  beforeEach(async () => {
    await t.reset();
    await t.seedCatalog();
  });
  afterAll(async () => {
    await t.close();
  });

  const place = (body: object, key: string = randomUUID(), token?: string) => {
    const req = t
      .http()
      .post('/v1/orders')
      .set('Idempotency-Key', key)
      // Each order from its own address, so the per-address limit stays out of the way.
      .set('X-Forwarded-For', nextIp());
    if (token) req.set('Authorization', `Bearer ${token}`);
    return req.send(body);
  };

  const daily = async (slug: string) => {
    const item = await t.prisma.designerItem.findUniqueOrThrow({
      where: { slug },
      include: { daily: true },
    });
    return item.daily[0]?.quantity;
  };
  const stock = async (slug: string) =>
    (await t.prisma.designerItem.findUniqueOrThrow({ where: { slug } }))
      .stockQuantity;

  const setting = (key: string, value: unknown) =>
    t.prisma.setting
      .upsert({
        where: { key },
        update: { value: value as object },
        create: { key, value: value as object },
      })
      .then(() => t.app.get(SettingsServiceToken).invalidate());

  describe('UC-01: the README order, cash on delivery', () => {
    it('7,266 SYP and $60.55, number BB-1001, pending confirmation, stock reserved', async () => {
      const res = await place(checkout()).expect(201);
      expect(res.body).toMatchObject({
        number: 'BB-1001',
        status: 'NEW',
        paymentStatus: 'PENDING',
        paymentMethod: 'CASH',
        fulfillment: 'DELIVERY',
        recipient: { name: 'لين', phone: '+963933765432' },
        hideSender: true,
        slot: { date: '2026-11-12', start: '16:00', end: '18:00' },
        callBeforeArrival: true,
        whatsappConfirm: false,
        notes: 'الرجاء الاتصال قبل الوصول',
        usdRate: '120',
        totalUsdCents: 6055,
        canCancel: true,
        zone: {
          slug: 'abu-rummaneh',
          name: { ar: 'أبو رمانة' },
          feeMinor: 15_000,
        },
        address: { label: 'البيت', landmark: 'قرب حديقة الجاحظ', floor: '3' },
      });
      expect(res.body.syp).toEqual({
        itemsMinor: 711_600,
        assemblyFeeMinor: 0,
        discountMinor: 0,
        deliveryFeeMinor: 15_000,
        roundingAdjustmentMinor: 0,
        totalMinor: 726_600,
      });
      expect(
        res.body.lines.map((l: { totalMinor: number }) => l.totalMinor),
      ).toEqual([267_600, 108_000, 336_000]);
      expect(res.body.lines[0].imageUrl).toBe(
        'https://media.test/previews/readme.png',
      );
      expect(res.body.history).toEqual([
        { status: 'NEW', at: '2026-11-11T12:00:00.000Z' },
      ]);

      // Stems from today's list, counted items by count (FR-INV-02).
      expect(await daily('red_rose')).toBe(108);
      expect(await daily('white_gypsophila')).toBe(0);
      expect(await daily('eucalyptus')).toBe(37);
      expect(await stock('satin_bordeaux')).toBe(49);
      expect(await stock('teddy_bear_small')).toBe(5);
      const movements = await t.prisma.stockMovement.findMany();
      expect(movements.map((m) => m.reason)).toContain('order BB-1001');

      // The spec and the cake choices are kept as ordered (FR-ORD-06).
      const lines = await t.prisma.orderLine.findMany({
        orderBy: { position: 'asc' },
      });
      expect(lines[0]!.choice).toMatchObject({
        spec: {
          flowers: [
            { id: 'red_rose', qty: 12 },
            { id: 'white_gypsophila', qty: 6 },
          ],
        },
      });
      expect(lines[2]!.choice).toMatchObject({
        product: { inscription: 'كل عام وأنت بخير' },
      });

      // The shop is told (UC-01 step 7).
      expect(t.orders.sent).toEqual([
        expect.objectContaining({ number: 'BB-1001', totalMinor: 726_600 }),
      ]);
    });

    it('the next order is BB-1002, and a later rate change leaves both alone (FR-ORD-01, FR-PAY-06)', async () => {
      await place(checkout()).expect(201);
      const second = await place(
        checkout({
          lines: [latteLine],
          slot: { date: '2026-11-11', start: '18:00' },
        }),
      ).expect(201);
      expect(second.body.number).toBe('BB-1002');
      await setting('currency.usdRate', '150');
      const res = await t
        .http()
        .post('/v1/orders/lookup')
        .send({ number: 'bb-1001', phone: '0944 123 456' })
        .expect(200);
      expect(res.body).toMatchObject({ usdRate: '120', totalUsdCents: 6055 });
    });

    it('pickup has no fee and no address', async () => {
      const res = await place(
        checkout({ fulfillment: 'PICKUP', address: undefined }),
      ).expect(201);
      expect(res.body.syp.deliveryFeeMinor).toBe(0);
      expect(res.body.syp.totalMinor).toBe(711_600);
      expect(res.body).not.toHaveProperty('address');
    });
  });

  describe('a retry never orders twice (FR-CRT-10)', () => {
    it('the same key and body gives the same order', async () => {
      const key = randomUUID();
      const first = await place(checkout(), key).expect(201);
      const again = await place(checkout(), key).expect(201);
      expect(again.body.number).toBe(first.body.number);
      expect(await t.prisma.order.count()).toBe(1);
    });

    it('the same key with another order is refused', async () => {
      const key = randomUUID();
      await place(checkout(), key).expect(201);
      const res = await place(checkout({ notes: 'غيّرت رأيي' }), key).expect(
        422,
      );
      expect(res.body.code).toBe('IDEMPOTENCY_KEY_REUSED');
    });

    it('a failed attempt frees the key', async () => {
      const key = randomUUID();
      await place(
        checkout({ address: { ...OUTSIDE, label: 'بعيد' } }),
        key,
      ).expect(422);
      await place(checkout(), key).expect(201);
    });

    it('the key is required', async () => {
      const res = await t
        .http()
        .post('/v1/orders')
        .send(checkout())
        .expect(400);
      expect(res.body.code).toBe('VALIDATION_FAILED');
    });
  });

  describe('what is refused', () => {
    it('outside the zones: OUT_OF_ZONE (FR-DLV-01, screen 36)', async () => {
      const res = await place(
        checkout({ address: { ...OUTSIDE, label: 'بعيد' } }),
      ).expect(422);
      expect(res.body.code).toBe('OUT_OF_ZONE');
      expect(await t.prisma.order.count()).toBe(0);
    });

    it('delivery without an address', async () => {
      const res = await place(checkout({ address: undefined })).expect(400);
      expect(res.body.code).toBe('ADDRESS_REQUIRED');
    });

    it('a slot before the cake is ready: TOO_SOON (FR-DLV-05)', async () => {
      const res = await place(
        checkout({ slot: { date: '2026-11-12', start: '12:00' } }),
      ).expect(422);
      expect(res.body).toMatchObject({
        code: 'SLOT_UNAVAILABLE',
        reason: 'TOO_SOON',
      });
    });

    it('a slot that does not exist', async () => {
      const res = await place(
        checkout({ slot: { date: '2026-11-12', start: '17:00' } }),
      ).expect(422);
      expect(res.body).toMatchObject({
        code: 'SLOT_UNAVAILABLE',
        reason: 'NO_SUCH_SLOT',
      });
    });

    it('a price from the app is rejected (NFR-SEC-06)', async () => {
      const body = checkout({
        lines: [{ ...latteLine, unitPriceMinor: 1 }],
      });
      const res = await place(body).expect(400);
      expect(res.body.code).toBe('VALIDATION_FAILED');
    });

    it('a phone that is not valid (FR-CRT-09)', async () => {
      const res = await place(
        checkout({ recipient: { name: 'لين', phone: '12345' } }),
      ).expect(400);
      expect(res.body).toMatchObject({
        code: 'PHONE_INVALID',
        field: 'recipient.phone',
      });
    });

    it('Stripe is refused even when switched on: no provider until S12', async () => {
      await setting('payments.enabled', {
        cash: true,
        shamcash: true,
        stripe: true,
      });
      const res = await place(checkout({ paymentMethod: 'STRIPE' })).expect(
        422,
      );
      expect(res.body.code).toBe('PAYMENT_METHOD_UNAVAILABLE');
      await setting('payments.enabled', {
        cash: true,
        shamcash: false,
        stripe: false,
      });
      await place(checkout({ paymentMethod: 'SHAMCASH' })).expect(422);
    });

    it('an item that is not available: CART_NOT_ORDERABLE with the line', async () => {
      const peony = {
        id: 'p1',
        kind: 'product',
        qty: 1,
        product: { slug: 'spring-peony-bouquet', options: [] },
      };
      await t.prisma.product.update({
        where: { slug: 'spring-peony-bouquet' },
        data: { stockQuantity: 0 },
      });
      const res = await place(checkout({ lines: [peony] })).expect(409);
      expect(res.body.code).toBe('CART_NOT_ORDERABLE');
      expect(res.body.lines[0].id).toBe('p1');
    });

    it('closed mode takes no orders; busy takes today only from its time (FR-ADM-12)', async () => {
      await setting('shop.mode', 'closed');
      expect((await place(checkout()).expect(503)).body.code).toBe(
        'SHOP_CLOSED',
      );

      await setting('shop.mode', 'busy');
      await setting('shop.busyAcceptsFrom', '20:00');
      const today = (start: string) =>
        checkout({ lines: [latteLine], slot: { date: '2026-11-11', start } });
      const res = await place(today('18:00')).expect(422);
      expect(res.body).toMatchObject({
        code: 'SLOT_UNAVAILABLE',
        reason: 'BUSY',
      });
      await place(today('20:00')).expect(201);
    });
  });

  describe('two customers at once (FR-INV-03, FR-DLV-04)', () => {
    it('the last bouquet goes to one of two orders placed together', async () => {
      await t.prisma.product.update({
        where: { slug: 'red-rose-bouquet' },
        data: { stockQuantity: 1 },
      });
      const body = (start: string) =>
        checkout({
          lines: [bouquetLine()],
          slot: { date: '2026-11-11', start },
        });
      const results = await Promise.all([
        place(body('18:00')),
        place(body('20:00')),
      ]);
      const statuses = results.map((r) => r.status).sort((a, b) => a - b);
      expect(statuses).toEqual([201, 409]);
      const loser = results.find((r) => r.status === 409)!;
      expect(loser.body).toMatchObject({
        code: 'STOCK_INSUFFICIENT',
        itemId: 'red-rose-bouquet',
        available: 0,
      });
      const product = await t.prisma.product.findUniqueOrThrow({
        where: { slug: 'red-rose-bouquet' },
      });
      expect(product.stockQuantity).toBe(0);
      expect(await t.prisma.order.count()).toBe(1);
    });

    it('a full slot is refused; pickup is not counted; a hold keeps the place', async () => {
      await setting('delivery.slots', [
        { start: '18:00', end: '20:00', capacity: 1 },
        { start: '20:00', end: '22:00', capacity: 1 },
      ]);
      const today = (start: string, more: object = {}) =>
        checkout({
          lines: [latteLine],
          slot: { date: '2026-11-11', start },
          ...more,
        });

      await place(today('18:00')).expect(201);
      expect((await place(today('18:00')).expect(409)).body.code).toBe(
        'SLOT_FULL',
      );
      await place(
        today('18:00', { fulfillment: 'PICKUP', address: undefined }),
      ).expect(201);

      const hold = await t
        .http()
        .post('/v1/delivery/slot-holds')
        .send({ date: '2026-11-11', start: '20:00' })
        .expect(201);
      expect((await place(today('20:00')).expect(409)).body.code).toBe(
        'SLOT_FULL',
      );
      await place(today('20:00', { slotHoldId: hold.body.id })).expect(201);
      expect(await t.prisma.slotHold.count()).toBe(0);
    });

    it('two orders for the same last place: one wins', async () => {
      await setting('delivery.slots', [
        { start: '20:00', end: '22:00', capacity: 1 },
      ]);
      const body = checkout({
        lines: [latteLine],
        slot: { date: '2026-11-11', start: '20:00' },
      });
      const results = await Promise.all([place(body), place(body)]);
      expect(results.map((r) => r.status).sort((a, b) => a - b)).toEqual([
        201, 409,
      ]);
    });
  });

  describe('coupons are counted when ordered (FR-CRT-07)', () => {
    it('WELCOME10 takes 10% before delivery, counts, and comes back on cancel', async () => {
      const res = await place(checkout({ couponCode: 'welcome10' })).expect(
        201,
      );
      expect(res.body.couponCode).toBe('WELCOME10');
      expect(res.body.syp).toMatchObject({
        discountMinor: 71_160,
        deliveryFeeMinor: 15_000,
        totalMinor: 655_440,
      });
      const used = () =>
        t.prisma.coupon
          .findUniqueOrThrow({ where: { code: 'WELCOME10' } })
          .then((c) => c.redemptions);
      expect(await used()).toBe(1);
      await t
        .http()
        .post(`/v1/orders/${res.body.number}/cancel`)
        .send({ phone: '+963944123456' })
        .expect(200);
      expect(await used()).toBe(0);
    });

    it('a used-up code is refused', async () => {
      await t.prisma.coupon.update({
        where: { code: 'WELCOME10' },
        data: { maxRedemptions: 1, redemptions: 1 },
      });
      const res = await place(checkout({ couponCode: 'WELCOME10' })).expect(
        422,
      );
      expect(res.body).toMatchObject({
        code: 'COUPON_INVALID',
        problem: 'USED_UP',
      });
    });
  });

  describe('finding and cancelling (FR-ORD-04/05)', () => {
    it('a guest finds the order with its number and phone; a wrong phone finds nothing', async () => {
      await place(checkout()).expect(201);
      await t
        .http()
        .post('/v1/orders/lookup')
        .send({ number: 'BB-1001', phone: '0944123456' })
        .expect(200);
      await t
        .http()
        .post('/v1/orders/lookup')
        .send({ number: 'BB-1001', phone: '0933765432' })
        .expect(404);
    });

    it('a guest cancels before confirmation; the stock and the slot come back', async () => {
      await place(checkout()).expect(201);
      const res = await t
        .http()
        .post('/v1/orders/BB-1001/cancel')
        .send({ phone: '0944123456', reason: 'تغيّر الموعد' })
        .expect(200);
      expect(res.body).toMatchObject({ status: 'CANCELLED', canCancel: false });
      expect(res.body.history.map((h: { status: string }) => h.status)).toEqual(
        ['NEW', 'CANCELLED'],
      );
      expect(await daily('white_gypsophila')).toBe(6);
      expect(await stock('teddy_bear_small')).toBe(6);
      const reservations = await t.prisma.stockReservation.findMany();
      expect(reservations.every((r) => r.releasedAt !== null)).toBe(true);
      // Cancelling twice is refused.
      await t
        .http()
        .post('/v1/orders/BB-1001/cancel')
        .send({ phone: '0944123456' })
        .expect(409);
    });

    it('after the shop confirms, the customer is sent to WhatsApp', async () => {
      await place(checkout()).expect(201);
      const staff = await t.signInAs('MANAGER');
      await t
        .http()
        .patch('/v1/admin/orders/BB-1001/status')
        .set('Authorization', `Bearer ${staff.token}`)
        .send({ to: 'CONFIRMED' })
        .expect(200);
      const res = await t
        .http()
        .post('/v1/orders/BB-1001/cancel')
        .send({ phone: '0944123456' })
        .expect(409);
      expect(res.body.code).toBe('ORDER_NOT_CANCELLABLE');
    });

    it('a signed-in customer sees their orders and saves the address', async () => {
      const me = await t.signInAs('CUSTOMER');
      const other = await t.signInAs('CUSTOMER');
      await place(
        checkout({ address: { ...ABU_RUMMANEH, label: 'العمل', save: true } }),
        randomUUID(),
        me.token,
      ).expect(201);
      const list = await t
        .http()
        .get('/v1/me/orders')
        .set('Authorization', `Bearer ${me.token}`)
        .expect(200);
      expect(list.body).toEqual([
        expect.objectContaining({
          number: 'BB-1001',
          totalMinor: 726_600,
          itemCount: 4,
        }),
      ]);
      await t
        .http()
        .get('/v1/orders/BB-1001')
        .set('Authorization', `Bearer ${me.token}`)
        .expect(200);
      await t
        .http()
        .get('/v1/orders/BB-1001')
        .set('Authorization', `Bearer ${other.token}`)
        .expect(404);
      const addresses = await t
        .http()
        .get('/v1/me/addresses')
        .set('Authorization', `Bearer ${me.token}`)
        .expect(200);
      expect(addresses.body).toEqual([
        expect.objectContaining({
          label: 'العمل',
          zone: expect.objectContaining({ slug: 'abu-rummaneh' }),
        }),
      ]);
    });
  });

  describe('the shop moves orders on (FR-ORD-02/03, UC-04)', () => {
    const move = (token: string, to: string, note?: string) =>
      t
        .http()
        .patch('/v1/admin/orders/BB-1001/status')
        .set('Authorization', `Bearer ${token}`)
        .send({ to, ...(note ? { note } : {}) });

    it('placed to delivered, by the right people; cash is paid on delivery', async () => {
      await place(checkout()).expect(201);
      const florist = await t.signInAs('FLORIST');
      const coordinator = await t.signInAs('DELIVERY_COORDINATOR');

      expect((await move(florist.token, 'READY').expect(409)).body.code).toBe(
        'STATUS_CHANGE_NOT_ALLOWED',
      );
      await move(florist.token, 'CONFIRMED').expect(200);
      await move(florist.token, 'CANCELLED', 'لا يرد').expect(403);
      await move(florist.token, 'PREPARING').expect(200);
      const ready = await move(florist.token, 'READY').expect(200);
      expect(ready.body.next).toEqual([]);
      await move(florist.token, 'OUT_FOR_DELIVERY').expect(403);
      const out = await move(coordinator.token, 'OUT_FOR_DELIVERY').expect(200);
      expect(out.body.next).toEqual(['DELIVERED', 'READY']);
      const done = await move(coordinator.token, 'DELIVERED').expect(200);
      expect(done.body).toMatchObject({
        status: 'DELIVERED',
        paymentStatus: 'PAID',
        customer: { name: 'سارة', phone: '+963944123456' },
      });

      const history = await t.prisma.orderStatusHistory.findMany({
        orderBy: { createdAt: 'asc' },
      });
      expect(history.map((h) => h.to)).toEqual([
        'NEW',
        'CONFIRMED',
        'PREPARING',
        'READY',
        'OUT_FOR_DELIVERY',
        'DELIVERED',
      ]);
      expect(history[1]!.byUserId).toBe(florist.id);
      const audit = await t.prisma.auditLog.findMany({
        where: {
          action: 'order.status.change',
          entityId: (await t.prisma.order.findFirstOrThrow()).id,
        },
      });
      expect(audit).toHaveLength(5);
    });

    it('staff cancel with a reason; stock comes back; customers cannot reach it', async () => {
      await place(checkout()).expect(201);
      const manager = await t.signInAs('MANAGER');
      const customer = await t.signInAs('CUSTOMER');
      await move(customer.token, 'CONFIRMED').expect(403);
      await move(manager.token, 'CANCELLED').expect(400);
      await move(manager.token, 'CANCELLED', 'الزبون لا يرد').expect(200);
      expect(await daily('red_rose')).toBe(120);
    });

    it('the day list in slot order, filtered by status', async () => {
      await place(checkout()).expect(201);
      await place(
        checkout({
          lines: [latteLine],
          slot: { date: '2026-11-12', start: '20:00' },
        }),
      ).expect(201);
      const staff = await t.signInAs('FLORIST');
      const res = await t
        .http()
        .get('/v1/admin/orders?date=2026-11-12&status=NEW')
        .set('Authorization', `Bearer ${staff.token}`)
        .expect(200);
      expect(res.body.map((o: { number: string }) => o.number)).toEqual([
        'BB-1001',
        'BB-1002',
      ]);
      expect(res.body[0].next).toEqual(['CONFIRMED', 'CANCELLED']);
    });
  });

  afterEach(() => {
    t.clock.set(TEST_NOW);
  });
});
