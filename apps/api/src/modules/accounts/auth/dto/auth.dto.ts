import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsEmail,
  IsIn,
  IsOptional,
  IsString,
  Matches,
  MaxLength,
  MinLength,
} from 'class-validator';
import { MeDto } from '../../me/dto/me.dto.js';

const PHONE_EXAMPLE = '0944123456';

export class RequestOtpDto {
  @ApiProperty({
    example: PHONE_EXAMPLE,
    description: '09XXXXXXXX, +9639XXXXXXXX or international (FR-CRT-09)',
  })
  @IsString()
  @MaxLength(32)
  phone!: string;

  @ApiPropertyOptional({
    enum: ['sms', 'whatsapp'],
    default: 'sms',
    description: 'Screen 04 offers WhatsApp instead of SMS',
  })
  @IsOptional()
  @IsIn(['sms', 'whatsapp'])
  channel?: 'sms' | 'whatsapp';
}

export class OtpRequestedDto {
  @ApiProperty({ example: '+963944123456' }) phone!: string;
  @ApiProperty({ example: '+963 944 *** 456' }) maskedPhone!: string;
  @ApiProperty({ enum: ['sms', 'whatsapp'] }) channel!: 'sms' | 'whatsapp';
  @ApiProperty({ example: 4 }) codeLength!: number;
  @ApiProperty({ example: 300 }) expiresInSeconds!: number;
  @ApiProperty({ example: 60 }) resendAfterSeconds!: number;
}

/** Profile fields a new customer fills on the register screen (03). Ignored for existing accounts. */
class NewAccountFields {
  @ApiPropertyOptional({ example: 'سارة الأحمد' })
  @IsOptional()
  @IsString()
  @MaxLength(80)
  name?: string;

  @ApiPropertyOptional({ example: 'sara@example.com' })
  @IsOptional()
  @IsEmail()
  @MaxLength(254)
  email?: string;

  @ApiPropertyOptional({ example: 'أبو رمانة' })
  @IsOptional()
  @IsString()
  @MaxLength(60)
  homeArea?: string;

  @ApiPropertyOptional({ description: 'FR-NTF-05' })
  @IsOptional()
  @IsBoolean()
  marketingOptIn?: boolean;

  @ApiPropertyOptional({
    description: 'Terms of use and privacy policy (LEG-01)',
  })
  @IsOptional()
  @IsBoolean()
  acceptTerms?: boolean;
}

export class VerifyOtpDto extends NewAccountFields {
  @ApiProperty({ example: PHONE_EXAMPLE })
  @IsString()
  @MaxLength(32)
  phone!: string;

  @ApiProperty({ example: '4827' })
  @Matches(/^\d{4,8}$/)
  code!: string;
}

export class RegisterDto {
  @ApiProperty({ example: 'سارة الأحمد' })
  @IsString()
  @MinLength(1)
  @MaxLength(80)
  name!: string;

  @ApiProperty({ example: 'sara@example.com' })
  @IsEmail()
  @MaxLength(254)
  email!: string;

  @ApiProperty({ minLength: 8, description: 'NFR-SEC-02' })
  @IsString()
  @MaxLength(128)
  password!: string;

  @ApiProperty({ description: 'Must be true (LEG-01)' })
  @IsBoolean()
  acceptTerms!: boolean;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  marketingOptIn?: boolean;
}

export class LoginDto {
  @ApiProperty({ example: 'sara@example.com' })
  @IsEmail()
  @MaxLength(254)
  email!: string;

  @ApiProperty()
  @IsString()
  @MaxLength(128)
  password!: string;
}

export class GoogleSignInDto extends NewAccountFields {
  @ApiProperty({ description: 'ID token from Google Sign-In on the device' })
  @IsString()
  @MaxLength(4096)
  idToken!: string;
}

export class RefreshDto {
  @ApiProperty()
  @IsString()
  @MaxLength(128)
  refreshToken!: string;
}

export class PasswordResetRequestDto {
  @ApiProperty({ example: 'sara@example.com' })
  @IsEmail()
  @MaxLength(254)
  email!: string;
}

export class PasswordResetConfirmDto {
  @ApiProperty()
  @IsString()
  @MaxLength(128)
  token!: string;

  @ApiProperty({ minLength: 8 })
  @IsString()
  @MaxLength(128)
  newPassword!: string;
}

export class AuthSessionDto {
  @ApiProperty() accessToken!: string;
  @ApiProperty({ example: 900, description: 'Seconds' })
  accessTokenExpiresIn!: number;
  @ApiProperty() refreshToken!: string;
  @ApiProperty() refreshTokenExpiresAt!: Date;
  @ApiProperty({ description: 'The account was created by this call' })
  isNewUser!: boolean;
  @ApiProperty({ type: MeDto }) user!: MeDto;
}
