import { parsePhoneNumberFromString } from 'libphonenumber-js/max';

/**
 * Normalizes a phone number to E.164, or returns null when it is not valid
 * (FR-CRT-09). Must agree with packages/contracts/vectors/phone.json, which the
 * app also passes:
 * - Arabic-Indic digits become 0..9; spaces, dashes, dots and brackets are dropped.
 * - A leading 00 becomes +. Numbers without + are read as Syrian.
 * - Syrian numbers must be mobiles: +9639 followed by 8 digits.
 */
export function normalizePhone(input: string): string | null {
  let s = input
    .replace(/[٠-٩]/g, (d) => String(d.charCodeAt(0) - 0x0660))
    .replace(/[۰-۹]/g, (d) => String(d.charCodeAt(0) - 0x06f0))
    .replace(/[\s\-.()]/g, '');
  if (s.startsWith('00')) s = `+${s.slice(2)}`;
  if (!/^\+?\d+$/.test(s)) return null;

  const parsed = parsePhoneNumberFromString(s, 'SY');
  if (!parsed?.isValid()) return null;

  const e164 = parsed.number;
  if (e164.startsWith('+963') && !/^\+9639\d{8}$/.test(e164)) return null;
  return e164;
}

/** "+963944123456" -> "+963 944 *** 456", as shown on the OTP screen (04). */
export function maskPhone(e164: string): string {
  if (e164.startsWith('+963') && e164.length === 13) {
    return `+963 ${e164.slice(4, 7)} *** ${e164.slice(10)}`;
  }
  const visible = 3;
  return `${e164.slice(0, e164.length - visible - 3).replace(/\d/g, '*')}${'***'}${e164.slice(-visible)}`;
}
