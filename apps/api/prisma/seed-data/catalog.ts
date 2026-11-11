// Catalog seed for development, staging demos and the e2e tests (plan 5.2).
// Names and prices mirror the HTML screens (06-14, 32, 34) and the README example:
// red rose 90, pink rose 90, gypsophila 60 (6 stems left, FR-DSG-03), eucalyptus 40,
// burgundy satin wrap 120, pink satin ribbon 36, small teddy 960.
// All amounts are SYP minor units (1/100 pound, ADR 0011): 2,400 SYP = 240_000.
// Images are left empty until the shop's photos arrive (R-02); the app draws a placeholder.
import type {
  DesignerItemType,
  PrismaClient,
  ProductKind,
} from '../../src/generated/prisma/client.js';
import {
  buildSearchText,
  displayPrice,
} from '../../src/modules/catalog/domain/product-rules.js';
import {
  COLORS,
  FLOWER_TYPES,
} from '../../src/modules/catalog/domain/vocabulary.js';

const SYP = (pounds: number) => pounds * 100;

interface OptionSeed {
  key: string;
  ar: string;
  en: string;
  detailAr?: string;
  detailEn?: string;
  swatch?: string;
  price?: number;
  isDefault?: boolean;
}

interface GroupSeed {
  key: string;
  ar: string;
  en: string;
  multiple?: boolean;
  optional?: boolean;
  options: OptionSeed[];
}

interface ProductSeed {
  slug: string;
  category: string;
  kind: ProductKind;
  ar: string;
  en: string;
  subtitleAr?: string;
  subtitleEn?: string;
  descriptionAr?: string;
  descriptionEn?: string;
  price: number;
  leadTimeHours?: number;
  allergens?: string[];
  occasions?: string[];
  colors?: string[];
  flowerTypes?: string[];
  stock?: number;
  onTodayList?: boolean;
  dailyOnly?: boolean;
  limited?: boolean;
  seasonal?: boolean;
  bestSeller?: boolean;
  popularity: number;
  pairings?: string[];
  designerTemplate?: object;
  groups?: GroupSeed[];
}

export const CATEGORIES = [
  {
    slug: 'flowers',
    ar: 'ورد وباقات',
    en: 'Flowers & bouquets',
    icon: 'flower',
  },
  { slug: 'cakes', ar: 'كيك وحلويات', en: 'Cakes & sweets', icon: 'cake' },
  { slug: 'coffee', ar: 'قهوة وماتشا', en: 'Coffee & matcha', icon: 'coffee' },
  { slug: 'gifts', ar: 'هدايا', en: 'Gifts', icon: 'gift' },
];

export const OCCASIONS = [
  {
    slug: 'birthday',
    ar: 'عيد ميلاد',
    en: 'Birthday',
    titleAr: 'هدايا عيد الميلاد',
    titleEn: 'Birthday gifts',
  },
  {
    slug: 'love',
    ar: 'حب',
    en: 'Love',
    titleAr: 'هدايا للحب',
    titleEn: 'Gifts of love',
  },
  {
    slug: 'graduation',
    ar: 'تخرج',
    en: 'Graduation',
    titleAr: 'هدايا التخرج',
    titleEn: 'Graduation gifts',
  },
  {
    slug: 'newborn',
    ar: 'مولود',
    en: 'Newborn',
    titleAr: 'هدايا المولود',
    titleEn: 'Newborn gifts',
  },
  {
    slug: 'thanks',
    ar: 'شكر',
    en: 'Thank you',
    titleAr: 'هدايا الشكر',
    titleEn: 'Thank-you gifts',
  },
  {
    slug: 'apology',
    ar: 'اعتذار',
    en: 'Apology',
    titleAr: 'هدايا الاعتذار',
    titleEn: 'Apology gifts',
  },
  {
    slug: 'engagement',
    ar: 'خطوبة',
    en: 'Engagement',
    titleAr: 'هدايا الخطوبة',
    titleEn: 'Engagement gifts',
  },
];

