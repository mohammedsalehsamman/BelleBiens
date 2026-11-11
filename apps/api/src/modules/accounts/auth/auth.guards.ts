import {
  type CanActivate,
  type ExecutionContext,
  Injectable,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import type { Role } from '../../../generated/prisma/client.js';
import { AppError } from '../../../common/errors/app-error.js';
import { PrismaService } from '../../../infra/prisma/prisma.service.js';
import {
  type AuthenticatedRequest,
  IS_PUBLIC,
  ROLES,
} from './auth.decorators.js';
import { TokenService } from './token.service.js';

/**
 * Global guard: every route needs a valid access token unless marked @Public().
 * The user is re-read on each call so a disabled account or a changed role takes
 * effect at once, without waiting for the token to expire (NFR-SEC-01).
 */
@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly tokens: TokenService,
    private readonly prisma: PrismaService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    if (context.getType() !== 'http') return true;
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC, [
      context.getHandler(),
      context.getClass(),
    ]);
    const request = context.switchToHttp().getRequest<AuthenticatedRequest>();
    const header = request.header('authorization');
    const token = header?.startsWith('Bearer ')
      ? header.slice(7).trim()
      : undefined;

    if (!token) {
      if (isPublic) return true;
      throw new AppError('UNAUTHORIZED');
    }

    const claims = await this.tokens.verifyAccessToken(token).catch(() => null);
    if (!claims) {
      if (isPublic) return true;
      throw new AppError('TOKEN_INVALID');
    }

    const user = await this.prisma.user.findUnique({
      where: { id: claims.sub },
      select: { id: true, role: true, status: true },
    });
    if (!user || user.status === 'DELETION_REQUESTED') {
      if (isPublic) return true;
      throw new AppError('TOKEN_INVALID');
    }
    if (user.status === 'DISABLED') throw new AppError('ACCOUNT_DISABLED');

    request.user = { id: user.id, role: user.role };
    return true;
  }
}

/** Global guard: enforces @Roles(...) where present. Runs after JwtAuthGuard. */
@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const roles = this.reflector.getAllAndOverride<Role[] | undefined>(ROLES, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!roles?.length) return true;
    const user = context.switchToHttp().getRequest<AuthenticatedRequest>().user;
    if (!user) throw new AppError('UNAUTHORIZED');
    if (!roles.includes(user.role)) throw new AppError('FORBIDDEN');
    return true;
  }
}
