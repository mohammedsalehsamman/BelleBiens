import { Injectable } from '@nestjs/common';
import { type Algorithm, hash, verify } from '@node-rs/argon2';
import { AppError } from '../../../common/errors/app-error.js';

export const MIN_PASSWORD_LENGTH = 8;

/** Algorithm.Argon2id is an ambient const enum, which isolatedModules cannot read. */
const ARGON2ID = 2 as Algorithm;

/** Counts what a person sees as characters, so Arabic letters and emoji count once. */
function characterCount(text: string): number {
  let count = 0;
  for (const _ of new Intl.Segmenter().segment(text)) count += 1;
  return count;
}

/** NFR-SEC-02: passwords are stored only as salted Argon2id hashes, 8 characters minimum. */
@Injectable()
export class PasswordService {
  /** A real hash used to spend the same time when an email does not exist (no user enumeration). */
  private dummyHash: Promise<string> | null = null;

  assertStrong(password: string): void {
    if (characterCount(password) < MIN_PASSWORD_LENGTH)
      throw new AppError('PASSWORD_TOO_WEAK');
  }

  async hash(password: string): Promise<string> {
    this.assertStrong(password);
    return hash(password, { algorithm: ARGON2ID });
  }

  async verify(
    passwordHash: string | null | undefined,
    password: string,
  ): Promise<boolean> {
    if (!passwordHash) {
      this.dummyHash ??= hash('not-a-real-password', { algorithm: ARGON2ID });
      await verify(await this.dummyHash, password).catch(() => false);
      return false;
    }
    return verify(passwordHash, password).catch(() => false);
  }
}
