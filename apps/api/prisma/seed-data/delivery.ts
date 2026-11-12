import type {
  Prisma,
  PrismaClient,
} from '../../src/generated/prisma/client.js';

// Placeholder Damascus zones until the shop sends its list (OI-13). Rough boxes
// around each area as [longitude, latitude]; fees in SYP minor units. The
// screens use Abu Rummaneh at 150 ل.س (README cart: 7,116 + 150 = 7,266).

const box = (west: number, south: number, east: number, north: number) => [
  [west, south],
  [east, south],
  [east, north],
  [west, north],
];

export const DELIVERY_ZONES = [
  {
    slug: 'abu-rummaneh',
    nameAr: 'أبو رمانة',
    nameEn: 'Abu Rummaneh',
    polygon: box(36.277, 33.513, 36.29, 33.523),
    feeMinor: 15_000,
    etaAr: '30 – 45 دقيقة',
    etaEn: '30–45 minutes',
    sortOrder: 1,
  },
  {
    slug: 'malki',
    nameAr: 'المالكي',
    nameEn: 'Malki',
    polygon: box(36.27, 33.523, 36.285, 33.532),
    feeMinor: 15_000,
    etaAr: '30 – 45 دقيقة',
    etaEn: '30–45 minutes',
    sortOrder: 2,
  },
  {
    slug: 'shaalan',
    nameAr: 'الشعلان',
    nameEn: 'Shaalan',
    polygon: box(36.29, 33.513, 36.3, 33.52),
    feeMinor: 15_000,
    etaAr: '30 – 45 دقيقة',
    etaEn: '30–45 minutes',
    sortOrder: 3,
  },
  {
    slug: 'mezzeh',
    nameAr: 'المزة',
    nameEn: 'Mezzeh',
    polygon: box(36.23, 33.495, 36.27, 33.515),
    feeMinor: 25_000,
    etaAr: '45 – 60 دقيقة',
    etaEn: '45–60 minutes',
    sortOrder: 4,
  },
  {
    slug: 'old-city',
    nameAr: 'دمشق القديمة',
    nameEn: 'Old City',
    polygon: box(36.3, 33.505, 36.32, 33.515),
    feeMinor: 25_000,
    etaAr: '45 – 60 دقيقة',
    etaEn: '45–60 minutes',
    sortOrder: 5,
  },
];

export async function seedDelivery(prisma: PrismaClient): Promise<void> {
  for (const zone of DELIVERY_ZONES) {
    const data = {
      ...zone,
      polygon: zone.polygon as Prisma.InputJsonValue,
    };
    await prisma.deliveryZone.upsert({
      where: { slug: zone.slug },
      update: data,
      create: data,
    });
  }
}
