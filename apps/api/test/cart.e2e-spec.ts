import sharp from 'sharp';
import { createTestApp, TEST_NOW, type TestApp } from './support/test-app.js';

/** The README bouquet (screen 18): 2,676 SYP. */
const README_SPEC = {
  schemaVersion: 1,
  occasion: 'birthday',
  size: 'medium',
  flowers: [
    { id: 'red_rose', qty: 12 },
    { id: 'white_gypsophila', qty: 6 },
  ],
  greens: [{ id: 'eucalyptus', qty: 3 }],
  wrap: 'satin_bordeaux',
  ribbon: 'satin_pink',
  extras: [{ id: 'teddy_bear_small', qty: 1 }],
  cardMessage: 'كل عام وأنتِ أجمل يا لين',
};

const designLine = { id: 'l1', kind: 'design', qty: 1, spec: README_SPEC };
const latteLine = {
  id: 'l2',
  kind: 'product',
  qty: 2,
  product: { slug: 'iced-rose-matcha-latte', options: [] },
};
const cakeLine = {
  id: 'l3',
  kind: 'product',
  qty: 1,
  product: {
    slug: 'rose-pistachio-cake',
    options: [
      { group: 'size', option: '22cm' },
      { group: 'extras', option: 'birthday-candle' },
    ],
    inscription: 'كل عام وأنت بخير',
  },
};
/** Screen 20: 2,676 + 2 x 540 + 3,360 = 7,116 SYP (7,266 with delivery, S5). */
const README_CART = [designLine, latteLine, cakeLine];

const boxLine = (compartments: object[], boxType = 'square_two') => ({
  id: 'b1',
  kind: 'box',
  qty: 1,
  spec: { schemaVersion: 1, boxType, compartments },
});

