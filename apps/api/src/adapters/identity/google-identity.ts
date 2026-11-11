import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { OAuth2Client } from 'google-auth-library';
import { AppError } from '../../common/errors/app-error.js';
import type { Env } from '../../config/env.schema.js';

export interface GoogleIdentity {
  sub: string;
  email?: string;
  emailVerified: boolean;
  name?: string;
}

/** Verifies a Google ID token from the app (EI-SW-06). Behind an interface for tests. */
export abstract class GoogleIdentityVerifier {
  abstract readonly enabled: boolean;
  abstract verify(idToken: string): Promise<GoogleIdentity>;
}

@Injectable()
export class GoogleAuthLibraryVerifier extends GoogleIdentityVerifier {
  private readonly audiences: string[];
  private readonly client = new OAuth2Client();

  constructor(config: ConfigService<Env, true>) {
    super();
    this.audiences = config
      .get('GOOGLE_CLIENT_IDS', { infer: true })
      .split(',')
      .map((id) => id.trim())
      .filter(Boolean);
  }

  get enabled(): boolean {
    return this.audiences.length > 0;
  }

  async verify(idToken: string): Promise<GoogleIdentity> {
    if (!this.enabled) throw new AppError('GOOGLE_SIGN_IN_UNAVAILABLE');
    try {
      const ticket = await this.client.verifyIdToken({
        idToken,
        audience: this.audiences,
      });
      const payload = ticket.getPayload();
      if (!payload?.sub) throw new Error('No subject in Google token');
      return {
        sub: payload.sub,
        email: payload.email?.toLowerCase(),
        emailVerified: payload.email_verified === true,
        name: payload.name,
      };
    } catch {
      throw new AppError('GOOGLE_TOKEN_INVALID');
    }
  }
}
