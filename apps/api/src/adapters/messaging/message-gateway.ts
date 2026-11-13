import { Injectable, Logger } from '@nestjs/common';
import { maskPhone } from '../../common/phone/phone.js';

export type MessageChannel = 'WHATSAPP' | 'SMS' | 'PUSH';

export interface OutgoingMessage {
  channel: MessageChannel;
  /** E.164 phone for WhatsApp and SMS; the device token for push. */
  recipient: string;
  /** Push only. */
  title: string;
  body: string;
  /** Push only: what the app opens on a tap. */
  data?: Record<string, string>;
}

/**
 * Sends one message on one channel (EI-SW-01/09, FR-NTF-*). The WhatsApp and
 * SMS provider is still open (OI-05) and push needs the shop's Firebase
 * project; each is a class behind this interface (NFR-FLX-02). A send that
 * fails throws, and the notification queue tries again (FR-NTF-07).
 */
export abstract class MessageGateway {
  abstract send(message: OutgoingMessage): Promise<void>;
}

/** Development and staging: writes messages to the API log instead of sending. */
@Injectable()
export class ConsoleMessageGateway extends MessageGateway {
  private readonly logger = new Logger('MessageGateway');

  async send(message: OutgoingMessage): Promise<void> {
    const to =
      message.channel === 'PUSH'
        ? `device …${message.recipient.slice(-6)}`
        : maskPhone(message.recipient);
    this.logger.log(
      `[console provider] ${message.channel} to ${to}: ${message.title ? `${message.title} · ` : ''}${message.body.replace(/\n/g, ' / ')}`,
    );
    await Promise.resolve();
  }
}