const bouquetSizes = (
  classic: number,
  medium: number,
  luxury: number,
): GroupSeed => ({
  key: 'size',
  ar: 'الحجم',
  en: 'Size',
  options: [
    {
      key: 'classic',
      ar: 'كلاسيك',
      en: 'Classic',
      detailAr: '15 وردة',
      detailEn: '15 roses',
      price: classic,
    },
    {
      key: 'medium',
      ar: 'متوسطة',
      en: 'Medium',
      detailAr: '25 وردة',
      detailEn: '25 roses',
      price: medium,
      isDefault: true,
    },
    {
      key: 'luxury',
      ar: 'فاخرة',
      en: 'Luxury',
      detailAr: '40 وردة',
      detailEn: '40 roses',
      price: luxury,
    },
  ],
});

const wrapColors: GroupSeed = {
  key: 'wrap',
  ar: 'لون التغليف',
  en: 'Wrap color',
  options: [
    {
      key: 'silk-burgundy',
      ar: 'حريري بوردو',
      en: 'Burgundy silk',
      detailAr: 'ورق حريري مع شريط ساتان',
      detailEn: 'Silk paper with a satin ribbon',
      swatch: '#7A1F3D',
      isDefault: true,
    },
    {
      key: 'kraft',
      ar: 'كرافت طبيعي',
      en: 'Natural kraft',
      detailAr: 'ورق كرافت بيج',
      detailEn: 'Beige kraft paper',
      swatch: '#C8A97E',
    },
    {
      key: 'light-pink',
      ar: 'وردي فاتح',
      en: 'Light pink',
      detailAr: 'ورق شفاف وردي',
      detailEn: 'Sheer pink paper',
      swatch: '#F4CCD6',
    },
  ],
};

const giftCard: GroupSeed = {
  key: 'gift-card',
  ar: 'أضف بطاقة إهداء',
  en: 'Add a gift card',
  multiple: true,
  optional: true,
  options: [
    {
      key: 'gift-card',
      ar: 'بطاقة إهداء',
      en: 'Gift card',
      detailAr: 'تكتب رسالتك في السلة',
      detailEn: 'Write your message in the cart',
      price: SYP(120),
    },
  ],
};

const milk: GroupSeed = {
  key: 'milk',
  ar: 'نوع الحليب',
  en: 'Milk',
  options: [
    { key: 'whole', ar: 'حليب كامل الدسم', en: 'Whole milk', isDefault: true },
    { key: 'oat', ar: 'حليب الشوفان', en: 'Oat milk', price: SYP(60) },
    { key: 'almond', ar: 'حليب اللوز', en: 'Almond milk', price: SYP(60) },
  ],
};

const sweetness: GroupSeed = {
  key: 'sweetness',
  ar: 'الحلاوة',
  en: 'Sweetness',
  options: [
    { key: 'none', ar: 'بدون سكر', en: 'No sugar' },
    { key: 'regular', ar: 'عادي', en: 'Regular', isDefault: true },
    { key: 'light', ar: 'خفيف', en: 'Light' },
  ],
};

const ice: GroupSeed = {
  key: 'ice',
  ar: 'الثلج',
  en: 'Ice',
  options: [
    { key: 'regular', ar: 'عادي', en: 'Regular', isDefault: true },
    { key: 'light', ar: 'خفيف', en: 'Light' },
  ],
};

const cakeSizes: GroupSeed = {
  key: 'size',
  ar: 'الحجم',
  en: 'Size',
  options: [
    {
      key: '18cm',
      ar: '18 سم',
      en: '18 cm',
      detailAr: '6 - 8 أشخاص',
      detailEn: '6 - 8 people',
      isDefault: true,
    },
    {
      key: '22cm',
      ar: '22 سم',
      en: '22 cm',
      detailAr: '10 - 12 شخصاً',
      detailEn: '10 - 12 people',
      price: SYP(720),
    },
  ],
};

