import {
  type GoogleIdentity,
  GoogleIdentityVerifier,
} from '../../src/adapters/identity/google-identity.js';
import {
  type MailMessage,
  Mailer,
} from '../../src/adapters/messaging/mailer.js';
import {
  type OtpMessage,
  OtpSender,
} from '../../src/adapters/messaging/otp-sender.js';
import { MediaStorage } from '../../src/adapters/storage/media-storage.js';
import { AppError } from '../../src/common/errors/app-error.js';

/** Keeps every code "sent", so tests can type it like a customer would. */
export class CapturingOtpSender extends OtpSender {
  readonly sent: OtpMessage[] = [];

  async send(message: OtpMessage): Promise<void> {
    this.sent.push(message);
    await Promise.resolve();
  }

  lastCodeFor(phone: string): string {
    const message = [...this.sent].reverse().find((m) => m.phone === phone);
    if (!message) throw new Error(`No code was sent to ${phone}`);
    return message.code;
  }
}

export class CapturingMailer extends Mailer {
  readonly sent: MailMessage[] = [];

  async send(message: MailMessage): Promise<void> {
    this.sent.push(message);
    await Promise.resolve();
  }
}

/** Accepts only the tokens a test registered. */
export class FakeGoogleVerifier extends GoogleIdentityVerifier {
  enabled = true;
  readonly identities = new Map<string, GoogleIdentity>();

  async verify(idToken: string): Promise<GoogleIdentity> {
    await Promise.resolve();
    if (!this.enabled) throw new AppError('GOOGLE_SIGN_IN_UNAVAILABLE');
    const identity = this.identities.get(idToken);
    if (!identity) throw new AppError('GOOGLE_TOKEN_INVALID');
    return identity;
  }
}

/** Keeps uploads in memory instead of the S3 store. */
export class MemoryMediaStorage extends MediaStorage {
  readonly files = new Map<string, { bytes: Buffer; contentType: string }>();

  async put(key: string, bytes: Buffer, contentType: string): Promise<string> {
    this.files.set(key, { bytes, contentType });
    await Promise.resolve();
    return `https://media.test/${key}`;
  }
}
