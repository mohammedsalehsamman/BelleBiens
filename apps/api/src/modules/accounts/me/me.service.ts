import { Injectable } from '@nestjs/common';
import { Clock } from '../../../common/clock/clock.js';
import { AppError } from '../../../common/errors/app-error.js';
import { Prisma } from '../../../generated/prisma/client.js';
import { PrismaService } from '../../../infra/prisma/prisma.service.js';
import {
  MeDto,
  type RegisterDeviceDto,
  type UpdateMeDto,
} from './dto/me.dto.js';

@Injectable()
export class MeService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
  ) {}

  async get(userId: string): Promise<MeDto> {
    return MeDto.from(
      await this.prisma.user.findUniqueOrThrow({ where: { id: userId } }),
    );
  }

  /** FR-ACC-03. Changing the phone needs a code and comes with the profile screen (S7). */
  async update(userId: string, dto: UpdateMeDto): Promise<MeDto> {
    const email = dto.email?.toLowerCase();
    if (email) {
      const owner = await this.prisma.user.findUnique({
        where: { email },
        select: { id: true },
      });
      if (owner && owner.id !== userId) throw new AppError('EMAIL_TAKEN');
    }
    const current = await this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
      select: { termsAcceptedAt: true },
    });
    const user = await this.prisma.user.update({
      where: { id: userId },
      data: {
        name: dto.name?.trim(),
        email,
        language: dto.language,
        numerals: dto.numerals,
        marketingOptIn: dto.marketingOptIn,
        notifyOccasions: dto.notifyOccasions,
        notifyWhatsapp: dto.notifyWhatsapp,
        homeArea:
          dto.homeArea === undefined ? undefined : dto.homeArea.trim() || null,
        termsAcceptedAt:
          dto.acceptTerms && !current.termsAcceptedAt
            ? this.clock.now()
            : undefined,
      },
    });
    return MeDto.from(user);
  }

  /** Registers or moves a push token to this user (or to no user for guests). */
  async registerDevice(
    userId: string | undefined,
    dto: RegisterDeviceDto,
  ): Promise<void> {
    const now = this.clock.now();
    await this.prisma.device.upsert({
      where: { pushToken: dto.pushToken },
      create: {
        userId,
        platform: dto.platform,
        pushToken: dto.pushToken,
        appVersion: dto.appVersion,
        locale: dto.locale ?? 'ar',
        lastSeenAt: now,
        createdAt: now,
      },
      update: {
        userId: userId ?? null,
        platform: dto.platform,
        appVersion: dto.appVersion,
        locale: dto.locale,
        lastSeenAt: now,
      },
    });
  }

  /** Called on sign-out so the phone stops receiving this account's notifications. */
  async removeDevice(userId: string, pushToken: string): Promise<void> {
    await this.prisma.device.updateMany({
      where: { pushToken, userId },
      data: { userId: null },
    });
  }

  // ---------- FR-ACC-08: export and deletion ----------

  /** Everything the shop keeps about the customer, as one JSON document. */
  async exportData(userId: string): Promise<Record<string, unknown>> {
    const user = await this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
      include: {
        addresses: true,
        occasions: true,
        designs: true,
        favorites: { include: { product: { select: { slug: true } } } },
        devices: {
          select: { platform: true, appVersion: true, lastSeenAt: true },
        },
        orders: {
          include: { lines: true, history: true, payments: true },
          orderBy: { createdAt: 'asc' },
        },
      },
    });
    const notifications = await this.prisma.notification.findMany({
      where: { userId },
      select: {
        channel: true,
        template: true,
        body: true,
        status: true,
        createdAt: true,
        sentAt: true,
      },
      orderBy: { createdAt: 'asc' },
    });
    return {
      exportedAt: this.clock.now(),
      profile: Object.assign(MeDto.from(user), {
        phoneVerifiedAt: user.phoneVerifiedAt,
        termsAcceptedAt: user.termsAcceptedAt,
      }),
      addresses: user.addresses,
      occasions: user.occasions,
      designs: user.designs,
      favorites: user.favorites.map((f) => f.product.slug),
      devices: user.devices,
      orders: user.orders,
      notifications,
    };
  }

  /**
   * The customer asks to delete the account: signed out everywhere now,
   * erased 30 days later unless they sign in again (FR-ACC-08).
   */
  async requestDeletion(userId: string): Promise<void> {
    const now = this.clock.now();
    await this.prisma.$transaction([
      this.prisma.user.update({
        where: { id: userId },
        data: {
          status: 'DELETION_REQUESTED',
          deletionRequestedAt: now,
          marketingOptIn: false,
        },
      }),
      this.prisma.refreshToken.updateMany({
        where: { userId, revokedAt: null },
        data: { revokedAt: now },
      }),
      this.prisma.device.updateMany({
        where: { userId },
        data: { userId: null },
      }),
    ]);
  }

  static readonly ERASE_AFTER_DAYS = 30;

  /**
   * Erases accounts whose 30 days have passed. Finished orders keep their
   * lines and totals for the shop's books, without the person's details; an
   * account with an order still open waits for the next run.
   */
  async eraseDeleted(): Promise<number> {
    const cutoff = new Date(
      this.clock.now().getTime() - MeService.ERASE_AFTER_DAYS * 86_400_000,
    );
    const due = await this.prisma.user.findMany({
      where: {
        status: 'DELETION_REQUESTED',
        deletionRequestedAt: { lte: cutoff },
      },
      select: { id: true, phone: true },
    });
    let erased = 0;
    for (const user of due) {
      const open = await this.prisma.order.count({
        where: {
          userId: user.id,
          status: { notIn: ['DELIVERED', 'PICKED_UP', 'CANCELLED'] },
        },
      });
      if (open > 0) continue;
      await this.prisma.$transaction([
        this.prisma.order.updateMany({
          where: { userId: user.id },
          data: {
            userId: null,
            customerName: '',
            customerPhone: '',
            recipientName: '',
            recipientPhone: '',
            address: Prisma.DbNull,
            notes: '',
          },
        }),
        this.prisma.address.deleteMany({ where: { userId: user.id } }),
        this.prisma.occasionReminder.deleteMany({
          where: { userId: user.id },
        }),
        this.prisma.savedDesign.deleteMany({ where: { userId: user.id } }),
        this.prisma.favorite.deleteMany({ where: { userId: user.id } }),
        this.prisma.cart.deleteMany({ where: { userId: user.id } }),
        this.prisma.refreshToken.deleteMany({ where: { userId: user.id } }),
        this.prisma.passwordResetToken.deleteMany({
          where: { userId: user.id },
        }),
        this.prisma.notification.deleteMany({ where: { userId: user.id } }),
        ...(user.phone
          ? [this.prisma.otpCode.deleteMany({ where: { phone: user.phone } })]
          : []),
        this.prisma.user.update({
          where: { id: user.id },
          data: {
            name: '',
            phone: null,
            email: null,
            passwordHash: null,
            googleSub: null,
            homeArea: null,
            deletionRequestedAt: null,
          },
        }),
      ]);
      erased += 1;
    }
    return erased;
  }
}