export const PRODUCTS: ProductSeed[] = [
  {
    slug: 'red-rose-bouquet',
    category: 'flowers',
    kind: 'BOUQUET',
    ar: 'باقة الجوري الأحمر',
    en: 'Red rose bouquet',
    subtitleAr: '25 وردة · تغليف حريري',
    subtitleEn: '25 roses · silk wrap',
    descriptionAr:
      'ورد جوري أحمر مع أوراق خضراء، مغلّفة بورق حريري ومربوطة بشريط ساتان.',
    descriptionEn:
      'Red roses with green leaves, wrapped in silk paper and tied with a satin ribbon.',
    price: SYP(1800),
    occasions: ['love', 'birthday', 'engagement'],
    colors: ['red'],
    flowerTypes: ['rose'],
    stock: 8,
    onTodayList: true,
    dailyOnly: true,
    bestSeller: true,
    popularity: 100,
    pairings: ['macarons-6', 'gift-card'],
    designerTemplate: {
      size: 'medium',
      flowers: [{ item: 'red-rose', qty: 25 }],
      greens: [],
      wrap: 'satin-burgundy',
      ribbon: 'satin-pink',
      extras: [],
    },
    groups: [bouquetSizes(0, SYP(600), SYP(1560)), wrapColors, giftCard],
  },
  {
    slug: 'white-hydrangea-bouquet',
    category: 'flowers',
    kind: 'BOUQUET',
    ar: 'باقة الهيدرانجيا البيضاء',
    en: 'White hydrangea bouquet',
    subtitleAr: 'هيدرانجيا وبيوني',
    subtitleEn: 'Hydrangea and peony',
    price: SYP(2160),
    occasions: ['newborn', 'thanks'],
    colors: ['white'],
    flowerTypes: ['hydrangea', 'peony'],
    stock: 4,
    onTodayList: true,
    popularity: 70,
    pairings: ['gift-card', 'glass-vase'],
    groups: [wrapColors, giftCard],
  },
  {
    slug: 'spring-peony-bouquet',
    category: 'flowers',
    kind: 'BOUQUET',
    ar: 'باقة البيوني الربيعية',
    en: 'Spring peony bouquet',
    subtitleAr: 'ورد موسمي',
    subtitleEn: 'Seasonal flowers',
    price: SYP(2760),
    occasions: ['love', 'engagement'],
    colors: ['pink', 'pastel'],
    flowerTypes: ['peony'],
    stock: 3,
    onTodayList: true,
    limited: true,
    seasonal: true,
    popularity: 80,
    pairings: ['macarons-6', 'gift-card'],
    groups: [wrapColors, giftCard],
  },
  {
    slug: 'cascading-spring-bouquet',
    category: 'flowers',
    kind: 'BOUQUET',
    ar: 'باقة الربيع المنسدلة',
    en: 'Cascading spring bouquet',
    subtitleAr: 'توليب وليزيانثوس',
    subtitleEn: 'Tulips and lisianthus',
    price: SYP(1920),
    occasions: ['graduation', 'thanks'],
    colors: ['pastel', 'yellow'],
    flowerTypes: ['tulip', 'lisianthus'],
    onTodayList: true,
    popularity: 50,
    pairings: ['gift-card'],
    groups: [wrapColors, giftCard],
  },
  {
    slug: 'luxury-red-rose-bouquet',
    category: 'flowers',
    kind: 'BOUQUET',
    ar: 'باقة الجوري الفاخرة',
    en: 'Luxury red rose bouquet',
    subtitleAr: '40 وردة جوري',
    subtitleEn: '40 red roses',
    price: SYP(3360),
    occasions: ['love', 'engagement'],
    colors: ['red'],
    flowerTypes: ['rose'],
    popularity: 60,
    pairings: ['chocolate-box-16', 'gift-card'],
    groups: [wrapColors, giftCard],
  },
  {
    slug: 'mini-rose-bouquet',
    category: 'flowers',
    kind: 'BOUQUET',
    ar: 'باقة جوري صغيرة',
    en: 'Mini rose bouquet',
    subtitleAr: 'إضافة للهدايا',
    subtitleEn: 'A small add-on to a gift',
    price: SYP(960),
    occasions: ['love', 'thanks', 'apology'],
    colors: ['red'],
    flowerTypes: ['rose'],
    popularity: 40,
    groups: [wrapColors],
  },
  {
    slug: 'white-tulip-bouquet',
    category: 'flowers',
    kind: 'BOUQUET',
    ar: 'باقة التوليب البيضاء',
    en: 'White tulip bouquet',
    subtitleAr: 'توليب أبيض',
    subtitleEn: 'White tulips',
    price: SYP(2040),
    occasions: ['apology', 'newborn'],
    colors: ['white'],
    flowerTypes: ['tulip'],
    popularity: 30,
    groups: [wrapColors, giftCard],
  },
  {
    slug: 'pastel-lisianthus-bouquet',
    category: 'flowers',
    kind: 'BOUQUET',
    ar: 'باقة الليزيانثوس الباستيل',
    en: 'Pastel lisianthus bouquet',
    subtitleAr: 'ليزيانثوس بألوان هادئة',
    subtitleEn: 'Soft-colored lisianthus',
    price: SYP(1680),
    occasions: ['graduation', 'thanks', 'birthday'],
    colors: ['pastel'],
    flowerTypes: ['lisianthus'],
    popularity: 35,
    groups: [wrapColors, giftCard],
  },
  {
    slug: 'rose-pistachio-cake',
    category: 'cakes',
    kind: 'CAKE',
    ar: 'كيكة الورد والفستق',
    en: 'Rose and pistachio cake',
    subtitleAr: 'يُطلب قبل 24 ساعة',
    subtitleEn: 'Order 24 hours ahead',
    descriptionAr:
      'كيكة إسفنجية بكريمة الورد وحشوة الفستق الحلبي، تُحضّر في مطبخ المحل.',
    descriptionEn:
      'Sponge cake with rose cream and Aleppo pistachio filling, made in the shop kitchen.',
    price: SYP(2280),
    leadTimeHours: 24,
    allergens: ['nuts', 'milk', 'eggs', 'gluten'],
    occasions: ['birthday', 'engagement'],
    popularity: 90,
    pairings: ['birthday-candle', 'gift-card'],
    groups: [cakeSizes],
  },
  {
    slug: 'berry-tart',
    category: 'cakes',
    kind: 'SWEET',
    ar: 'تارت التوت',
    en: 'Berry tart',
    subtitleAr: 'قطعة فردية',
    subtitleEn: 'Single piece',
    price: SYP(480),
    allergens: ['milk', 'eggs', 'gluten'],
    popularity: 45,
  },
  {
    slug: 'macarons-6',
    category: 'cakes',
    kind: 'SWEET',
    ar: 'ماكرون 6 قطع',
    en: 'Macarons, 6 pieces',
    subtitleAr: 'حلويات',
    subtitleEn: 'Sweets',
    price: SYP(600),
    allergens: ['nuts', 'eggs'],
    occasions: ['birthday', 'thanks'],
    popularity: 55,
  },
  {
    slug: 'pistachio-eclair',
    category: 'cakes',
    kind: 'SWEET',
    ar: 'إكلير الفستق',
    en: 'Pistachio éclair',
    subtitleAr: 'حلويات',
    subtitleEn: 'Sweets',
    price: SYP(420),
    allergens: ['nuts', 'milk', 'eggs', 'gluten'],
    popularity: 25,
  },
  {
    slug: 'almond-croissant',
    category: 'cakes',
    kind: 'SWEET',
    ar: 'كرواسون اللوز',
    en: 'Almond croissant',
    subtitleAr: 'مخبوزات',
    subtitleEn: 'Pastries',
    price: SYP(360),
    allergens: ['nuts', 'milk', 'gluten'],
    popularity: 20,
  },
  {
    slug: 'iced-rose-matcha-latte',
    category: 'coffee',
    kind: 'DRINK',
    ar: 'لاتيه الورد بالماتشا المثلج',
    en: 'Iced rose matcha latte',
    subtitleAr: 'قهوة وماتشا',
    subtitleEn: 'Coffee & matcha',
    price: SYP(540),
    allergens: ['milk'],
    popularity: 65,
    pairings: ['almond-croissant', 'pistachio-eclair'],
    groups: [milk, sweetness, ice],
  },
  {
    slug: 'spanish-latte',
    category: 'coffee',
    kind: 'DRINK',
    ar: 'سبانش لاتيه',
    en: 'Spanish latte',
    subtitleAr: 'قهوة',
    subtitleEn: 'Coffee',
    price: SYP(450),
    allergens: ['milk'],
    popularity: 15,
    pairings: ['almond-croissant'],
    groups: [milk, sweetness, ice],
  },
  {
    slug: 'chocolate-box-16',
    category: 'gifts',
    kind: 'GIFT',
    ar: 'بوكس شوكولا 16 قطعة',
    en: 'Chocolate box, 16 pieces',
    subtitleAr: 'هدايا',
    subtitleEn: 'Gifts',
    price: SYP(1920),
    allergens: ['nuts', 'milk'],
    occasions: ['birthday', 'love', 'thanks'],
    popularity: 85,
  },
  {
    slug: 'glass-vase',
    category: 'gifts',
    kind: 'GIFT',
    ar: 'فازة زجاجية',
    en: 'Glass vase',
    subtitleAr: 'هدايا',
    subtitleEn: 'Gifts',
    price: SYP(2160),
    stock: 12,
    popularity: 75,
  },
  {
    slug: 'gift-card',
    category: 'gifts',
    kind: 'GIFT',
    ar: 'بطاقة إهداء',
    en: 'Gift card',
    subtitleAr: 'برسالتك',
    subtitleEn: 'With your message',
    price: SYP(120),
    popularity: 10,
  },
  {
    slug: 'birthday-candle',
    category: 'gifts',
    kind: 'GIFT',
    ar: 'شمعة عيد ميلاد',
    en: 'Birthday candle',
    subtitleAr: 'إضافة',
    subtitleEn: 'Add-on',
    price: SYP(240),
    occasions: ['birthday'],
    popularity: 12,
  },
  {
    slug: 'small-teddy',
    category: 'gifts',
    kind: 'GIFT',
    ar: 'دبدوب صغير',
    en: 'Small teddy bear',
    subtitleAr: 'إضافة للهدايا',
    subtitleEn: 'Gift add-on',
    price: SYP(960),
    stock: 10,
    occasions: ['love', 'birthday', 'newborn'],
    popularity: 22,
  },
];

