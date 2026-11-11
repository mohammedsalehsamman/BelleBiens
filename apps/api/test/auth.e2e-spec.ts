import { createTestApp, type TestApp } from './support/test-app.js';

const PHONE_LOCAL = '0944123456';
const PHONE = '+963944123456';

describe('Accounts and sign-in (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
  });
  beforeEach(async () => {
    await t.reset();
  });
  afterAll(async () => {
    await t.close();
  });

  function requestCode(phone = PHONE_LOCAL, channel?: 'sms' | 'whatsapp') {
    return t
      .http()
      .post('/v1/auth/otp/request')
      .send({ phone, ...(channel && { channel }) });
  }

  async function signUpByPhone(extra: Record<string, unknown> = {}) {
    await requestCode().expect(202);
    const code = t.otp.lastCodeFor(PHONE);
    return t
      .http()
      .post('/v1/auth/otp/verify')
      .send({ phone: PHONE_LOCAL, code, ...extra })
      .expect(200);
  }

  describe('phone code (screens 02 to 04)', () => {
    it('sends a 4-digit code to the normalized number and masks it', async () => {
      const res = await requestCode('0944 123 456', 'whatsapp').expect(202);
      expect(res.body).toEqual({
        phone: PHONE,
        maskedPhone: '+963 944 *** 456',
        channel: 'whatsapp',
        codeLength: 4,
        expiresInSeconds: 300,
        resendAfterSeconds: 60,
      });
      expect(t.otp.sent).toHaveLength(1);
      expect(t.otp.sent[0]).toMatchObject({
        phone: PHONE,
        channel: 'whatsapp',
        language: 'ar',
      });
      expect(t.otp.sent[0]!.code).toMatch(/^\d{4}$/);
    });

    it('stores only a hash of the code (NFR-SEC-10)', async () => {
      await requestCode().expect(202);
      const code = t.otp.lastCodeFor(PHONE);
      const row = await t.prisma.otpCode.findFirstOrThrow({
        where: { phone: PHONE },
      });
      expect(row.codeHash).not.toContain(code);
      expect(row.codeHash).toMatch(/^[0-9a-f]{64}$/);
    });

    it('rejects an invalid number (FR-CRT-09)', async () => {
      const res = await requestCode('0833000000').expect(400);
      expect(res.body.code).toBe('PHONE_INVALID');
    });

    it('creates the account on first sign-in with the register screen fields', async () => {
      const res = await signUpByPhone({
        name: 'سارة الأحمد',
        email: 'Sara@Example.com',
        homeArea: 'أبو رمانة',
        marketingOptIn: true,
        acceptTerms: true,
      });
      expect(res.body.isNewUser).toBe(true);
      expect(res.body.accessTokenExpiresIn).toBe(900);
      expect(res.body.user).toMatchObject({
        name: 'سارة الأحمد',
        phone: PHONE,
        email: 'sara@example.com',
        role: 'CUSTOMER',
        language: 'ar',
        numerals: 'western',
        marketingOptIn: true,
        homeArea: 'أبو رمانة',
        termsAccepted: true,
        profileComplete: true,
      });

      const me = await t
        .http()
        .get('/v1/me')
        .set('Authorization', `Bearer ${res.body.accessToken}`)
        .expect(200);
      expect(me.body.id).toBe(res.body.user.id);
    });

    it('signs an existing customer back in without changing their profile', async () => {
      const first = await signUpByPhone({ name: 'لين', acceptTerms: true });
      t.clock.advance({ minutes: 1 });
      const second = await signUpByPhone({ name: 'ignored' });
      expect(second.body.isNewUser).toBe(false);
      expect(second.body.user.id).toBe(first.body.user.id);
      expect(second.body.user.name).toBe('لين');
    });

    it('a first sign-in from the login screen leaves the profile to complete', async () => {
      const res = await signUpByPhone();
      expect(res.body.user).toMatchObject({
        name: '',
        termsAccepted: false,
        profileComplete: false,
      });

      const done = await t
        .http()
        .patch('/v1/me')
        .set('Authorization', `Bearer ${res.body.accessToken}`)
        .send({ name: 'سارة', acceptTerms: true })
        .expect(200);
      expect(done.body).toMatchObject({
        name: 'سارة',
        termsAccepted: true,
        profileComplete: true,
      });
    });

    it('wrong codes count down and lock after 5 attempts (NFR-SEC-10)', async () => {
      await requestCode().expect(202);
      const code = t.otp.lastCodeFor(PHONE);
      const wrong = code === '0000' ? '1111' : '0000';

      for (let left = 4; left >= 1; left--) {
        const res = await t
          .http()
          .post('/v1/auth/otp/verify')
          .send({ phone: PHONE_LOCAL, code: wrong })
          .expect(400);
        expect(res.body).toMatchObject({
          code: 'OTP_INVALID',
          attemptsLeft: left,
        });
      }
      const fifth = await t
        .http()
        .post('/v1/auth/otp/verify')
        .send({ phone: PHONE_LOCAL, code: wrong })
        .expect(429);
      expect(fifth.body.code).toBe('OTP_TOO_MANY_ATTEMPTS');
      // Even the right code no longer works.
      const right = await t
        .http()
        .post('/v1/auth/otp/verify')
        .send({ phone: PHONE_LOCAL, code })
        .expect(429);
      expect(right.body.code).toBe('OTP_TOO_MANY_ATTEMPTS');
    });

    it('codes expire after 5 minutes (NFR-SEC-10)', async () => {
      await requestCode().expect(202);
      const code = t.otp.lastCodeFor(PHONE);
      t.clock.advance({ minutes: 5 });
      const res = await t
        .http()
        .post('/v1/auth/otp/verify')
        .send({ phone: PHONE_LOCAL, code })
        .expect(400);
      expect(res.body.code).toBe('OTP_EXPIRED');
    });

    it('a code works only once', async () => {
      await requestCode().expect(202);
      const code = t.otp.lastCodeFor(PHONE);
      await t
        .http()
        .post('/v1/auth/otp/verify')
        .send({ phone: PHONE_LOCAL, code })
        .expect(200);
      const again = await t
        .http()
        .post('/v1/auth/otp/verify')
        .send({ phone: PHONE_LOCAL, code })
        .expect(400);
      expect(again.body.code).toBe('OTP_INVALID');
    });

    it('a new code replaces the previous one', async () => {
      await requestCode().expect(202);
      const first = t.otp.lastCodeFor(PHONE);
      t.clock.advance({ seconds: 61 });
      await requestCode().expect(202);
      const second = t.otp.lastCodeFor(PHONE);
      if (first !== second) {
        await t
          .http()
          .post('/v1/auth/otp/verify')
          .send({ phone: PHONE_LOCAL, code: first })
          .expect(400);
      }
      await t
        .http()
        .post('/v1/auth/otp/verify')
        .send({ phone: PHONE_LOCAL, code: second })
        .expect(200);
    });

    it('limits resends to one per minute and 3 codes per 10 minutes (NFR-SEC-03)', async () => {
      await requestCode().expect(202);
      const tooSoon = await requestCode().expect(429);
      expect(tooSoon.body).toMatchObject({
        code: 'OTP_RESEND_TOO_SOON',
        retryAfterSeconds: 60,
      });

      t.clock.advance({ seconds: 61 });
      await requestCode().expect(202);
      t.clock.advance({ seconds: 61 });
      await requestCode().expect(202);
      t.clock.advance({ seconds: 61 });
      const limited = await requestCode().expect(429);
      expect(limited.body.code).toBe('OTP_RATE_LIMITED');

      t.clock.advance({ minutes: 10 });
      await requestCode().expect(202);
    });

    it('does not burn the code when the sign-up email is already taken', async () => {
      await t.prisma.user.create({
        data: { name: 'x', email: 'taken@example.com' },
      });
      await requestCode().expect(202);
      const code = t.otp.lastCodeFor(PHONE);
      const taken = await t
        .http()
        .post('/v1/auth/otp/verify')
        .send({ phone: PHONE_LOCAL, code, email: 'taken@example.com' })
        .expect(409);
      expect(taken.body.code).toBe('EMAIL_TAKEN');
      await t
        .http()
        .post('/v1/auth/otp/verify')
        .send({ phone: PHONE_LOCAL, code })
        .expect(200);
    });
  });

  describe('sessions', () => {
    it('refresh rotates the token; reusing the old one ends the whole session', async () => {
      const signIn = await signUpByPhone({ name: 'لين', acceptTerms: true });
      const first = signIn.body.refreshToken as string;

      const rotated = await t
        .http()
        .post('/v1/auth/refresh')
        .send({ refreshToken: first })
        .expect(200);
      const second = rotated.body.refreshToken as string;
      expect(second).not.toBe(first);
      expect(rotated.body.user.name).toBe('لين');

      // The old token was copied by someone: both stop working.
      const reuse = await t
        .http()
        .post('/v1/auth/refresh')
        .send({ refreshToken: first })
        .expect(401);
      expect(reuse.body.code).toBe('TOKEN_INVALID');
      await t
        .http()
        .post('/v1/auth/refresh')
        .send({ refreshToken: second })
        .expect(401);
    });

    it('logout ends the session', async () => {
      const signIn = await signUpByPhone();
      await t
        .http()
        .post('/v1/auth/logout')
        .send({ refreshToken: signIn.body.refreshToken })
        .expect(204);
      await t
        .http()
        .post('/v1/auth/refresh')
        .send({ refreshToken: signIn.body.refreshToken })
        .expect(401);
    });

    it('refresh tokens expire after 30 days', async () => {
      const signIn = await signUpByPhone();
      t.clock.advance({ days: 31 });
      await t
        .http()
        .post('/v1/auth/refresh')
        .send({ refreshToken: signIn.body.refreshToken })
        .expect(401);
    });

    it('a disabled account is refused at once, even with a valid token', async () => {
      const signIn = await signUpByPhone();
      await t.prisma.user.update({
        where: { id: signIn.body.user.id },
        data: { status: 'DISABLED' },
      });
      const res = await t
        .http()
        .get('/v1/me')
        .set('Authorization', `Bearer ${signIn.body.accessToken}`)
        .expect(403);
      expect(res.body.code).toBe('ACCOUNT_DISABLED');
    });

    it('stores refresh tokens only as hashes', async () => {
      const signIn = await signUpByPhone();
      const rows = await t.prisma.refreshToken.findMany();
      expect(rows).toHaveLength(1);
      expect(rows[0]!.tokenHash).not.toBe(signIn.body.refreshToken);
    });
  });

  describe('email and password (FR-ACC-01, FR-ACC-02)', () => {
    const account = {
      name: 'Rami',
      email: 'rami@example.com',
      password: 'jasmine-courtyard',
      acceptTerms: true,
    };

    it('registers, then signs in; the wrong password gets one generic answer', async () => {
      const reg = await t
        .http()
        .post('/v1/auth/register')
        .set('Accept-Language', 'en')
        .send(account)
        .expect(201);
      expect(reg.body.user).toMatchObject({
        email: 'rami@example.com',
        language: 'en',
        phone: null,
      });

      await t
        .http()
        .post('/v1/auth/login')
        .send({ email: 'RAMI@example.com', password: account.password })
        .expect(200);

      const wrong = await t
        .http()
        .post('/v1/auth/login')
        .send({ email: account.email, password: 'nope-nope-nope' })
        .expect(401);
      const unknown = await t
        .http()
        .post('/v1/auth/login')
        .send({ email: 'ghost@example.com', password: 'whatever-123' })
        .expect(401);
      expect(wrong.body.code).toBe('INVALID_CREDENTIALS');
      expect(unknown.body.code).toBe('INVALID_CREDENTIALS');
    });

    it('needs the terms, a free email and 8 characters', async () => {
      const noTerms = await t
        .http()
        .post('/v1/auth/register')
        .send({ ...account, acceptTerms: false })
        .expect(400);
      expect(noTerms.body.code).toBe('TERMS_NOT_ACCEPTED');

      const weak = await t
        .http()
        .post('/v1/auth/register')
        .send({ ...account, password: 'short' })
        .expect(400);
      expect(weak.body.code).toBe('PASSWORD_TOO_WEAK');

      await t.http().post('/v1/auth/register').send(account).expect(201);
      const dup = await t
        .http()
        .post('/v1/auth/register')
        .send(account)
        .expect(409);
      expect(dup.body.code).toBe('EMAIL_TAKEN');
    });

    it('resets a forgotten password by email, once, and ends old sessions', async () => {
      const reg = await t
        .http()
        .post('/v1/auth/register')
        .send(account)
        .expect(201);
      await t
        .http()
        .post('/v1/auth/password/reset-request')
        .send({ email: account.email })
        .expect(202);
      // Unknown emails get the same answer and no email.
      await t
        .http()
        .post('/v1/auth/password/reset-request')
        .send({ email: 'ghost@example.com' })
        .expect(202);
      expect(t.mail.sent).toHaveLength(1);
      expect(t.mail.sent[0]!.subject).toBe('استعادة كلمة مرور Belle Biens');

      const token = /token=([\w-]+)/.exec(t.mail.sent[0]!.text)![1]!;
      await t
        .http()
        .post('/v1/auth/password/reset')
        .send({ token, newPassword: 'new-damask-rose' })
        .expect(204);
      const reused = await t
        .http()
        .post('/v1/auth/password/reset')
        .send({ token, newPassword: 'another-one-1' })
        .expect(400);
      expect(reused.body.code).toBe('RESET_TOKEN_INVALID');

      await t
        .http()
        .post('/v1/auth/login')
        .send({ email: account.email, password: account.password })
        .expect(401);
      await t
        .http()
        .post('/v1/auth/login')
        .send({ email: account.email, password: 'new-damask-rose' })
        .expect(200);
      await t
        .http()
        .post('/v1/auth/refresh')
        .send({ refreshToken: reg.body.refreshToken })
        .expect(401);
    });

    it('reset links expire after 30 minutes', async () => {
      await t.http().post('/v1/auth/register').send(account).expect(201);
      await t
        .http()
        .post('/v1/auth/password/reset-request')
        .send({ email: account.email })
        .expect(202);
      const token = /token=([\w-]+)/.exec(t.mail.sent[0]!.text)![1]!;
      t.clock.advance({ minutes: 31 });
      await t
        .http()
        .post('/v1/auth/password/reset')
        .send({ token, newPassword: 'new-damask-rose' })
        .expect(400);
    });
  });

  describe('Google (EI-SW-06)', () => {
    it('creates an account, then links to an existing account with the same verified email', async () => {
      t.google.identities.set('token-new', {
        sub: 'g-1',
        email: 'new@gmail.com',
        emailVerified: true,
        name: 'Nour',
      });
      const created = await t
        .http()
        .post('/v1/auth/google')
        .send({ idToken: 'token-new', acceptTerms: true })
        .expect(200);
      expect(created.body).toMatchObject({
        isNewUser: true,
        user: { name: 'Nour', email: 'new@gmail.com', termsAccepted: true },
      });

      const existing = await t.prisma.user.create({
        data: { name: 'Huda', email: 'huda@gmail.com' },
      });
      t.google.identities.set('token-huda', {
        sub: 'g-2',
        email: 'huda@gmail.com',
        emailVerified: true,
      });
      const linked = await t
        .http()
        .post('/v1/auth/google')
        .send({ idToken: 'token-huda' })
        .expect(200);
      expect(linked.body).toMatchObject({
        isNewUser: false,
        user: { id: existing.id },
      });
    });

    it('rejects bad tokens and reports when Google sign-in is off', async () => {
      const bad = await t
        .http()
        .post('/v1/auth/google')
        .send({ idToken: 'forged' })
        .expect(401);
      expect(bad.body.code).toBe('GOOGLE_TOKEN_INVALID');
      t.google.enabled = false;
      const off = await t
        .http()
        .post('/v1/auth/google')
        .send({ idToken: 'forged' })
        .expect(503);
      expect(off.body.code).toBe('GOOGLE_SIGN_IN_UNAVAILABLE');
    });
  });

  describe('profile and devices', () => {
    it('updates language, digits and consent (FR-ACC-03, FR-LOC-02, FR-NTF-05)', async () => {
      const signIn = await signUpByPhone({ name: 'لين', acceptTerms: true });
      const res = await t
        .http()
        .patch('/v1/me')
        .set('Authorization', `Bearer ${signIn.body.accessToken}`)
        .send({
          language: 'en',
          numerals: 'arabic',
          marketingOptIn: false,
          homeArea: 'المزة',
        })
        .expect(200);
      expect(res.body).toMatchObject({
        language: 'en',
        numerals: 'arabic',
        marketingOptIn: false,
        homeArea: 'المزة',
      });
    });

    it('rejects fields the client must not set, such as the role (NFR-SEC-06)', async () => {
      const signIn = await signUpByPhone();
      const res = await t
        .http()
        .patch('/v1/me')
        .set('Authorization', `Bearer ${signIn.body.accessToken}`)
        .send({ role: 'OWNER' })
        .expect(400);
      expect(res.body.code).toBe('VALIDATION_FAILED');
      expect(res.body.errors).toContain('property role should not exist');
    });

    it('registers a push token for a guest, then moves it to the signed-in user', async () => {
      const device = {
        platform: 'android',
        pushToken: 'fcm-token-1234567890',
        appVersion: '1.0.0+1',
      };
      await t.http().put('/v1/me/devices').send(device).expect(204);
      expect((await t.prisma.device.findFirstOrThrow()).userId).toBeNull();

      const signIn = await signUpByPhone();
      await t
        .http()
        .put('/v1/me/devices')
        .set('Authorization', `Bearer ${signIn.body.accessToken}`)
        .send(device)
        .expect(204);
      expect((await t.prisma.device.findFirstOrThrow()).userId).toBe(
        signIn.body.user.id,
      );

      await t
        .http()
        .delete(`/v1/me/devices/${device.pushToken}`)
        .set('Authorization', `Bearer ${signIn.body.accessToken}`)
        .expect(204);
      expect((await t.prisma.device.findFirstOrThrow()).userId).toBeNull();
    });
  });

  describe('roles (FR-ADM-01, NFR-SEC-01) and audit log (FR-ADM-09, NFR-SEC-12)', () => {
    it('only the owner changes roles, and every change is in the audit log', async () => {
      const owner = await t.signInAs('OWNER');
      const manager = await t.signInAs('MANAGER');
      const customer = await t.signInAs('CUSTOMER');

      const denied = await t
        .http()
        .patch(`/v1/admin/users/${customer.id}/role`)
        .set('Authorization', `Bearer ${manager.token}`)
        .send({ role: 'FLORIST' })
        .expect(403);
      expect(denied.body.code).toBe('FORBIDDEN');

      const ok = await t
        .http()
        .patch(`/v1/admin/users/${customer.id}/role`)
        .set('Authorization', `Bearer ${owner.token}`)
        .send({ role: 'FLORIST' })
        .expect(200);
      expect(ok.body.role).toBe('FLORIST');

      const entries = await t.prisma.auditLog.findMany({
        where: { entityId: customer.id },
      });
      expect(entries).toHaveLength(1);
      expect(entries[0]).toMatchObject({
        actorId: owner.id,
        actorRole: 'OWNER',
        action: 'user.role.change',
        before: { role: 'CUSTOMER' },
        after: { role: 'FLORIST' },
      });
    });

    it('the new role applies on the next call, without a new token', async () => {
      const owner = await t.signInAs('OWNER');
      const target = await t.signInAs('CUSTOMER');
      await t
        .http()
        .get('/v1/admin/audit-log')
        .set('Authorization', `Bearer ${target.token}`)
        .expect(403);
      await t
        .http()
        .patch(`/v1/admin/users/${target.id}/role`)
        .set('Authorization', `Bearer ${owner.token}`)
        .send({ role: 'MANAGER' })
        .expect(200);
      await t
        .http()
        .get('/v1/admin/audit-log')
        .set('Authorization', `Bearer ${target.token}`)
        .expect(200);
    });

    it('owners cannot change their own role', async () => {
      const owner = await t.signInAs('OWNER');
      await t
        .http()
        .patch(`/v1/admin/users/${owner.id}/role`)
        .set('Authorization', `Bearer ${owner.token}`)
        .send({ role: 'CUSTOMER' })
        .expect(403);
    });

    it('the audit log cannot be edited or deleted, even directly in the database', async () => {
      const owner = await t.signInAs('OWNER');
      const target = await t.signInAs('CUSTOMER');
      await t
        .http()
        .patch(`/v1/admin/users/${target.id}/role`)
        .set('Authorization', `Bearer ${owner.token}`)
        .send({ role: 'FLORIST' })
        .expect(200);
      const entry = await t.prisma.auditLog.findFirstOrThrow({
        where: { entityId: target.id },
      });

      await expect(
        t.prisma.auditLog.update({
          where: { id: entry.id },
          data: { action: 'tampered' },
        }),
      ).rejects.toThrow(/append-only/);
      await expect(
        t.prisma.auditLog.delete({ where: { id: entry.id } }),
      ).rejects.toThrow(/append-only/);
      await expect(
        t.prisma.$executeRawUnsafe('TRUNCATE audit_log'),
      ).rejects.toThrow(/append-only/);
    });

    it('the role matrix on audit-log: owner and manager may view, other staff may not', async () => {
      for (const [role, status] of [
        ['OWNER', 200],
        ['MANAGER', 200],
        ['FLORIST', 403],
        ['DELIVERY_COORDINATOR', 403],
        ['CUSTOMER', 403],
      ] as const) {
        const user = await t.signInAs(role);
        await t
          .http()
          .get('/v1/admin/audit-log')
          .set('Authorization', `Bearer ${user.token}`)
          .expect(status);
      }
    });
  });
});
