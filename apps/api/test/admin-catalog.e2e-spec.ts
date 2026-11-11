import sharp from 'sharp';
import { createTestApp, type TestApp } from './support/test-app.js';

/** Shop team catalog tools (FR-ADM-02/03/04, FR-DLY-01/02, FR-INV-05, NFR-SEC-08). */
describe('Admin catalog (e2e)', () => {
  let t: TestApp;
  let manager: { id: string; token: string };
  let florist: { id: string; token: string };
  let customer: { id: string; token: string };

  beforeAll(async () => {
    t = await createTestApp();
  });
  beforeEach(async () => {
    await t.reset();
    await t.seedCatalog();
    manager = await t.signInAs('MANAGER');
    florist = await t.signInAs('FLORIST');
    customer = await t.signInAs('CUSTOMER');
  });
  afterAll(async () => {
    await t.close();
  });

  const as = (who: { token: string }) => ({
    Authorization: `Bearer ${who.token}`,
  });

  const newProduct = {
    slug: 'sunflower-bouquet',
    categorySlug: 'flowers',
    kind: 'BOUQUET',
    nameAr: 'باقة دوّار الشمس',
    nameEn: 'Sunflower bouquet',
    basePriceMinor: 150_000,
    occasions: ['thanks'],
    colors: ['yellow'],
    optionGroups: [
      {
        key: 'size',
        nameAr: 'الحجم',
        nameEn: 'Size',
        options: [
          { key: 'small', nameAr: 'صغيرة', nameEn: 'Small', isDefault: true },
          {
            key: 'large',
            nameAr: 'كبيرة',
            nameEn: 'Large',
            priceChangeMinor: 50_000,
          },
        ],
      },
    ],
  };

  describe('roles (NFR-SEC-01)', () => {
    it('customers and guests cannot use admin routes', async () => {
      await t.http().get('/v1/admin/products').expect(401);
      await t.http().get('/v1/admin/products').set(as(customer)).expect(403);
      await t
        .http()
        .post('/v1/admin/products')
        .set(as(customer))
        .send(newProduct)
        .expect(403);
    });

    it('florists run the daily list and stock, not products or prices', async () => {
      await t.http().get('/v1/admin/products').set(as(florist)).expect(200);
      await t
        .http()
        .post('/v1/admin/products')
        .set(as(florist))
        .send(newProduct)
        .expect(403);
      await t
        .http()
        .put('/v1/admin/daily-products')
        .set(as(florist))
        .send({ productSlugs: ['white-tulip-bouquet'] })
        .expect(200);
    });
  });

  describe('products (FR-ADM-02)', () => {
    it('creates a product, derives its price and makes it searchable', async () => {
      const res = await t
        .http()
        .post('/v1/admin/products')
        .set(as(manager))
        .send(newProduct)
        .expect(201);
      expect(res.body).toMatchObject({
        slug: 'sunflower-bouquet',
        displayPriceMinor: 150_000,
        priceFrom: true,
        status: 'ACTIVE',
      });
      const found = await t.http().get('/v1/search?q=دوار الشمس').expect(200);
      expect(found.body.items.map((c: { slug: string }) => c.slug)).toEqual([
        'sunflower-bouquet',
      ]);
      // Tags are searchable too: "شكر" (thanks) and "أصفر" (yellow).
      const tag = await t
        .http()
        .get(`/v1/search?q=${encodeURIComponent('اصفر شكر')}`);
      expect(tag.body.items.map((c: { slug: string }) => c.slug)).toContain(
        'sunflower-bouquet',
      );
    });

    it('audits price changes with before and after (FR-ADM-09)', async () => {
      const { body } = await t
        .http()
        .post('/v1/admin/products')
        .set(as(manager))
        .send(newProduct)
        .expect(201);
      const patched = await t
        .http()
        .patch(`/v1/admin/products/${body.id}`)
        .set(as(manager))
        .send({ basePriceMinor: 160_000 })
        .expect(200);
      expect(patched.body.displayPriceMinor).toBe(160_000);
      // Option groups were left alone.
      expect(patched.body.optionGroups).toHaveLength(1);

      const entries = await t.prisma.auditLog.findMany({
        where: { entityId: body.id },
        orderBy: { createdAt: 'asc' },
      });
      expect(entries.map((e) => e.action)).toEqual([
        'product.create',
        'product.update',
      ]);
      expect(entries[1]).toMatchObject({
        actorId: manager.id,
        actorRole: 'MANAGER',
        before: expect.objectContaining({ basePriceMinor: 150_000 }),
        after: expect.objectContaining({ basePriceMinor: 160_000 }),
      });
    });

    it('replaces option groups and hides a product', async () => {
      const { body } = await t
        .http()
        .post('/v1/admin/products')
        .set(as(manager))
        .send(newProduct)
        .expect(201);
      const res = await t
        .http()
        .patch(`/v1/admin/products/${body.id}`)
        .set(as(manager))
        .send({ optionGroups: [], status: 'HIDDEN' })
        .expect(200);
      expect(res.body).toMatchObject({
        optionGroups: [],
        priceFrom: false,
        status: 'HIDDEN',
      });
      await t.http().get('/v1/products/sunflower-bouquet').expect(404);
    });

    it('refuses bad input', async () => {
      const post = (body: object) =>
        t.http().post('/v1/admin/products').set(as(manager)).send(body);
      expect(
        (await post({ ...newProduct, slug: 'red-rose-bouquet' })).status,
      ).toBe(409);
      expect((await post({ ...newProduct, categorySlug: 'nope' })).status).toBe(
        400,
      );
      expect((await post({ ...newProduct, colors: ['purple'] })).status).toBe(
        400,
      );
      expect(
        (await post({ ...newProduct, occasions: ['halloween'] })).status,
      ).toBe(400);
      expect((await post({ ...newProduct, basePriceMinor: -1 })).status).toBe(
        400,
      );
      expect((await post({ ...newProduct, slug: 'Has Spaces' })).status).toBe(
        400,
      );
      const twoDefaults = {
        ...newProduct,
        optionGroups: [
          {
            ...newProduct.optionGroups[0],
            options: newProduct.optionGroups[0]!.options.map((o) => ({
              ...o,
              isDefault: true,
            })),
          },
        ],
      };
      expect((await post(twoDefaults)).status).toBe(400);
      await t
        .http()
        .patch('/v1/admin/products/00000000-0000-0000-0000-000000000000')
        .set(as(manager))
        .send({ basePriceMinor: 1 })
        .expect(404);
    });
  });

  describe("today's list (FR-DLY-01/02)", () => {
    it("sets the products on today's list", async () => {
      const res = await t
        .http()
        .put('/v1/admin/daily-products')
        .set(as(florist))
        .send({ productSlugs: ['white-tulip-bouquet', 'red-rose-bouquet'] })
        .expect(200);
      expect(res.body.map((p: { slug: string }) => p.slug).sort()).toEqual([
        'red-rose-bouquet',
        'white-tulip-bouquet',
      ]);
      const today = await t.http().get('/v1/daily-flowers');
      expect(
        today.body.products.map((p: { slug: string }) => p.slug).sort(),
      ).toEqual(['red-rose-bouquet', 'white-tulip-bouquet']);
      await t
        .http()
        .put('/v1/admin/daily-products')
        .set(as(florist))
        .send({ productSlugs: ['nope'] })
        .expect(400);
    });

    it('sets the stems; 0 takes one off', async () => {
      await t
        .http()
        .put('/v1/admin/daily-flowers')
        .set(as(florist))
        .send({
          items: [
            { slug: 'gypsophila', quantity: 8 },
            { slug: 'red-rose', quantity: 0 },
            { slug: 'white-tulip', quantity: 12, limited: true },
          ],
        })
        .expect(204);
      const res = await t.http().get('/v1/daily-flowers');
      const stems = res.body.stems as {
        slug: string;
        quantity: number;
        limited: boolean;
      }[];
      expect(stems.find((s) => s.slug === 'gypsophila')!.quantity).toBe(8);
      expect(stems.find((s) => s.slug === 'red-rose')).toBeUndefined();
      expect(stems.find((s) => s.slug === 'white-tulip')).toMatchObject({
        quantity: 12,
        limited: true,
      });
      await t
        .http()
        .put('/v1/admin/daily-flowers')
        .set(as(florist))
        .send({ items: [{ slug: 'nope', quantity: 1 }] })
        .expect(400);
    });
  });

  describe('stock (FR-INV-05)', () => {
    const adjust = (body: object, who = florist) =>
      t.http().post('/v1/admin/stock-adjustments').set(as(who)).send(body);

    it('records each change with who and why', async () => {
      const res = await adjust({
        target: 'product',
        slug: 'glass-vase',
        delta: -2,
        reason: 'Two vases broke',
      }).expect(201);
      expect(res.body).toMatchObject({
        delta: -2,
        quantityAfter: 10,
        userId: florist.id,
      });
      t.clock.advance({ minutes: 5 });
      const wrap = await adjust({
        target: 'designerItem',
        slug: 'satin-burgundy',
        delta: 25,
        reason: 'Delivery from supplier',
      }).expect(201);
      expect(wrap.body.quantityAfter).toBe(75);
      const list = await t
        .http()
        .get('/v1/admin/stock-movements')
        .set(as(manager))
        .expect(200);
      expect(list.body.map((m: { slug: string }) => m.slug)).toEqual([
        'satin-burgundy',
        'glass-vase',
      ]);
    });

    it('never goes below zero', async () => {
      const res = await adjust({
        target: 'product',
        slug: 'glass-vase',
        delta: -20,
        reason: 'Count',
      }).expect(409);
      expect(res.body).toMatchObject({
        code: 'STOCK_INSUFFICIENT',
        available: 12,
      });
      const made = await adjust({
        target: 'product',
        slug: 'gift-card',
        delta: -1,
        reason: 'Count',
      }).expect(409);
      expect(made.body.code).toBe('CONFLICT');
      await adjust({
        target: 'product',
        slug: 'nope',
        delta: 1,
        reason: 'Count',
      }).expect(404);
      await adjust({
        target: 'product',
        slug: 'glass-vase',
        delta: 0,
        reason: 'x',
      }).expect(400);
    });

    it('two staff taking the last pieces at once: only one wins (FR-INV-03)', async () => {
      const results = await Promise.all([
        adjust({
          target: 'product',
          slug: 'glass-vase',
          delta: -7,
          reason: 'Sold in shop',
        }),
        adjust({
          target: 'product',
          slug: 'glass-vase',
          delta: -7,
          reason: 'Sold in shop',
        }),
      ]);
      expect(results.map((r) => r.status).sort((a, b) => a - b)).toEqual([201, 409]);
      const vase = await t.prisma.product.findUniqueOrThrow({
        where: { slug: 'glass-vase' },
      });
      expect(vase.stockQuantity).toBe(5);
    });
  });

  describe('media upload (NFR-SEC-08)', () => {
    it('re-encodes photos to WebP and stores them', async () => {
      const png = await sharp({
        create: { width: 64, height: 48, channels: 3, background: '#872341' },
      })
        .png()
        .toBuffer();
      const res = await t
        .http()
        .post('/v1/admin/media')
        .set(as(manager))
        .attach('file', png, { filename: 'rose.png', contentType: 'image/png' })
        .expect(201);
      expect(res.body).toMatchObject({
        contentType: 'image/webp',
        width: 64,
        height: 48,
      });
      expect(res.body.url).toMatch(
        /^https:\/\/media\.test\/products\/[0-9a-f-]+\.webp$/,
      );
      expect(t.media.files.size).toBe(1);
    });

    it('refuses files that are not images, whatever their name', async () => {
      const res = await t
        .http()
        .post('/v1/admin/media')
        .set(as(manager))
        .attach('file', Buffer.from('<svg onload=alert(1)>'), {
          filename: 'rose.png',
          contentType: 'image/png',
        })
        .expect(400);
      expect(res.body.code).toBe('VALIDATION_FAILED');
      await t.http().post('/v1/admin/media').set(as(manager)).expect(400);
      expect(t.media.files.size).toBe(0);
    });

    it('cut-outs must be transparent; florists cannot upload', async () => {
      const opaque = await sharp({
        create: { width: 8, height: 8, channels: 3, background: '#ffffff' },
      })
        .png()
        .toBuffer();
      await t
        .http()
        .post('/v1/admin/media?kind=cutout')
        .set(as(manager))
        .attach('file', opaque, 'rose.png')
        .expect(400);
      await t
        .http()
        .post('/v1/admin/media')
        .set(as(florist))
        .attach('file', opaque, 'rose.png')
        .expect(403);
    });
  });
});