interface DesignerItemSeed {
  slug: string;
  type: DesignerItemType;
  ar: string;
  en: string;
  price: number;
  swatch?: string;
  colors?: string[];
  stock?: number;
  /** Stems on today's list (DailyAvailability). Omitted: not available today. */
  today?: number;
  limited?: boolean;
}

export const DESIGNER_ITEMS: DesignerItemSeed[] = [
  {
    slug: 'red-rose',
    type: 'FLOWER',
    ar: 'جوري أحمر',
    en: 'Red rose',
    price: SYP(90),
    swatch: '#B3263E',
    colors: ['red'],
    today: 120,
  },
  {
    slug: 'pink-rose',
    type: 'FLOWER',
    ar: 'جوري وردي',
    en: 'Pink rose',
    price: SYP(90),
    swatch: '#E8A3B5',
    colors: ['pink'],
    today: 60,
  },
  {
    slug: 'white-rose',
    type: 'FLOWER',
    ar: 'جوري أبيض',
    en: 'White rose',
    price: SYP(90),
    swatch: '#F7F2EE',
    colors: ['white'],
    today: 40,
  },
  {
    slug: 'peony',
    type: 'FLOWER',
    ar: 'بيوني',
    en: 'Peony',
    price: SYP(150),
    swatch: '#F0B8C8',
    colors: ['pink', 'pastel'],
    today: 24,
    limited: true,
  },
  {
    slug: 'lisianthus',
    type: 'FLOWER',
    ar: 'ليزيانثوس',
    en: 'Lisianthus',
    price: SYP(120),
    swatch: '#D9C6E6',
    colors: ['pastel'],
    today: 30,
  },
  {
    slug: 'white-tulip',
    type: 'FLOWER',
    ar: 'توليب أبيض',
    en: 'White tulip',
    price: SYP(110),
    swatch: '#FAF7F2',
    colors: ['white'],
  },
  {
    slug: 'gypsophila',
    type: 'GREEN',
    ar: 'جيبسوفيلا',
    en: 'Gypsophila',
    price: SYP(60),
    swatch: '#FFFFFF',
    today: 6,
  },
  {
    slug: 'eucalyptus',
    type: 'GREEN',
    ar: 'أوكاليبتوس',
    en: 'Eucalyptus',
    price: SYP(40),
    swatch: '#8FA98A',
    today: 40,
  },
  {
    slug: 'ruscus',
    type: 'GREEN',
    ar: 'روسكوس',
    en: 'Ruscus',
    price: SYP(30),
    swatch: '#4F7A4A',
    today: 30,
  },
  {
    slug: 'satin-burgundy',
    type: 'WRAP',
    ar: 'تغليف ساتان بوردو',
    en: 'Burgundy satin wrap',
    price: SYP(120),
    swatch: '#7A1F3D',
    stock: 50,
  },
  {
    slug: 'kraft',
    type: 'WRAP',
    ar: 'كرافت طبيعي',
    en: 'Natural kraft',
    price: SYP(100),
    swatch: '#C8A97E',
    stock: 50,
  },
  {
    slug: 'satin-pink',
    type: 'RIBBON',
    ar: 'شريط ساتان وردي',
    en: 'Pink satin ribbon',
    price: SYP(36),
    swatch: '#E8A3B5',
    stock: 100,
  },
  {
    slug: 'small-teddy',
    type: 'EXTRA',
    ar: 'دبدوب صغير',
    en: 'Small teddy bear',
    price: SYP(960),
    stock: 10,
  },
];

