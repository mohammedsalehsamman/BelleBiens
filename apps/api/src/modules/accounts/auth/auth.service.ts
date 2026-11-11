import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { GoogleIdentityVerifier } from '../../../adapters/identity/google-identity.js';
import { Mailer } from '../../../adapters/messaging/mailer.js';
import { Clock } from '../../../common/clock/clock.js';
import { AppError } from '../../../common/errors/app-error.js';
import { randomToken, sha256 } from '../../../common/security/hashing.js';
import type { Env } from '../../../config/env.schema.js';
import type { User } from '../../../generated/prisma/client.js';
import { PrismaService } from '../../../infra/prisma/prisma.service.js';
import { MeDto } from '../me/dto/me.dto.js';
import type {
  AuthSessionDto,
  GoogleSignInDto,
  LoginDto,
  RegisterDto,
  VerifyOtpDto,
} from './dto/auth.dto.js';
import { OtpService } from './otp.service.js';
import { PasswordService } from './password.service.js';
import { TokenService } from './token.service.js';

const RESET_TTL_MS = 30 * 60 * 1000;

/** Sign-in by phone code, email and password, or Google (FR-ACC-01/02, DC-07). */
@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
    private readonly otp: OtpService,
    private readonly tokens: TokenService,
    private readonly passwords: PasswordService,
    private readonly google: GoogleIdentityVerifier,
    private readonly mailer: Mailer,
    private readonly config: ConfigService<Env, true>,
  ) {}

  /**
   * Verifies the code and signs in, creating the account the first time a phone is seen.
   * Profile fields from the register screen apply only to a new account.
   */
  async signInWithOtp(
    dto: VerifyOtpDto,
    language: 'ar' | 'en',
  ): Promise<AuthSessionDto> {
    const phone = this.otp.normalize(dto.phone);
    const existing = await this.prisma.user.findUnique({ where: { phone } });
    const email = dto.email?.toLowerCase();
    // Check the email before spending the code, so a taken email does not burn it.
    if (!existing && email) await this.assertEmailFree(email);

    await this.otp.verify(phone, dto.code);
    const now = this.clock.now();

    if (existing) {
      this.assertActive(existing);
      const user = await this.prisma.user.update({
        where: { id: existing.id },
        data: { phoneVerifiedAt: now },
      });
      return this.session(user, false);
    }

    const user = await this.prisma.user.create({
      data: {
        phone,
        phoneVerifiedAt: now,
        name: dto.name?.trim() ?? '',
        email,
        homeArea: dto.homeArea?.trim() || null,
        marketingOptIn: dto.marketingOptIn ?? false,
        termsAcceptedAt: dto.acceptTerms ? now : null,
        language,
        createdAt: now,
      },
    });
    return this.session(user, true);
  }

  async register(
    dto: RegisterDto,
    language: 'ar' | 'en',
  ): Promise<AuthSessionDto> {
    if (!dto.acceptTerms) throw new AppError('TERMS_NOT_ACCEPTED');
    const email = dto.email.toLowerCase();
    await this.assertEmailFree(email);
    const now = this.clock.now();
    const user = await this.prisma.user.create({
      data: {
        name: dto.name.trim(),
        email,
        passwordHash: await this.passwords.hash(dto.password),
        marketingOptIn: dto.marketingOptIn ?? false,
        termsAcceptedAt: now,
        language,
        createdAt: now,
      },
    });
    return this.session(user, true);
  }

  async login(dto: LoginDto): Promise<AuthSessionDto> {
    const user = await this.prisma.user.findUnique({
      where: { email: dto.email.toLowerCase() },
    });
    const ok = await this.passwords.verify(user?.passwordHash, dto.password);
    if (!user || !ok) throw new AppError('INVALID_CREDENTIALS');
    this.assertActive(user);
    return this.session(user, false);
  }

  async signInWithGoogle(
    dto: GoogleSignInDto,
    language: 'ar' | 'en',
  ): Promise<AuthSessionDto> {
    const identity = await this.google.verify(dto.idToken);
    let user = await this.prisma.user.findUnique({
      where: { googleSub: identity.sub },
    });

    if (!user && identity.email && identity.emailVerified) {
      // Link Google to an existing account with the same verified email.
      const byEmail = await this.prisma.user.findUnique({
        where: { email: identity.email },
      });
      if (byEmail) {
        this.assertActive(byEmail);
        user = await this.prisma.user.update({
          where: { id: byEmail.id },
          data: { googleSub: identity.sub },
        });
      }
    }
    if (user) {
      this.assertActive(user);
      return this.session(user, false);
    }

    const now = this.clock.now();
    const created = await this.prisma.user.create({
      data: {
        googleSub: identity.sub,
        email: identity.emailVerified ? identity.email : undefined,
        name: dto.name?.trim() || identity.name || '',
        homeArea: dto.homeArea?.trim() || null,
        marketingOptIn: dto.marketingOptIn ?? false,
        termsAcceptedAt: dto.acceptTerms ? now : null,
        language,
        createdAt: now,
      },
    });
    return this.session(created, true);
  }

  async refresh(refreshToken: string): Promise<AuthSessionDto> {
    const { tokens, userId } = await this.tokens.rotate(refreshToken);
    const user = await this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
    });
    return { ...tokens, isNewUser: false, user: MeDto.from(user) };
  }

  async logout(refreshToken: string): Promise<void> {
    await this.tokens.revoke(refreshToken);
  }

  /** Always succeeds, so the response does not reveal which emails have accounts. */
  async requestPasswordReset(rawEmail: string): Promise<void> {
    const user = await this.prisma.user.findUnique({
      where: { email: rawEmail.toLowerCase() },
    });
    if (!user?.email || user.status !== 'ACTIVE') return;

    const token = randomToken();
    const now = this.clock.now();
    await this.prisma.passwordResetToken.create({
      data: {
        userId: user.id,
        tokenHash: sha256(token),
        expiresAt: new Date(now.getTime() + RESET_TTL_MS),
        createdAt: now,
      },
    });
    const link = `${this.config.get('PUBLIC_WEB_URL', { infer: true })}/reset-password?token=${token}`;
    const en = user.language === 'en';
    await this.mailer
      .send({
        to: user.email,
        subject: en
          ? 'Reset your Belle Biens password'
          : 'استعادة كلمة مرور Belle Biens',
        text: en
          ? `Open this link within 30 minutes to choose a new password:\n${link}\n\nIf you did not ask for this, ignore this email.`
          : `افتح هذا الرابط خلال 30 دقيقة لاختيار كلمة مرور جديدة:\n${link}\n\nإذا لم تطلب ذلك، تجاهل هذه الرسالة.`,
      })
      .catch((error: unknown) => {
        // The token is stored; the customer can ask again. Never fail the request.
        this.logger.error(
          { err: error },
          'Could not send the password reset email',
        );
      });
  }

  async confirmPasswordReset(
    token: string,
    newPassword: string,
  ): Promise<void> {
    const passwordHash = await this.passwords.hash(newPassword);
    const now = this.clock.now();
    const stored = await this.prisma.passwordResetToken.findUnique({
      where: { tokenHash: sha256(token) },
    });
    if (!stored || stored.usedAt || stored.expiresAt <= now) {
      throw new AppError('RESET_TOKEN_INVALID');
    }
    await this.prisma.$transaction(async (tx) => {
      const used = await tx.passwordResetToken.updateMany({
        where: { id: stored.id, usedAt: null },
        data: { usedAt: now },
      });
      if (used.count !== 1) throw new AppError('RESET_TOKEN_INVALID');
      await tx.user.update({
        where: { id: stored.userId },
        data: { passwordHash },
      });
    });
    // A new password ends every existing session.
    await this.tokens.revokeAllForUser(stored.userId);
  }

  private async assertEmailFree(email: string): Promise<void> {
    const taken = await this.prisma.user.findUnique({
      where: { email },
      select: { id: true },
    });
    if (taken) throw new AppError('EMAIL_TAKEN');
  }

  private assertActive(user: User): void {
    if (user.status === 'DISABLED') throw new AppError('ACCOUNT_DISABLED');
  }

  private async session(
    user: User,
    isNewUser: boolean,
  ): Promise<AuthSessionDto> {
    const tokens = await this.tokens.issue(user);
    return { ...tokens, isNewUser, user: MeDto.from(user) };
  }
}
