import { Global, Module } from '@nestjs/common';
import {
  GoogleAuthLibraryVerifier,
  GoogleIdentityVerifier,
} from './identity/google-identity.js';
import { Mailer, SmtpMailer } from './messaging/mailer.js';
import {
  ConsoleMessageGateway,
  MessageGateway,
} from './messaging/message-gateway.js';
import { ConsoleOtpSender, OtpSender } from './messaging/otp-sender.js';
import { MediaStorage, S3MediaStorage } from './storage/media-storage.js';

/**
 * Binds each provider interface to its implementation. Domain modules depend on the
 * abstract classes only (NFR-FLX-02, design diagram 8); swapping a provider means
 * changing one line here.
 */
@Global()
@Module({
  providers: [
    { provide: OtpSender, useClass: ConsoleOtpSender },
    { provide: Mailer, useClass: SmtpMailer },
    { provide: GoogleIdentityVerifier, useClass: GoogleAuthLibraryVerifier },
    { provide: MediaStorage, useClass: S3MediaStorage },
    { provide: MessageGateway, useClass: ConsoleMessageGateway },
  ],
  exports: [
    OtpSender,
    Mailer,
    GoogleIdentityVerifier,
    MediaStorage,
    MessageGateway,
  ],
})
export class AdaptersModule {}