export const BRANCH = {
  code: 'abu-rummaneh',
  nameAr: 'Belle Biens · أبو رمانة',
  nameEn: 'Belle Biens · Abu Rummaneh',
  addressAr: 'زقاق الكرامة، أبو رمانة، دمشق',
  addressEn: 'Al-Karama Lane, Abu Rummaneh, Damascus',
  // Phone and WhatsApp numbers come from the shop (screen 34 shows placeholders).
  phone: null,
  whatsapp: null,
  instagram: 'bellebiens',
  latitude: 33.5155,
  longitude: 36.284,
  partners: ['Movo', 'BeeOrder'],
};

// Drafts until the shop writes its own text (FR-CON-04).
export const PAGES = [
  {
    slug: 'delivery',
    titleAr: 'سياسة التوصيل',
    titleEn: 'Delivery policy',
    bodyAr: '[يكتب المحل سياسة التوصيل: المناطق والرسوم والمواعيد.]',
    bodyEn: '[The shop writes its delivery policy: areas, fees and times.]',
  },
  {
    slug: 'cancellation',
    titleAr: 'الإلغاء والاسترجاع',
    titleEn: 'Cancellation and refunds',
    bodyAr: '[يكتب المحل شروط الإلغاء والاسترجاع.]',
    bodyEn: '[The shop writes its cancellation and refund terms.]',
  },
  {
    slug: 'privacy',
    titleAr: 'الخصوصية',
    titleEn: 'Privacy',
    bodyAr: '[سياسة الخصوصية.]',
    bodyEn: '[Privacy policy.]',
  },
  {
    slug: 'terms',
    titleAr: 'شروط الاستخدام',
    titleEn: 'Terms of use',
    bodyAr: '[شروط الاستخدام.]',
    bodyEn: '[Terms of use.]',
  },
];

