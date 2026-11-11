import type { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import request from 'supertest';
import type { App } from 'supertest/types.js';
import { GoogleIdentityVerifier } from '../../src/adapters/identity/google-identity.js';
import { Mailer } from '../../src/adapters/messaging/mailer.js';
import { OtpSender } from '../../src/adapters/messaging/otp-sender.js';
import { MediaStorage } from '../../src/adapters/storage/media-storage.js';
import { AppModule } from '../../src/app.module.js';
import { configureApp } from '../../src/bootstrap/configure-app.js';
import { Clock, FixedClock } from '../../src/common/clock/clock.js';
import type { Role } from '../../src/generated/prisma/client.js';
import { PrismaService } from '../../src/infra/prisma/prisma.service.js';
import { TokenService } from '../../src/modules/accounts/auth/token.service.js';
import { shopDate } from '../../src/modules/catalog/domain/product-rules.js';
import { SettingsService } from '../../src/modules/settings/settings.service.js';
import { seedCatalog } from '../../prisma/seed-data/catalog.js';
import {
  CapturingMailer,
  CapturingOtpSender,
  FakeGoogleVerifier,
  MemoryMediaStorage,
} from './fakes.js';

/** 15:00 in Damascus, the time used across the SRS acceptance examples. */
export const TEST_NOW = '2026-11-11T15:00:00+03:00';

export interface TestApp {
  app: INestApplication<App>;
  http: () => ReturnType<typeof request>;
  prisma: PrismaService;
  clock: FixedClock;
  otp: CapturingOtpSender;
  mail: CapturingMailer;
  google: FakeGoogleVerifier;
  media: MemoryMediaStorage;
  /** Writes the screens' catalog (prisma/seed-data/catalog.ts) with today's list for the test clock. */
  seedCatalog: () => Promise<void>;
  /** Empties every table except the append-only audit log, and resets the fakes. */
  reset: () => Promise<void>;
  /** Creates a user with this role and returns a bearer token for it. */
  signInAs: (
    role: Role,
    fields?: { name?: string; phone?: string },
  ) => Promise<{ id: string; token: string }>;
  close: () => Promise<void>;
}

const TABLES = [
  'favorite',
  'stock_movement',
  'daily_availability',
  'designer_item',
  'product_option',
  'product_option_group',
  'product_image',
  'product',
  'occasion',
  'category',
  'page',
  'device',
  'password_reset_token',
  'refresh_token',
  'otp_code',
  'app_user',
  'setting',
  'branch',
];

export async function createTestApp(): Promise<TestApp> {
  const clock = new FixedClock(TEST_NOW);
  const otp = new CapturingOtpSender();
  const mail = new CapturingMailer();
  const google = new FakeGoogleVerifier();
  const media = new MemoryMediaStorage();

  const moduleRef = await Test.createTestingModule({ imports: [AppModule] })
    .overrideProvider(Clock)
    .useValue(clock)
    .overrideProvider(OtpSender)
    .useValue(otp)
    .overrideProvider(Mailer)
    .useValue(mail)
    .overrideProvider(GoogleIdentityVerifier)
    .useValue(google)
    .overrideProvider(MediaStorage)
    .useValue(media)
    .compile();

  const app = configureApp(
    moduleRef.createNestApplication(),
  ) as INestApplication<App>;
  await app.init();
  const prisma = app.get(PrismaService);
  const tokens = app.get(TokenService);
  const settings = app.get(SettingsService);
  let phoneCounter = 0;

  return {
    app,
    http: () => request(app.getHttpServer()),
    prisma,
    clock,
    otp,
    mail,
    google,
    media,
    async seedCatalog() {
      await seedCatalog(prisma, shopDate(clock.now()));
    },
    async reset() {
      await prisma.$executeRawUnsafe(
        `TRUNCATE ${TABLES.map((t) => `"${t}"`).join(', ')} RESTART IDENTITY CASCADE`,
      );
      settings.invalidate();
      clock.set(TEST_NOW);
      otp.sent.length = 0;
      mail.sent.length = 0;
      google.enabled = true;
      google.identities.clear();
      media.files.clear();
    },
    async signInAs(role, fields = {}) {
      phoneCounter += 1;
      const user = await prisma.user.create({
        data: {
          role,
          name: fields.name ?? `${role} user`,
          phone:
            fields.phone ?? `+96393300${String(phoneCounter).padStart(4, '0')}`,
          termsAcceptedAt: clock.now(),
        },
      });
      const issued = await tokens.issue(user);
      return { id: user.id, token: issued.accessToken };
    },
    async close() {
      await app.close();
    },
  };
}
