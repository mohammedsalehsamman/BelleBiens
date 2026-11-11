import { randomUUID } from 'node:crypto';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import type { Role, User } from '../../../generated/prisma/client.js';
import { Clock } from '../../../common/clock/clock.js';
import { AppError } from '../../../common/errors/app-error.js';
import { randomToken, sha256 } from '../../../common/security/hashing.js';
import type { Env } from '../../../config/env.schema.js';
import { PrismaService } from '../../../infra/prisma/prisma.service.js';

export interface AccessClaims {
  sub: string;
  role: Role;
}

export interface IssuedTokens {
  accessToken: string;
  accessTokenExpiresIn: number;
  refreshToken: string;
  refreshTokenExpiresAt: Date;
}

interface NewRefreshToken {
  id: string;
  token: string;
  expiresAt: Date;
}

/**
 * Short-lived JWT access tokens (15 minutes by default) and long-lived opaque refresh
 * tokens (DC-07: tokens for the app). Refresh tokens rotate on every use; presenting
 * one that was already rotated means it was copied, so the whole family is revoked.
 */
@Injectable()
export class TokenService {
  private readonly accessTtl: number;
  private readonly refreshTtlMs: number;

  constructor(
    private readonly jwt: JwtService,
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
    config: ConfigService<Env, true>,
  ) {
    this.accessTtl = config.get('JWT_ACCESS_TTL_SECONDS', { infer: true });
    this.refreshTtlMs =
      config.get('REFRESH_TOKEN_TTL_DAYS', { infer: true }) * 86_400_000;
  }

  async verifyAccessToken(token: string): Promise<AccessClaims> {
    return this.jwt.verifyAsync<AccessClaims>(token, { algorithms: ['HS256'] });
  }

  /** Starts a new session: a new refresh-token family. */
  async issue(user: Pick<User, 'id' | 'role'>): Promise<IssuedTokens> {
    const now = this.clock.now();
    const next = this.newRefreshToken(now);
    await this.prisma.refreshToken.create({
      data: {
        id: next.id,
        userId: user.id,
        familyId: randomUUID(),
        tokenHash: sha256(next.token),
        expiresAt: next.expiresAt,
        createdAt: now,
      },
    });
    return this.sign(user, next);
  }

  /** Exchanges a refresh token for a new pair. */
  async rotate(
    refreshToken: string,
  ): Promise<{ tokens: IssuedTokens; userId: string }> {
    const now = this.clock.now();
    const stored = await this.prisma.refreshToken.findUnique({
      where: { tokenHash: sha256(refreshToken) },
      include: { user: { select: { id: true, role: true, status: true } } },
    });
    if (!stored) throw new AppError('TOKEN_INVALID');

    if (stored.revokedAt) {
      // Reuse of a rotated token: assume theft and end every session in this family.
      await this.revokeFamily(stored.familyId);
      throw new AppError('TOKEN_INVALID');
    }
    if (stored.expiresAt <= now) throw new AppError('TOKEN_INVALID');
    if (stored.user.status === 'DISABLED')
      throw new AppError('ACCOUNT_DISABLED');
    if (stored.user.status !== 'ACTIVE') throw new AppError('TOKEN_INVALID');

    const next = this.newRefreshToken(now);
    await this.prisma.$transaction(async (tx) => {
      // Only one concurrent rotation can win: the update matches while revokedAt is null.
      const result = await tx.refreshToken.updateMany({
        where: { id: stored.id, revokedAt: null },
        data: { revokedAt: now, replacedById: next.id },
      });
      if (result.count !== 1) throw new AppError('TOKEN_INVALID');
      await tx.refreshToken.create({
        data: {
          id: next.id,
          userId: stored.userId,
          familyId: stored.familyId,
          tokenHash: sha256(next.token),
          expiresAt: next.expiresAt,
          createdAt: now,
        },
      });
    });
    return {
      tokens: await this.sign(stored.user, next),
      userId: stored.userId,
    };
  }

  /** Signs out the session that owns this refresh token. Unknown tokens are ignored. */
  async revoke(refreshToken: string): Promise<void> {
    const stored = await this.prisma.refreshToken.findUnique({
      where: { tokenHash: sha256(refreshToken) },
      select: { familyId: true },
    });
    if (stored) await this.revokeFamily(stored.familyId);
  }

  /** Signs out every session of a user (password reset, account disabled). */
  async revokeAllForUser(userId: string): Promise<void> {
    await this.prisma.refreshToken.updateMany({
      where: { userId, revokedAt: null },
      data: { revokedAt: this.clock.now() },
    });
  }

  private async revokeFamily(familyId: string): Promise<void> {
    await this.prisma.refreshToken.updateMany({
      where: { familyId, revokedAt: null },
      data: { revokedAt: this.clock.now() },
    });
  }

  private newRefreshToken(now: Date): NewRefreshToken {
    return {
      id: randomUUID(),
      token: randomToken(),
      expiresAt: new Date(now.getTime() + this.refreshTtlMs),
    };
  }

  private async sign(
    user: Pick<User, 'id' | 'role'>,
    refresh: NewRefreshToken,
  ): Promise<IssuedTokens> {
    const accessToken = await this.jwt.signAsync(
      { sub: user.id, role: user.role } satisfies AccessClaims,
      { expiresIn: this.accessTtl, algorithm: 'HS256' },
    );
    return {
      accessToken,
      accessTokenExpiresIn: this.accessTtl,
      refreshToken: refresh.token,
      refreshTokenExpiresAt: refresh.expiresAt,
    };
  }
}