/**
 * Writes the catalog. Safe to run again: rows are matched by slug and their options
 * rebuilt. `today` is the shop date that "today's list" items get (FR-DLY-02).
 */
export async function seedCatalog(
  prisma: PrismaClient,
  today: Date,
): Promise<void> {
  const branch = await prisma.branch.upsert({
    where: { code: BRANCH.code },
    update: BRANCH,
    create: BRANCH,
  });

  const categoryIds = new Map<string, string>();
  for (const [i, c] of CATEGORIES.entries()) {
    const data = { nameAr: c.ar, nameEn: c.en, icon: c.icon, sortOrder: i };
    const row = await prisma.category.upsert({
      where: { slug: c.slug },
      update: data,
      create: { slug: c.slug, ...data },
    });
    categoryIds.set(c.slug, row.id);
  }

  for (const [i, o] of OCCASIONS.entries()) {
    const data = {
      nameAr: o.ar,
      nameEn: o.en,
      titleAr: o.titleAr,
      titleEn: o.titleEn,
      sortOrder: i,
    };
    await prisma.occasion.upsert({
      where: { slug: o.slug },
      update: data,
      create: { slug: o.slug, ...data },
    });
  }

  const occasionNames = new Map(OCCASIONS.map((o) => [o.slug, [o.ar, o.en]]));
  const colorNames = new Map(COLORS.map((c) => [c.slug, [c.ar, c.en]]));
  const flowerNames = new Map(FLOWER_TYPES.map((f) => [f.slug, [f.ar, f.en]]));
  const categoryNames = new Map(CATEGORIES.map((c) => [c.slug, [c.ar, c.en]]));

  for (const p of PRODUCTS) {
    const groups = (p.groups ?? []).map((g) => ({
      key: g.key,
      selection: g.multiple ? ('MULTIPLE' as const) : ('SINGLE' as const),
      required: !g.optional,
      options: g.options.map((o) => ({
        priceChangeMinor: o.price ?? 0,
        isDefault: o.isDefault ?? false,
      })),
    }));
    const derived = displayPrice(p.price, groups);
    const data = {
      categoryId: categoryIds.get(p.category)!,
      kind: p.kind,
      nameAr: p.ar,
      nameEn: p.en,
      subtitleAr: p.subtitleAr ?? '',
      subtitleEn: p.subtitleEn ?? '',
      descriptionAr: p.descriptionAr ?? '',
      descriptionEn: p.descriptionEn ?? '',
      basePriceMinor: p.price,
      ...derived,
      leadTimeHours: p.leadTimeHours ?? 0,
      allergens: p.allergens ?? [],
      occasions: p.occasions ?? [],
      colors: p.colors ?? [],
      flowerTypes: p.flowerTypes ?? [],
      stockQuantity: p.stock ?? null,
      dailyDate: p.onTodayList ? today : null,
      dailyOnly: p.dailyOnly ?? false,
      limited: p.limited ?? false,
      seasonal: p.seasonal ?? false,
      bestSeller: p.bestSeller ?? false,
      popularity: p.popularity,
      pairings: p.pairings ?? [],
      designerTemplate: p.designerTemplate,
      searchText: buildSearchText([
        p.ar,
        p.en,
        p.subtitleAr,
        p.subtitleEn,
        ...(categoryNames.get(p.category) ?? []),
        ...(p.occasions ?? []).flatMap((s) => occasionNames.get(s) ?? []),
        ...(p.colors ?? []).flatMap((s) => colorNames.get(s) ?? []),
        ...(p.flowerTypes ?? []).flatMap((s) => flowerNames.get(s) ?? []),
      ]),
      branchId: branch.id,
    };
    const product = await prisma.product.upsert({
      where: { slug: p.slug },
      update: data,
      create: { slug: p.slug, ...data },
    });
    await prisma.productOptionGroup.deleteMany({
      where: { productId: product.id },
    });
    for (const [gi, g] of (p.groups ?? []).entries()) {
      await prisma.productOptionGroup.create({
        data: {
          productId: product.id,
          key: g.key,
          nameAr: g.ar,
          nameEn: g.en,
          selection: g.multiple ? 'MULTIPLE' : 'SINGLE',
          required: !g.optional,
          sortOrder: gi,
          options: {
            create: g.options.map((o, oi) => ({
              key: o.key,
              nameAr: o.ar,
              nameEn: o.en,
              detailAr: o.detailAr ?? '',
              detailEn: o.detailEn ?? '',
              swatch: o.swatch,
              priceChangeMinor: o.price ?? 0,
              isDefault: o.isDefault ?? false,
              sortOrder: oi,
            })),
          },
        },
      });
    }
  }

  for (const [i, d] of DESIGNER_ITEMS.entries()) {
    const data = {
      type: d.type,
      nameAr: d.ar,
      nameEn: d.en,
      unitPriceMinor: d.price,
      swatch: d.swatch,
      colorTags: d.colors ?? [],
      stockQuantity: d.stock ?? null,
      sortOrder: i,
    };
    const item = await prisma.designerItem.upsert({
      where: { slug: d.slug },
      update: data,
      create: { slug: d.slug, ...data },
    });
    if (d.today !== undefined) {
      await prisma.dailyAvailability.upsert({
        where: {
          designerItemId_date: { designerItemId: item.id, date: today },
        },
        update: { quantity: d.today, limited: d.limited ?? false },
        create: {
          designerItemId: item.id,
          date: today,
          quantity: d.today,
          limited: d.limited ?? false,
        },
      });
    }
  }

  for (const page of PAGES) {
    await prisma.page.upsert({
      where: { slug: page.slug },
      update: page,
      create: page,
    });
  }
}
