// Development seed. Grows each sprint to mirror the examples in the HTML screens
// (plan section 5.2): red rose 90 SYP x 120 stems, Abu Rummaneh zone 150 SYP, rate 120, etc.
import 'dotenv/config';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '../src/generated/prisma/client.js';
import { shopDate } from '../src/modules/catalog/domain/product-rules.js';
import { seedCatalog } from './seed-data/catalog.js';
import { seedDelivery } from './seed-data/delivery.js';

const prisma = new PrismaClient({
  adapter: new PrismaPg({ connectionString: process.env['DATABASE_URL'] }),
});

async function main(): Promise<void> {
  // Today's list gets today's date, so re-run the seed on a new day for fresh demo data.
  await seedCatalog(prisma, shopDate(new Date()));
  await seedDelivery(prisma);

  const settings: Record<string, unknown> = {
    // OI-12: base currency and rate owner still open; README examples use 120 SYP per USD.
    'currency.usdRate': '120',
    'pricing.assemblyFeeMinor': 0,
    'pricing.rounding': { mode: 'none' },
    'shop.mode': 'open',
    'shop.workingHours': { open: '10:00', close: '24:00' },
    'payments.enabled': { cash: true, shamcash: true, stripe: false },
    'payments.unpaidTimeoutMinutes': 120,
  };
  for (const [key, value] of Object.entries(settings)) {
    await prisma.setting.upsert({
      where: { key },
      update: {},
      create: { key, value: value as object },
    });
  }
}

main()
  .then(() => prisma.$disconnect())
  .catch(async (error: unknown) => {
    console.error(error);
    await prisma.$disconnect();
    process.exit(1);
  });
