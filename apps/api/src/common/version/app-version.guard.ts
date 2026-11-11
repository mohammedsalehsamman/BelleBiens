import {
  type CanActivate,
  type ExecutionContext,
  Injectable,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Request } from 'express';
import type { Env } from '../../config/env.schema.js';
import { AppError } from '../errors/app-error.js';
import { APP_VERSION_HEADER, compareVersions } from './app-version.js';

/**
 * NFR-CMP-01: the backend serves app versions up to two releases old. Older apps
 * get 426 UPGRADE_REQUIRED and show the update screen. Requests without the
 * header (website, dashboard, tools) are not affected; health checks never are.
 */
@Injectable()
export class AppVersionGuard implements CanActivate {
  constructor(private readonly config: ConfigService<Env, true>) {}

  canActivate(context: ExecutionContext): boolean {
    if (context.getType() !== 'http') return true;
    const request = context.switchToHttp().getRequest<Request>();
    if (request.path.startsWith('/v1/health')) return true;

    const version = request.header(APP_VERSION_HEADER);
    if (!version) return true;

    const minimum = this.config.get('APP_MIN_SUPPORTED_VERSION', {
      infer: true,
    });
    if (compareVersions(version, minimum) < 0) {
      throw new AppError('UPGRADE_REQUIRED', {
        extra: { minSupportedVersion: minimum },
      });
    }
    return true;
  }
}
