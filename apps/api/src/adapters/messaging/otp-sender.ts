import { Injectable, Logger } from '@nestjs/common';
import { maskPhone } from '../../common/phone/phone.js';

export interface OtpMessage {
  /** E.164 */
  phone: string;
  code: string;
  language: 'ar' | 'en';
  channel: 'sms' | 'whatsapp';
  expiresInMinutes: number;
}

/**
 * Delivers sign-in codes by SMS or WhatsApp (EI-SW-06). The provider is still open
 * (OI-05); each one is a class behind this interface (NFR-FLX-02).
 */
export abstract class OtpSender {
  abstract send(message: OtpMessage): Promise<void>;
}

/** The text the customer receives, in their language. */
export function otpText(message: OtpMessage): string {
  return message.language === 'en'
    ? `Your Belle Biens code is ${message.code}. It expires in ${message.expiresInMinutes} minutes. Do not share it.`
    : `رمز التحقق من Belle Biens هو ${message.code}. صالح لمدة ${message.expiresInMinutes} دقائق. لا تشاركه مع أحد.`;
}

/**
 * Development and staging only: writes the code to the API log instead of sending it.
 * Production refuses to start with this provider (see env.schema.ts).
 */
@Injectable()
export class ConsoleOtpSender extends OtpSender {
  private readonly logger = new Logger('OtpSender');

  async send(message: OtpMessage): Promise<void> {
    this.logger.warn(
      `[console provider] ${message.channel} code for ${maskPhone(message.phone)}: ${message.code}`,
    );
    await Promise.resolve();
  }
}