describe('Cart (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
    await t.reset();
    await t.seedCatalog();
  });
  afterEach(() => {
    t.clock.set(TEST_NOW);
  });
  afterAll(async () => {
    await t.close();
  });

  const quote = (body: object, ip?: string) => {
    const req = t.http().post('/v1/cart/quote');
    if (ip) req.set('X-Forwarded-For', ip);
    return req.send(body);
  };

  describe('the README cart (screen 20, NFR-FUN-01)', () => {
    it('with the Abu Rummaneh fee: 7,266 SYP and $60.55 (screen 23, FR-CRT-08)', async () => {
      const res = await quote({
        lines: README_CART,
        zone: 'abu-rummaneh',
      }).expect(200);
      expect(res.body.syp).toMatchObject({
        itemsMinor: 711_600,
        deliveryFeeMinor: 15_000,
        totalMinor: 726_600,
      });
      expect(res.body.usd.totalMinor).toBe(6055);
      const unknown = await quote({
        lines: README_CART,
        zone: 'no-such-zone',
      }).expect(422);
      expect(unknown.body.code).toBe('OUT_OF_ZONE');
    });

    it('7,116 SYP and $59.30, ready tomorrow at 15:00 because of the cake', async () => {
      const res = await quote({ lines: README_CART }).expect(200);
      expect(res.body).not.toHaveProperty('coupon');
      expect(res.body.syp).toEqual({
        itemsMinor: 711_600,
        assemblyFeeMinor: 0,
        discountMinor: 0,
        deliveryFeeMinor: 0,
        roundingAdjustmentMinor: 0,
        totalMinor: 711_600,
      });
      expect(res.body.usd.totalMinor).toBe(5930);
      expect(res.body).toMatchObject({
        usdRate: '120',
        leadTimeHours: 24,
        earliestAt: '2026-11-12T15:00:00.000+03:00',
        earliestInDays: 1,
        orderable: true,
      });
      const [design, latte, cake] = res.body.lines;
      expect(design).toMatchObject({
        kind: 'design',
        title: { ar: 'باقتك المصمّمة' },
        unitPriceMinor: 267_600,
        totalMinor: 267_600,
      });
      expect(design.summary.ar).toBe(
        'جوري أحمر 12 · جيبسوفيلا (بيبي بريث) 6 · أوكاليبتوس 3 · ساتان · وردي · دبدوب صغير',
      );
      expect(latte).toMatchObject({
        unitPriceMinor: 54_000,
        totalMinor: 108_000,
      });
      expect(latte.summary.ar).toBe('حليب كامل الدسم · عادي · عادي');
      expect(cake).toMatchObject({
        unitPriceMinor: 336_000,
        leadTimeHours: 24,
      });
      expect(cake.summary.ar).toBe(
        'وسط · 22 سم · الورد والفستق · شمعة عيد ميلاد · رسالة على الكيك',
      );
    });

    it('suggests what goes with the cart (screen 20, "قد يعجبك أيضاً")', async () => {
      const res = await quote({ lines: [cakeLine] }).expect(200);
      const slugs = res.body.suggestions.map((s: { slug: string }) => s.slug);
      expect(slugs[0]).toBe('birthday-candle');
      expect(slugs).not.toContain('rose-pistachio-cake');
      expect(slugs.length).toBeLessThanOrEqual(4);
    });

    it('an empty cart prices to zero and is not orderable', async () => {
      const res = await quote({ lines: [] }).expect(200);
      expect(res.body).toMatchObject({
        orderable: false,
        syp: { totalMinor: 0 },
      });
    });
  });

  describe('coupons (FR-CRT-07, NFR-SEC-03)', () => {
    it('WELCOME10 takes 10% before delivery, in both currencies', async () => {
      const res = await quote(
        { lines: README_CART, couponCode: 'welcome10' },
        '10.0.0.1',
      ).expect(200);
      expect(res.body.coupon).toEqual({
        code: 'WELCOME10',
        applied: true,
        minOrderMinor: 0,
      });
      expect(res.body.syp).toMatchObject({
        discountMinor: 71_160,
        totalMinor: 640_440,
      });
      expect(res.body.usd).toMatchObject({
        discountMinor: 593,
        totalMinor: 5337,
      });
    });

    it('a code below its minimum order is not applied and says why', async () => {
      const res = await quote(
        { lines: README_CART, couponCode: 'BIG500' },
        '10.0.0.2',
      ).expect(200);
      expect(res.body.coupon).toMatchObject({
        applied: false,
        problem: 'MIN_ORDER',
        minOrderMinor: 1_000_000,
      });
      expect(res.body.syp.discountMinor).toBe(0);
    });

    it('expired codes are refused', async () => {
      await t.prisma.coupon.create({
        data: {
          code: 'OLD5',
          type: 'PERCENT',
          value: 5,
          endsAt: new Date('2026-01-01'),
        },
      });
      const res = await quote(
        { lines: README_CART, couponCode: 'OLD5' },
        '10.0.0.3',
      ).expect(200);
      expect(res.body.coupon.problem).toBe('EXPIRED');
    });

    it('10 wrong guesses an hour, then 429; valid codes never count', async () => {
      const ip = '10.0.0.9';
      for (let i = 0; i < 5; i++) {
        await quote({ lines: README_CART, couponCode: 'WELCOME10' }, ip).expect(
          200,
        );
      }
      for (let i = 0; i < 10; i++) {
        const res = await quote(
          { lines: README_CART, couponCode: `NOPE${i}` },
          ip,
        ).expect(200);
        expect(res.body.coupon.problem).toBe('NOT_FOUND');
      }
      const blocked = await quote(
        { lines: README_CART, couponCode: 'WELCOME10' },
        ip,
      ).expect(429);
      expect(blocked.body.code).toBe('RATE_LIMITED');
      expect(blocked.body.retryAfterSeconds).toBeGreaterThan(0);
      // Another customer is not affected; an hour later the first is free again.
      await quote(
        { lines: README_CART, couponCode: 'WELCOME10' },
        '10.0.0.10',
      ).expect(200);
      t.clock.advance({ hours: 1, minutes: 1 });
      await quote({ lines: README_CART, couponCode: 'WELCOME10' }, ip).expect(
        200,
      );
    });
  });

  describe('line problems come back on the line', () => {
    const line = (product: object, qty = 1) => ({
      id: 'p',
      kind: 'product',
      qty,
      product,
    });

    it('unknown product, unknown option, not enough stock', async () => {
      const res = await quote({
        lines: [
          { ...line({ slug: 'no-such-product', options: [] }), id: 'a' },
          {
            ...line({
              slug: 'iced-rose-matcha-latte',
              options: [{ group: 'milk', option: 'goat' }],
            }),
            id: 'b',
          },
          { ...line({ slug: 'glass-vase', options: [] }, 13), id: 'c' },
        ],
      }).expect(200);
      expect(res.body.orderable).toBe(false);
      expect(
        res.body.lines.map((l: { issues: { code: string }[] }) => l.issues),
      ).toEqual([
        [{ code: 'PRODUCT_UNAVAILABLE' }],
        [{ code: 'OPTION_UNAVAILABLE' }],
        [{ code: 'STOCK_INSUFFICIENT', requested: 13, available: 12 }],
      ]);
      // An unknown milk falls back to the default, so the price stays sensible.
      expect(res.body.lines[1].unitPriceMinor).toBe(54_000);
    });

    it('a message only where the product takes one, and not too long (FR-CKE-03)', async () => {
      const res = await quote({
        lines: [
          {
            ...line({
              slug: 'iced-rose-matcha-latte',
              options: [],
              inscription: 'hi',
            }),
            id: 'a',
          },
          {
            ...line({
              slug: 'rose-pistachio-cake',
              options: [],
              inscription: 'م'.repeat(41),
            }),
            id: 'b',
          },
          {
            ...line({
              slug: 'rose-pistachio-cake',
              options: [],
              inscription: '🎂'.repeat(40),
            }),
            id: 'c',
          },
        ],
      }).expect(200);
      expect(res.body.lines[0].issues).toEqual([
        { code: 'INSCRIPTION_NOT_ALLOWED' },
      ]);
      expect(res.body.lines[1].issues).toEqual([
        { code: 'INSCRIPTION_NOT_ALLOWED' },
      ]);
      expect(res.body.lines[2].issues).toEqual([]);
    });

    it('a design short of stock carries the designer issue (FR-DSG-03)', async () => {
      const spec = {
        ...README_SPEC,
        flowers: [
          { id: 'red_rose', qty: 12 },
          { id: 'white_gypsophila', qty: 8 },
        ],
      };
      const res = await quote({ lines: [{ ...designLine, spec }] }).expect(200);
      expect(res.body.lines[0].issues).toEqual([
        expect.objectContaining({
          code: 'STOCK_INSUFFICIENT',
          itemId: 'white_gypsophila',
          available: 6,
        }),
      ]);
    });

    it('rounding to the shop step applies to the total only', async () => {
      await t.prisma.setting.upsert({
        where: { key: 'pricing.rounding' },
        update: { value: { mode: 'nearest', stepMinor: 100_000 } },
        create: {
          key: 'pricing.rounding',
          value: { mode: 'nearest', stepMinor: 100_000 },
        },
      });
      const settings =
        await import('../src/modules/settings/settings.service.js');
      t.app.get(settings.SettingsService).invalidate();
      const res = await quote({ lines: README_CART }).expect(200);
      expect(res.body.syp).toMatchObject({
        itemsMinor: 711_600,
        roundingAdjustmentMinor: -11_600,
        totalMinor: 700_000,
      });
      await t.prisma.setting.delete({ where: { key: 'pricing.rounding' } });
      t.app.get(settings.SettingsService).invalidate();
    });
  });

  describe('split boxes (screen 19, FR-BOX-01..04)', () => {
    const flowers = (qty: number, id = 'pink_rose') => ({
      index: 0,
      items: [{ id, qty }],
    });
    const sweets = (qty: number, id = 'macaron_piece') => ({
      index: 1,
      items: [{ id, qty }],
    });

    it('lists the box types with their "from" prices', async () => {
      const res = await t.http().get('/v1/boxes/catalog').expect(200);
      expect(
        res.body.types.map((b: { id: string; fromPriceMinor: number }) => [
          b.id,
          b.fromPriceMinor,
        ]),
      ).toEqual([
        ['square_two', 252_000],
        ['rectangle_three', 360_000],
      ]);
      expect(res.body.types[0].compartments[1]).toMatchObject({
        kind: 'SWEET',
        capacity: 6,
      });
      const ids = res.body.items.map((i: { id: string }) => i.id);
      expect(ids).toEqual(
        expect.arrayContaining([
          'pink_rose',
          'macaron_piece',
          'teddy_bear_small',
        ]),
      );
      expect(ids).not.toContain('satin_bordeaux');
    });

    it('9 pink roses and 6 macarons: 2,520', async () => {
      const res = await quote({
        lines: [boxLine([flowers(9), sweets(6)])],
      }).expect(200);
      expect(res.body.lines[0]).toMatchObject({
        kind: 'box',
        unitPriceMinor: 252_000,
        issues: [],
        title: { ar: 'مربع · ركنان' },
      });
      expect(res.body.lines[0].summary.ar).toBe('جوري وردي × 9 · ماكرون × 6');
    });

    it('over capacity, wrong compartment, missing compartment', async () => {
      const res = await quote({
        lines: [
          { ...boxLine([flowers(13), sweets(7)]), id: 'a' },
          { ...boxLine([sweets(2, 'red_rose')]), id: 'b' },
          {
            ...boxLine([
              { index: 2, items: [{ id: 'teddy_bear_small', qty: 1 }] },
            ]),
            id: 'c',
          },
        ],
      }).expect(200);
      const codes = res.body.lines.map((l: { issues: { code: string }[] }) =>
        l.issues.map((i) => i.code),
      );
      expect(codes[0]).toEqual(['BOX_OVER_CAPACITY']);
      expect(codes[1]).toEqual(['BOX_COMPARTMENT_INVALID']);
      expect(codes[2]).toEqual(['BOX_COMPARTMENT_INVALID']);
    });

    it('the long box takes a gift; unknown boxes and bad specs are 422', async () => {
      const gift = { index: 2, items: [{ id: 'teddy_bear_small', qty: 1 }] };
      const ok = await quote({
        lines: [boxLine([flowers(9), sweets(6), gift], 'rectangle_three')],
      }).expect(200);
      expect(ok.body.lines[0]).toMatchObject({
        unitPriceMinor: 360_000 + 96_000,
        issues: [],
      });
      await quote({ lines: [boxLine([flowers(9)], 'nope')] }).expect(422);
      await quote({ lines: [boxLine([])] }).expect(422);
    });
  });

  describe('request checks (NFR-SEC-06)', () => {
    it('refuses prices, duplicate ids, bad quantities and too many lines', async () => {
      await quote({ lines: [{ ...latteLine, unitPriceMinor: 1 }] }).expect(400);
      await quote({ lines: README_CART, totalMinor: 1 }).expect(400);
      await quote({ lines: [latteLine, latteLine] }).expect(400);
      await quote({ lines: [{ ...latteLine, qty: 0 }] }).expect(400);
      await quote({
        lines: Array.from({ length: 51 }, (_, i) => ({
          ...latteLine,
          id: `x${i}`,
        })),
      }).expect(400);
      await quote({ lines: [{ id: 'd', kind: 'design', qty: 1 }] }).expect(400);
    });
  });

  describe('saved cart (FR-CRT-03)', () => {
    it('needs an account; each account sees its own', async () => {
      await t.http().get('/v1/me/cart').expect(401);
      const a = await t.signInAs('CUSTOMER');
      const b = await t.signInAs('CUSTOMER');
      const empty = await t
        .http()
        .get('/v1/me/cart')
        .set({ Authorization: `Bearer ${a.token}` })
        .expect(200);
      expect(empty.body).toEqual({ lines: [], updatedAt: null });

      await t
        .http()
        .put('/v1/me/cart')
        .set({ Authorization: `Bearer ${a.token}` })
        .send({ lines: README_CART })
        .expect(200);
      const saved = await t
        .http()
        .get('/v1/me/cart')
        .set({ Authorization: `Bearer ${a.token}` })
        .expect(200);
      expect(saved.body.lines).toHaveLength(3);
      expect(saved.body.lines[2].product.inscription).toBe('كل عام وأنت بخير');
      const other = await t
        .http()
        .get('/v1/me/cart')
        .set({ Authorization: `Bearer ${b.token}` })
        .expect(200);
      expect(other.body.lines).toEqual([]);
      await t
        .http()
        .put('/v1/me/cart')
        .set({ Authorization: `Bearer ${a.token}` })
        .send({ lines: [{ ...latteLine, price: 1 }] })
        .expect(400);
    });
  });

  describe('uploads and admin', () => {
    it('stores a reference photo for a cake (FR-CKE-04)', async () => {
      const jpg = await sharp({
        create: { width: 30, height: 20, channels: 3, background: '#fff' },
      })
        .jpeg()
        .toBuffer();
      const res = await t
        .http()
        .post('/v1/uploads/reference-image')
        .attach('file', jpg, 'cake.jpg')
        .expect(201);
      expect(res.body.url).toMatch(
        /^https:\/\/media\.test\/references\/.+\.webp$/,
      );
    });

    it('managers add coupons (audited); florists cannot', async () => {
      const manager = await t.signInAs('MANAGER');
      const florist = await t.signInAs('FLORIST');
      const body = { code: 'eid20', type: 'PERCENT', value: 20 };
      await t
        .http()
        .post('/v1/admin/coupons')
        .set({ Authorization: `Bearer ${florist.token}` })
        .send(body)
        .expect(403);
      const res = await t
        .http()
        .post('/v1/admin/coupons')
        .set({ Authorization: `Bearer ${manager.token}` })
        .send(body)
        .expect(201);
      expect(res.body).toMatchObject({
        code: 'EID20',
        value: 20,
        active: true,
      });
      await t
        .http()
        .post('/v1/admin/coupons')
        .set({ Authorization: `Bearer ${manager.token}` })
        .send(body)
        .expect(409);
      await t
        .http()
        .post('/v1/admin/coupons')
        .set({ Authorization: `Bearer ${manager.token}` })
        .send({ code: 'TOOMUCH', type: 'PERCENT', value: 150 })
        .expect(400);
      const audit = await t.prisma.auditLog.findFirst({
        where: { action: 'coupon.create', entityId: res.body.id },
      });
      expect(audit).not.toBeNull();

      const priced = await quote(
        { lines: [latteLine], couponCode: 'Eid20' },
        '10.0.0.20',
      ).expect(200);
      expect(priced.body.syp.discountMinor).toBe(21_600);
    });
  });
});
