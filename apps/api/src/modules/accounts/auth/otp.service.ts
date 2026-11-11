import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { OtpSender } from '../../../adapters/messaging/otp-sender.js';
import { Clock } from '../../../common/clock/clock.js';
import { AppError } from '../../../common/errors/app-error.js';
import { maskPhone, normalizePhone } from '../../../common/phone/phone.js';
import {
  hmacSha256,
  numericCode,
  safeEqualHex,
} from '../../../common/security/hashing.js';
import type { Env } from '../../../config/env.schema.js';
import { PrismaService } from '../../../infra/prisma/prisma.service.js';

const WINDOW_MS = 10 * 60 * 1000;

export interface OtpRequested {
  phone: string;
  maskedPhone: string;
  channel: 'sms' | 'whatsapp';
  codeLength: number;
  expiresInSeconds: number;
  resendAfterSeconds: number;
}

/**
 * Phone sign-in codes (FR-ACC-01, EI-SW-06). NFR-SEC-10: 5 minutes, at most 5
 * attempts. NFR-SEC-03: a few codes per phone per 10 minutes, with a resend delay.
 * Only the latest code of a phone is valid.
 */
@Injectable()
export class OtpService {
  private readonly length: number;
  private readonly ttlSeconds: number;
  private readonly maxAttempts: number;
  private readonly resendSeconds: number;
  private readonly maxPerWindow: number;
  private readonly pepper: string;
  /** Development and test only (see env.schema.ts). */
  private readonly fixedCode: string | undefined;

  constructor(
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
    private readonly sender: OtpSender,
    config: ConfigService<Env, true>,
  ) {
    this.length = config.get('OTP_LENGTH', { infer: true });
    this.ttlSeconds = config.get('OTP_TTL_SECONDS', { infer: true });
    this.maxAttempts = config.get('OTP_MAX_ATTEMPTS', { infer: true });
    this.resendSeconds = config.get('OTP_RESEND_SECONDS', { infer: true });
    this.maxPerWindow = config.get('OTP_MAX_PER_WINDOW', { infer: true });
    this.fixedCode = config.get('OTP_FIXED_CODE', { infer: true });
    this.pepper =
      config.get('OTP_PEPPER', { infer: true }) ??
      config.get('JWT_ACCESS_SECRET', { infer: true });
  }

  /** Throws PHONE_INVALID unless the number normalizes (FR-CRT-09). */
  normalize(rawPhone: string): string {
    const phone = normalizePhone(rawPhone);
    if (!phone) throw new AppError('PHONE_INVALID');
    return phone;
  }

  async request(
    rawPhone: string,
    channel: 'sms' | 'whatsapp',
    language: 'ar' | 'en',
  ): Promise<OtpRequested> {
    const phone = this.normalize(rawPhone);
    const now = this.clock.now();

    const recent = await this.prisma.otpCode.findMany({
      where: { phone, createdAt: { gt: new Date(now.getTime() - WINDOW_MS) } },
      orderBy: { createdAt: 'desc' },
      select: { createdAt: true },
    });
    const last = recent[0];
    if (last) {
      const waitMs =
        last.createdAt.getTime() + this.resendSeconds * 1000 - now.getTime();
      if (waitMs > 0) {
        throw new AppError('OTP_RESEND_TOO_SOON', {
          extra: { retryAfterSeconds: Math.ceil(waitMs / 1000) },
        });
      }
    }
    if (recent.length >= this.maxPerWindow)
      throw new AppError('OTP_RATE_LIMITED');

    const code = this.fixedCode ?? numericCode(this.length);
    await this.prisma.$transaction([
      // Older codes stop working as soon as a new one is sent.
      this.prisma.otpCode.updateMany({
        where: { phone, consumedAt: null, expiresAt: { gt: now } },
        data: { expiresAt: now },
      }),
      this.prisma.otpCode.create({
        data: {
          phone,
          codeHash: hmacSha256(this.pepper, `${phone}:${code}`),
          channel,
          createdAt: now,
          expiresAt: new Date(now.getTime() + this.ttlSeconds * 1000),
        },
      }),
    ]);

    await this.sender.send({
      phone,
      code,
      channel,
      language,
      expiresInMinutes: Math.round(this.ttlSeconds / 60),
    });

    return {
      phone,
      maskedPhone: maskPhone(phone),
      channel,
      codeLength: this.length,
      expiresInSeconds: this.ttlSeconds,
      resendAfterSeconds: this.resendSeconds,
    };
  }

  /** Consumes the code and returns the verified E.164 phone. */
  async verify(rawPhone: string, code: string): Promise<string> {
    const phone = this.normalize(rawPhone);
    const now = this.clock.now();

    const latest = await this.prisma.otpCode.findFirst({
      where: { phone, consumedAt: null },
      orderBy: { createdAt: 'desc' },
    });
    if (!latest) throw new AppError('OTP_INVALID');
    if (latest.expiresAt <= now) throw new AppError('OTP_EXPIRED');
    if (latest.attempts >= this.maxAttempts)
      throw new AppError('OTP_TOO_MANY_ATTEMPTS');

    const matches = safeEqualHex(
      latest.codeHash,
      hmacSha256(this.pepper, `${phone}:${code}`),
    );
    if (!matches) {
      const attempts = latest.attempts + 1;
      await this.prisma.otpCode.update({
        where: { id: latest.id },
        data: { attempts },
      });
      if (attempts >= this.maxAttempts)
        throw new AppError('OTP_TOO_MANY_ATTEMPTS');
      throw new AppError('OTP_INVALID', {
        extra: { attemptsLeft: this.maxAttempts - attempts },
      });
    }

    // Single use, even when two verifications race.
    const consumed = await this.prisma.otpCode.updateMany({
      where: { id: latest.id, consumedAt: null },
      data: { consumedAt: now },
    });
    if (consumed.count !== 1) throw new AppError('OTP_INVALID');
    return phone;
  }
}
