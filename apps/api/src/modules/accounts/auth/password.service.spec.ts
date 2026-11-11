import { AppError } from '../../../common/errors/app-error.js';
import { PasswordService } from './password.service.js';

describe('PasswordService (NFR-SEC-02)', () => {
  const passwords = new PasswordService();

  it('stores Argon2id hashes that verify', async () => {
    const hash = await passwords.hash('ward-dimashqi');
    expect(hash.startsWith('$argon2id$')).toBe(true);
    expect(await passwords.verify(hash, 'ward-dimashqi')).toBe(true);
    expect(await passwords.verify(hash, 'wrong-password')).toBe(false);
  });

  it('salts every hash', async () => {
    expect(await passwords.hash('same-password')).not.toBe(
      await passwords.hash('same-password'),
    );
  });

  it('rejects passwords shorter than 8 characters, counting Arabic letters once', async () => {
    await expect(passwords.hash('short')).rejects.toBeInstanceOf(AppError);
    await expect(passwords.hash('كلمة')).rejects.toMatchObject({
      code: 'PASSWORD_TOO_WEAK',
    });
    await expect(passwords.hash('كلمةسرّية')).resolves.toMatch(/^\$argon2id\$/);
  });

  it('spends time verifying even when there is no hash, and says no', async () => {
    expect(await passwords.verify(null, 'anything')).toBe(false);
    expect(await passwords.verify('not-a-hash', 'anything')).toBe(false);
  });
});
