import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createTransport, type Transporter } from 'nodemailer';
import type { Env } from '../../config/env.schema.js';

export interface MailMessage {
  to: string;
  subject: string;
  text: string;
}

/** Outgoing email (password reset, FR-ACC-02). */
export abstract class Mailer {
  abstract send(message: MailMessage): Promise<void>;
}

/** SMTP: Mailpit in development (http://localhost:8025), the real relay in production. */
@Injectable()
export class SmtpMailer extends Mailer {
  private readonly transport: Transporter;
  private readonly from: string;

  constructor(config: ConfigService<Env, true>) {
    super();
    this.transport = createTransport(
      config.get('MAIL_SMTP_URL', { infer: true }),
    );
    this.from = config.get('MAIL_FROM', { infer: true });
  }

  async send(message: MailMessage): Promise<void> {
    await this.transport.sendMail({ from: this.from, ...message });
  }
}
