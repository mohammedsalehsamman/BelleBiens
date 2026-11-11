import { Injectable } from '@nestjs/common';
import { Clock } from '../../../common/clock/clock.js';
import { AppError } from '../../../common/errors/app-error.js';
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
}
