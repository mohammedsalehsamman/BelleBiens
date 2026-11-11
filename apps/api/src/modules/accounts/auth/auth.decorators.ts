import {
  createParamDecorator,
  type ExecutionContext,
  SetMetadata,
} from '@nestjs/common';
import type { Request } from 'express';
import type { Role } from '../../../generated/prisma/client.js';

export const IS_PUBLIC = 'auth:isPublic';
export const ROLES = 'auth:roles';
export const AUTH_RATE_LIMITED = 'auth:rateLimited';

/** The route works without signing in. A valid token, if sent, still sets the user. */
export const Public = () => SetMetadata(IS_PUBLIC, true);

/**
 * Only these roles may call the route (FR-ADM-01, NFR-SEC-01). The server checks it on
 * every call; hiding a screen in the dashboard is only a convenience.
 */
export const Roles = (...roles: Role[]) => SetMetadata(ROLES, roles);

/** Applies the stricter sign-in rate limit (NFR-SEC-03). */
export const AuthRateLimited = () => SetMetadata(AUTH_RATE_LIMITED, true);

/** The signed-in user, as loaded by JwtAuthGuard. */
export interface AuthUser {
  id: string;
  role: Role;
}

export type AuthenticatedRequest = Request & { user?: AuthUser };

export const CurrentUser = createParamDecorator(
  (_: unknown, context: ExecutionContext): AuthUser | undefined =>
    context.switchToHttp().getRequest<AuthenticatedRequest>().user,
);
