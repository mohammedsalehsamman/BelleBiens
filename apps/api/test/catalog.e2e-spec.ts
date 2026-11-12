import { createTestApp, TEST_NOW, type TestApp } from './support/test-app.js';

interface Card {
  slug: string;
  priceMinor: number;
  priceFrom: boolean;
  available: boolean;
  badges: string[];
  stockLeft: number | null;
  categorySlug: string;
  name: { ar: string; en: string };
}

const slugs = (cards: Card[]) => cards.map((c) => c.slug);

/** Browsing, search, today's flowers and the branch (screens 06-14, 32, 34). */
describe('Catalog (e2e)', () => {
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

  const get = (path: string) => t.http().get(path);

  describe('home (screen 06)', () => {
    it('returns categories, today, cakes and the branch in one call', async () => {
      const res = await get('/v1/home').expect(200);
      const body = res.body as {
        categories: {
          slug: string;
          productCount: number;
          name: { ar: string };
        }[];
        today: Card[];
        cakes: Card[];
        branch: { status: { openNow: boolean; closesAt: string } };
      };
      expect(body.categories.map((c) => [c.slug, c.productCount])).toEqual([
        ['flowers', 8],
        ['cakes', 5],
        ['coffee', 2],
        ['gifts', 5],
      ]);
      expect(body.categories[0]!.name.ar).toBe('ورد وباقات');
      expect(slugs(body.today)).toEqual([
        'red-rose-bouquet',
        'spring-peony-bouquet',
        'white-hydrangea-bouquet',
        'cascading-spring-bouquet',
      ]);
      expect(body.today[0]).toMatchObject({
        priceMinor: 240_000,
        priceFrom: false,
        available: true,
        badges: ['todayOnly', 'bestSeller'],
        stockLeft: 8,
      });
      expect(body.cakes[0]).toMatchObject({
        slug: 'rose-pistachio-cake',
        priceMinor: 228_000,
        priceFrom: true,
      });
      expect(body.branch.status).toMatchObject({
        openNow: true,
        closesAt: '24:00',
      });
    });

    it('works without an account', async () => {
      await get('/v1/home').expect(200);
      await get('/v1/products').expect(200);
    });
  });

  describe('products (screen 07, FR-CAT-02/03)', () => {
    it('lists by popularity with pages', async () => {
      const first = await get('/v1/products?pageSize=5').expect(200);
      expect(first.body.total).toBe(20);
      expect(slugs(first.body.items)).toEqual([
        'red-rose-bouquet',
        'rose-pistachio-cake',
        'chocolate-box-16',
        'spring-peony-bouquet',
        'glass-vase',
      ]);
      const second = await get('/v1/products?pageSize=5&page=2').expect(200);
      expect(second.body.items[0].slug).toBe('white-hydrangea-bouquet');
      expect(second.body.page).toBe(2);
    });

    it('filters by category, occasion, colors and flower types', async () => {
      const flowers = await get('/v1/products?category=flowers&pageSize=50');
      expect(flowers.body.total).toBe(8);
      const birthday = await get('/v1/products?occasion=birthday&pageSize=50');
      expect(slugs(birthday.body.items)).toEqual(
        expect.arrayContaining([
          'red-rose-bouquet',
          'rose-pistachio-cake',
          'birthday-candle',
        ]),
      );
      const colors = await get('/v1/products?colors=white,yellow&pageSize=50');
      expect(slugs(colors.body.items).sort()).toEqual([
        'cascading-spring-bouquet',
        'white-hydrangea-bouquet',
        'white-tulip-bouquet',
      ]);
      const peony = await get('/v1/products?flowerTypes=peony&pageSize=50');
      expect(slugs(peony.body.items).sort()).toEqual([
        'spring-peony-bouquet',
        'white-hydrangea-bouquet',
      ]);
    });

    it('filters and sorts by the shown price', async () => {
      const res = await get(
        '/v1/products?category=flowers&minPrice=200000&maxPrice=250000&sort=price_asc',
      ).expect(200);
      expect(res.body.items.map((c: Card) => c.priceMinor)).toEqual([
        204_000, 216_000, 240_000,
      ]);
      const cheapest = await get('/v1/products?sort=price_asc&pageSize=1');
      expect(cheapest.body.items[0].slug).toBe('gift-card');
      const dearest = await get('/v1/products?sort=price_desc&pageSize=1');
      expect(dearest.body.items[0].slug).toBe('luxury-red-rose-bouquet');
    });

    it('counts without items for the "show 7 products" button (screen 09)', async () => {
      const res = await get('/v1/products?occasion=love&pageSize=0').expect(
        200,
      );
      expect(res.body.items).toEqual([]);
      expect(res.body.total).toBeGreaterThan(0);
    });

    it('"deliverable today" leaves out the 24 hour cake (FR-DLV-05)', async () => {
      const res = await get(
        '/v1/products?category=cakes&deliverableToday=true&pageSize=50',
      );
      expect(slugs(res.body.items)).not.toContain('rose-pistachio-cake');
      expect(res.body.total).toBe(4);
      // At 23:30 a one-hour job no longer makes it before midnight.
      t.clock.set('2026-11-11T23:30:00+03:00');
      const late = await get('/v1/products?deliverableToday=true&pageSize=50');
      expect(late.body.total).toBe(20 - 1);
    });

    it('rejects unknown parameters and sorts (NFR-SEC-06 whitelist)', async () => {
      const bad = await get('/v1/products?sort=cheap').expect(400);
      expect(bad.body.code).toBe('VALIDATION_FAILED');
      await get('/v1/products?price=1').expect(400);
      await get('/v1/products?pageSize=500').expect(400);
    });
  });

  describe('product page (screens 12-14)', () => {
    it('bouquet: sizes, included wraps, gift card, designer, pairings', async () => {
      const res = await get('/v1/products/red-rose-bouquet').expect(200);
      const p = res.body;
      expect(p).toMatchObject({
        priceMinor: 240_000,
        kind: 'BOUQUET',
        customizable: true,
        earliestDeliveryInDays: 0,
        isFavorite: false,
        category: { slug: 'flowers' },
      });
      expect(p.description.ar).toContain('ورد جوري أحمر');
      const groups = p.optionGroups as {
        key: string;
        selection: string;
        required: boolean;
        options: {
          key: string;
          priceChangeMinor: number;
          isDefault: boolean;
          detail: { ar: string };
        }[];
      }[];
      expect(groups.map((g) => g.key)).toEqual(['size', 'wrap', 'gift-card']);
      expect(
        groups[0]!.options.map((o) => [
          o.key,
          180_000 + o.priceChangeMinor,
          o.isDefault,
        ]),
      ).toEqual([
        ['classic', 180_000, false],
        ['medium', 240_000, true],
        ['luxury', 336_000, false],
      ]);
      expect(groups[0]!.options[0]!.detail.ar).toBe('15 وردة');
      expect(groups[1]!.options.every((o) => o.priceChangeMinor === 0)).toBe(
        true,
      );
      expect(groups[2]).toMatchObject({
        selection: 'MULTIPLE',
        required: false,
      });
      expect(slugs(p.pairings)).toEqual(['macarons-6', 'gift-card']);
    });

    it('cake: allergens and next-day delivery', async () => {
      const res = await get('/v1/products/rose-pistachio-cake').expect(200);
      expect(res.body.allergens).toEqual(['nuts', 'milk', 'eggs', 'gluten']);
      expect(res.body.earliestDeliveryInDays).toBe(1);
      expect(res.body.priceFrom).toBe(true);
      expect(res.body).toMatchObject({
        inscriptionMaxLength: 40,
        allowsReferenceImage: true,
      });
      expect(res.body.inscriptionSuggestions).toContain('مبروك');
      expect(res.body.optionGroups.map((g: { key: string }) => g.key)).toEqual([
        'size',
        'flavor',
        'extras',
      ]);
    });

    it('drink: milk, sweetness and ice, with a plain price', async () => {
      const res = await get('/v1/products/iced-rose-matcha-latte').expect(200);
      expect(res.body.priceMinor).toBe(54_000);
      expect(res.body.priceFrom).toBe(false);
      expect(res.body.optionGroups.map((g: { key: string }) => g.key)).toEqual([
        'milk',
        'sweetness',
        'ice',
      ]);
    });

    it('unknown, malformed and hidden products are 404', async () => {
      const missing = await get('/v1/products/no-such-thing').expect(404);
      expect(missing.body.code).toBe('NOT_FOUND');
      await get('/v1/products/Bad%20Slug').expect(404);
      await t.prisma.product.update({
        where: { slug: 'berry-tart' },
        data: { status: 'HIDDEN' },
      });
      await get('/v1/products/berry-tart').expect(404);
      const list = await get('/v1/products?category=cakes&pageSize=50');
      expect(slugs(list.body.items)).not.toContain('berry-tart');
      await t.prisma.product.update({
        where: { slug: 'berry-tart' },
        data: { status: 'ACTIVE' },
      });
    });
  });

  describe('Arabic search (screen 08, FR-CAT-04)', () => {
    const search = (q: string, extra = '') =>
      get(`/v1/search?q=${encodeURIComponent(q)}${extra}`).expect(200);

    it('ignores ta marbuta, hamza and diacritics', async () => {
      const a = await search('باقه الجوري');
      const b = await search('باقةُ الجوريّ');
      expect(slugs(a.body.items)).toEqual(slugs(b.body.items));
      expect(slugs(a.body.items)).toEqual(
        expect.arrayContaining(['red-rose-bouquet', 'luxury-red-rose-bouquet']),
      );
      const gift = await search('اهداء');
      expect(slugs(gift.body.items)).toContain('gift-card');
    });

    it('needs every word and puts name matches first', async () => {
      const res = await search('جوري');
      expect(slugs(res.body.items).slice(0, 2)).toEqual([
        'red-rose-bouquet',
        'luxury-red-rose-bouquet',
      ]);
      const both = await search('جوري فاخرة');
      expect(slugs(both.body.items)).toEqual(['luxury-red-rose-bouquet']);
    });

    it('finds English names and tags', async () => {
      const res = await search('Rose MATCHA');
      expect(slugs(res.body.items)).toEqual(['iced-rose-matcha-latte']);
      const tag = await search('عيد ميلاد');
      expect(slugs(tag.body.items)).toContain('birthday-candle');
    });

    it('counts matches per category for the tabs, and filters by one', async () => {
      const res = await search('ورد');
      const facets = res.body.facets as {
        categorySlug: string;
        count: number;
      }[];
      expect(facets.map((f) => f.categorySlug)).toEqual([
        'flowers',
        'cakes',
        'coffee',
      ]);
      expect(res.body.total).toBe(facets.reduce((s, f) => s + f.count, 0));
      const cakes = await search('ورد', '&category=cakes');
      expect(
        cakes.body.items.every((c: Card) => c.categorySlug === 'cakes'),
      ).toBe(true);
      expect(cakes.body.total).toBe(res.body.total);
    });

    it('an empty query finds nothing; a missing one is invalid', async () => {
      const res = await search('   ');
      expect(res.body).toMatchObject({ total: 0, items: [], facets: [] });
      await get('/v1/search').expect(400);
    });
  });

  describe("today's flowers (screen 10, FR-DLY-01..05)", () => {
    it("lists today's products and stems with the expiry", async () => {
      const res = await get('/v1/daily-flowers').expect(200);
      expect(res.body.date).toBe('2026-11-11');
      expect(res.body.expiresAt).toBe('2026-11-12T00:00:00.000+03:00');
      expect(slugs(res.body.products)).toHaveLength(4);
      const stems = res.body.stems as {
        slug: string;
        quantity: number;
        limited: boolean;
      }[];
      expect(stems.map((s) => [s.slug, s.quantity])).toEqual([
        ['red_rose', 120],
        ['pink_rose', 60],
        ['white_rose', 40],
        ['white_lisianthus', 30],
        ['white_gypsophila', 6],
        ['eucalyptus', 40],
        ['ruscus', 30],
      ]);
      // Peony and white tulip are not on today's list (screen 16).
      expect(stems.map((s) => s.slug)).not.toContain('peony');
    });

    it('expires at midnight Damascus time with no job running (FR-DLY-05)', async () => {
      t.clock.set('2026-11-11T23:59:00+03:00');
      expect((await get('/v1/daily-flowers')).body.stems).toHaveLength(7);

      t.clock.set('2026-11-12T00:01:00+03:00');
      const next = await get('/v1/daily-flowers').expect(200);
      expect(next.body.date).toBe('2026-11-12');
      expect(next.body.products).toEqual([]);
      expect(next.body.stems).toEqual([]);
      // "Today only" bouquet can no longer be ordered; the others still can.
      const red = await get('/v1/products/red-rose-bouquet');
      expect(red.body).toMatchObject({
        available: false,
        badges: ['unavailable'],
      });
      const peony = await get('/v1/products/spring-peony-bouquet');
      expect(peony.body.available).toBe(true);
      expect(peony.body.badges).not.toContain('today');
    });
  });

  describe('occasions and filters (screens 09, 11)', () => {
    it('lists occasions and opens one', async () => {
      const list = await get('/v1/occasions').expect(200);
      expect(list.body.map((o: { slug: string }) => o.slug)).toEqual([
        'birthday',
        'love',
        'graduation',
        'newborn',
        'thanks',
        'apology',
        'engagement',
      ]);
      const page = await get('/v1/occasions/birthday').expect(200);
      expect(page.body.occasion.title.ar).toBe('هدايا عيد الميلاد');
      expect(slugs(page.body.products)).toEqual(
        expect.arrayContaining([
          'red-rose-bouquet',
          'rose-pistachio-cake',
          'birthday-candle',
        ]),
      );
      await get('/v1/occasions/nope').expect(404);
    });

    it('gives the filter choices and the price range', async () => {
      const res = await get('/v1/catalog/filters').expect(200);
      expect(
        res.body.colors.map((c: { name: { ar: string } }) => c.name.ar),
      ).toEqual(['أحمر', 'وردي', 'أبيض', 'باستيل', 'أصفر']);
      expect(res.body.flowerTypes).toHaveLength(5);
      expect(res.body.occasions).toHaveLength(7);
      expect(res.body.price).toEqual({ minMinor: 12_000, maxMinor: 336_000 });
    });
  });

  describe('branch and pages (screen 34, FR-CON-03/04)', () => {
    it('gives contact, hours, partners and the policy pages in order', async () => {
      const res = await get('/v1/branch').expect(200);
      expect(res.body).toMatchObject({
        code: 'abu-rummaneh',
        address: { ar: 'زقاق الكرامة، أبو رمانة، دمشق' },
        instagram: 'bellebiens',
        partners: ['Movo', 'BeeOrder'],
        status: {
          mode: 'open',
          openNow: true,
          opensAt: '10:00',
          closesAt: '24:00',
        },
      });
      expect(res.body.pages.map((p: { slug: string }) => p.slug)).toEqual([
        'delivery',
        'cancellation',
        'privacy',
        'terms',
      ]);
    });

    it('is closed before opening and in closed mode', async () => {
      t.clock.set('2026-11-11T09:00:00+03:00');
      expect((await get('/v1/branch')).body.status.openNow).toBe(false);
    });

    it('serves a page in both languages', async () => {
      const res = await get('/v1/pages/delivery').expect(200);
      expect(res.body.title).toEqual({
        ar: 'سياسة التوصيل',
        en: 'Delivery policy',
      });
      await get('/v1/pages/unknown').expect(404);
    });
  });

  describe('favorites (screen 32, FR-ACC-06)', () => {
    it('needs an account', async () => {
      await get('/v1/me/favorites').expect(401);
      await t.http().put('/v1/me/favorites/red-rose-bouquet').expect(401);
    });

    it('saves, lists, marks and removes', async () => {
      const { token } = await t.signInAs('CUSTOMER');
      const auth = { Authorization: `Bearer ${token}` };
      await t
        .http()
        .put('/v1/me/favorites/red-rose-bouquet')
        .set(auth)
        .expect(204);
      await t
        .http()
        .put('/v1/me/favorites/red-rose-bouquet')
        .set(auth)
        .expect(204);
      t.clock.advance({ minutes: 1 });
      await t
        .http()
        .put('/v1/me/favorites/iced-rose-matcha-latte')
        .set(auth)
        .expect(204);

      const list = await get('/v1/me/favorites').set(auth).expect(200);
      expect(slugs(list.body)).toEqual([
        'iced-rose-matcha-latte',
        'red-rose-bouquet',
      ]);
      const detail = await get('/v1/products/red-rose-bouquet').set(auth);
      expect(detail.body.isFavorite).toBe(true);

      await t
        .http()
        .delete('/v1/me/favorites/red-rose-bouquet')
        .set(auth)
        .expect(204);
      const after = await get('/v1/me/favorites').set(auth);
      expect(slugs(after.body)).toEqual(['iced-rose-matcha-latte']);
      await t
        .http()
        .put('/v1/me/favorites/no-such-product')
        .set(auth)
        .expect(404);
    });

    it('shows a saved product that is not available today (screen 32)', async () => {
      const { token } = await t.signInAs('CUSTOMER');
      const auth = { Authorization: `Bearer ${token}` };
      await t
        .http()
        .put('/v1/me/favorites/red-rose-bouquet')
        .set(auth)
        .expect(204);
      t.clock.set('2026-11-12T12:00:00+03:00');
      const list = await get('/v1/me/favorites').set(auth).expect(200);
      expect(list.body[0]).toMatchObject({
        available: false,
        badges: ['unavailable'],
      });
    });
  });
});
