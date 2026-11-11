import sharp from 'sharp';
import { createTestApp, TEST_NOW, type TestApp } from './support/test-app.js';

/** The README bouquet (screen 18): 12 red roses, 6 gypsophila, 3 eucalyptus... */
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
  previewMode: '2d',
};

type Spec = typeof README_SPEC & Record<string, unknown>;

describe('Bouquet designer (e2e)', () => {
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

  const quote = (spec: object) =>
    t.http().post('/v1/designer/quote').send({ spec });
  const withSpec = (patch: Partial<Spec>): Spec => ({
    ...README_SPEC,
    ...patch,
  });

  describe('catalog (screens 15-17)', () => {
    it('gives sizes, palettes, occasions, items with stock, and the slots', async () => {
      const res = await t.http().get('/v1/designer/catalog').expect(200);
      const body = res.body as {
        sizes: { key: string; minStems: number; maxStems: number }[];
        occasions: { slug: string }[];
        palettes: { key: string }[];
        items: { id: string; type: string; available: number | null }[];
        layouts: {
          width: number;
          height: number;
          sizes: { size: string; flowers: unknown[] }[];
        };
      };
      expect(body.sizes.map((s) => [s.key, s.minStems, s.maxStems])).toEqual([
        ['small', 8, 14],
        ['medium', 15, 30],
        ['large', 31, 50],
        ['luxury', 51, 100],
      ]);
      expect(body.occasions.at(-1)!.slug).toBe('none');
      expect(body.palettes.map((p) => p.key)).toEqual([
        'pastel',
        'romantic_red',
        'luxury_white',
        'mixed',
      ]);
      const item = (id: string) => body.items.find((i) => i.id === id)!;
      expect(item('red_rose')).toMatchObject({
        type: 'FLOWER',
        available: 120,
      });
      expect(item('white_gypsophila')).toMatchObject({
        type: 'FILLER',
        available: 6,
      });
      expect(item('peony').available).toBe(0);
      expect(item('chocolate_box').available).toBeNull();
      expect(item('teddy_bear_small').available).toBe(6);
      expect(body.layouts).toMatchObject({ width: 1000, height: 1250 });
      expect(
        body.layouts.sizes.find((s) => s.size === 'medium')!.flowers,
      ).toHaveLength(30);
    });

    it('needs no account', async () => {
      await t.http().get('/v1/designer/catalog').expect(200);
      await quote(README_SPEC).expect(200);
    });
  });

  describe('quote (FR-DSG-08)', () => {
    it('prices the README bouquet at 2,676 SYP / $22.30 (screen 18)', async () => {
      const res = await quote(README_SPEC).expect(200);
      expect(res.body).toMatchObject({
        stems: 18,
        size: { key: 'medium', minStems: 15, maxStems: 30 },
        itemsMinor: 267_600,
        totalMinor: 267_600,
        totalUsdCents: 2230,
        usdRate: '120',
        issues: [],
        orderable: true,
        specHash:
          '76651d79b558d732c8353b20aead75d4cea142415241ac283d39ee7bbae1d6c7',
      });
      expect(
        res.body.lines.map(
          (l: { id: string; qty: number; totalMinor: number }) => [
            l.id,
            l.qty,
            l.totalMinor,
          ],
        ),
      ).toEqual([
        ['red_rose', 12, 108_000],
        ['white_gypsophila', 6, 36_000],
        ['eucalyptus', 3, 12_000],
        ['satin_bordeaux', 1, 12_000],
        ['satin_pink', 1, 3_600],
        ['teddy_bear_small', 1, 96_000],
      ]);
    });

    it('ignores any price the client sends (NFR-SEC-06)', async () => {
      const res = await quote(
        withSpec({
          flowers: [{ id: 'red_rose', qty: 18, unitPriceMinor: 1 } as never],
        }),
      ).expect(422);
      expect(res.body.code).toBe('SPEC_INVALID');
      await t
        .http()
        .post('/v1/designer/quote')
        .send({ spec: README_SPEC, totalMinor: 1 })
        .expect(400);
    });

    it('adds the assembly fee when the shop sets one', async () => {
      await t.prisma.setting.upsert({
        where: { key: 'pricing.assemblyFeeMinor' },
        update: { value: 10_000 },
        create: { key: 'pricing.assemblyFeeMinor', value: 10_000 },
      });
      t.app
        .get(
          (await import('../src/modules/settings/settings.service.js'))
            .SettingsService,
        )
        .invalidate();
      const res = await quote(README_SPEC).expect(200);
      expect(res.body).toMatchObject({
        assemblyFeeMinor: 10_000,
        totalMinor: 277_600,
      });
      await t.prisma.setting.delete({
        where: { key: 'pricing.assemblyFeeMinor' },
      });
      t.app
        .get(
          (await import('../src/modules/settings/settings.service.js'))
            .SettingsService,
        )
        .invalidate();
    });
  });

  describe('stock and limits (FR-DSG-03/04, screen 37)', () => {
    it('6 gypsophila left and 8 asked: says 6 and offers substitutes (SRS 6.2)', async () => {
      const res = await quote(
        withSpec({
          flowers: [
            { id: 'red_rose', qty: 12 },
            { id: 'white_gypsophila', qty: 8 },
          ],
        }),
      ).expect(200);
      expect(res.body.orderable).toBe(false);
      expect(res.body.issues).toEqual([
        expect.objectContaining({
          code: 'STOCK_INSUFFICIENT',
          itemId: 'white_gypsophila',
          requested: 8,
          available: 6,
        }),
      ]);
      // The price still shows what was asked, so the customer sees the effect.
      expect(res.body.itemsMinor).toBe(267_600 + 2 * 6_000);
    });

    it("a flower not on today's list is unavailable, with same-color substitutes", async () => {
      const res = await quote(
        withSpec({
          flowers: [
            { id: 'peony', qty: 8 },
            { id: 'red_rose', qty: 10 },
          ],
        }),
      ).expect(200);
      const issue = res.body.issues[0];
      expect(issue).toMatchObject({
        code: 'ITEM_UNAVAILABLE',
        itemId: 'peony',
        available: 0,
      });
      // Same color first (pastel lisianthus, pink rose), the closer price
      // breaking the tie; then the rest.
      expect(issue.alternatives.map((a: { id: string }) => a.id)).toEqual([
        'white_lisianthus',
        'pink_rose',
        'red_rose',
      ]);
      expect(issue.alternatives[1]).toMatchObject({
        sameColor: true,
        available: 60,
      });
    });

    it('stems outside the size limits', async () => {
      const res = await quote(
        withSpec({ flowers: [{ id: 'red_rose', qty: 40 }] }),
      ).expect(200);
      expect(res.body.issues).toEqual([
        { code: 'STEMS_OUT_OF_RANGE', requested: 40, min: 15, max: 30 },
      ]);
      const ok = await quote(
        withSpec({ size: 'large', flowers: [{ id: 'red_rose', qty: 40 }] }),
      ).expect(200);
      expect(ok.body.orderable).toBe(true);
    });

    it('extras have their own stock (teddy: 6)', async () => {
      const res = await quote(
        withSpec({ extras: [{ id: 'teddy_bear_small', qty: 7 }] }),
      ).expect(200);
      expect(res.body.issues[0]).toMatchObject({
        code: 'STOCK_INSUFFICIENT',
        itemId: 'teddy_bear_small',
        available: 6,
      });
    });

    it('an item the shop removed comes back as unavailable, not an error', async () => {
      await t.prisma.designerItem.update({
        where: { slug: 'ruscus' },
        data: { status: 'HIDDEN' },
      });
      const res = await quote(
        withSpec({ greens: [{ id: 'ruscus', qty: 2 }] }),
      ).expect(200);
      expect(res.body.issues[0]).toMatchObject({
        code: 'ITEM_UNAVAILABLE',
        itemId: 'ruscus',
      });
      expect(res.body.issues[0].alternatives[0].id).toBe('eucalyptus');
      expect(res.body.lines.map((l: { id: string }) => l.id)).not.toContain(
        'ruscus',
      );
      await t.prisma.designerItem.update({
        where: { slug: 'ruscus' },
        data: { status: 'ACTIVE' },
      });
    });

    it("at midnight today's stems run out with no job (FR-DLY-05)", async () => {
      t.clock.set('2026-11-12T00:05:00+03:00');
      const res = await quote(README_SPEC).expect(200);
      expect(res.body.orderable).toBe(false);
      expect(res.body.issues.map((i: { itemId: string }) => i.itemId)).toEqual([
        'red_rose',
        'white_gypsophila',
        'eucalyptus',
      ]);
    });
  });

  it('a ready bouquet opens as a valid design ("customize", FR-CAT-07)', async () => {
    const product = await t
      .http()
      .get('/v1/products/red-rose-bouquet')
      .expect(200);
    expect(product.body.designerTemplate).toMatchObject({
      schemaVersion: 1,
      size: 'medium',
      flowers: [{ id: 'red_rose', qty: 25 }],
    });
    const res = await quote(product.body.designerTemplate).expect(200);
    expect(res.body).toMatchObject({ stems: 25, orderable: true });
  });

  describe('bad specs (NFR-SEC-07, FR-DSG-14)', () => {
    const bad = async (spec: object, detail?: string) => {
      const res = await quote(spec).expect(422);
      expect(res.body.code).toBe('SPEC_INVALID');
      if (detail) expect(res.body.detail).toContain(detail);
      return res;
    };

    it('unknown schema version, missing fields, bad ids', async () => {
      const res = await bad(withSpec({ schemaVersion: 2 as never }));
      expect(res.body.problems.length).toBeGreaterThan(0);
      await bad({ ...README_SPEC, flowers: [] });
      await bad(withSpec({ wrap: 'Satin Bordeaux' }));
      await bad(withSpec({ cardMessage: 'م'.repeat(201) }));
    });

    it('items in the wrong place, twice, or an unknown occasion', async () => {
      await bad(withSpec({ wrap: 'red_rose' }), 'not allowed in wrap');
      await bad(
        withSpec({ greens: [{ id: 'red_rose', qty: 2 }] }),
        'not allowed in greens',
      );
      await bad(
        withSpec({
          flowers: [
            { id: 'red_rose', qty: 9 },
            { id: 'red_rose', qty: 9 },
          ],
        }),
        'twice',
      );
      await bad(withSpec({ occasion: 'halloween' }), 'unknown occasion');
    });

    it('"none" is a valid occasion', async () => {
      await quote(withSpec({ occasion: 'none' })).expect(200);
    });
  });

  describe('preview image (FR-D2D-05)', () => {
    it('stores the rendered PNG as WebP', async () => {
      const png = await sharp({
        create: { width: 108, height: 135, channels: 4, background: '#FBEFEC' },
      })
        .png()
        .toBuffer();
      const res = await t
        .http()
        .post('/v1/designer/preview-image')
        .attach('file', png, 'preview.png')
        .expect(201);
      expect(res.body.url).toMatch(
        /^https:\/\/media\.test\/previews\/[0-9a-f-]+\.webp$/,
      );
    });

    it('refuses what is not an image', async () => {
      await t
        .http()
        .post('/v1/designer/preview-image')
        .attach('file', Buffer.from('not an image'), 'preview.png')
        .expect(400);
    });
  });

  describe('admin size limits', () => {
    it('owner and manager only, audited, min not above max', async () => {
      const florist = await t.signInAs('FLORIST');
      const manager = await t.signInAs('MANAGER');
      const body = { sizes: [{ key: 'medium', minStems: 12, maxStems: 36 }] };
      await t
        .http()
        .put('/v1/admin/designer/sizes')
        .set({ Authorization: `Bearer ${florist.token}` })
        .send(body)
        .expect(403);
      const res = await t
        .http()
        .put('/v1/admin/designer/sizes')
        .set({ Authorization: `Bearer ${manager.token}` })
        .send(body)
        .expect(200);
      expect(
        res.body.find((s: { key: string }) => s.key === 'medium'),
      ).toMatchObject({
        minStems: 12,
        maxStems: 36,
      });
      const ok = await quote(
        withSpec({ flowers: [{ id: 'red_rose', qty: 34 }] }),
      ).expect(200);
      expect(ok.body.issues).toEqual([]);
      await t
        .http()
        .put('/v1/admin/designer/sizes')
        .set({ Authorization: `Bearer ${manager.token}` })
        .send({ sizes: [{ key: 'medium', minStems: 40, maxStems: 30 }] })
        .expect(400);
      const audit = await t.prisma.auditLog.findFirst({
        where: { action: 'designer.sizes.update', actorId: manager.id },
      });
      expect(audit).not.toBeNull();
      await t
        .http()
        .put('/v1/admin/designer/sizes')
        .set({ Authorization: `Bearer ${manager.token}` })
        .send({ sizes: [{ key: 'medium', minStems: 15, maxStems: 30 }] })
        .expect(200);
    });
  });
});
