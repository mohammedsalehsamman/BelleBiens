import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  Equals,
  IsBoolean,
  IsEmail,
  IsIn,
  IsOptional,
  IsString,
  MaxLength,
  MinLength,
} from 'class-validator';
import type { User } from '../../../../generated/prisma/client.js';

const ROLES = [
  'CUSTOMER',
  'OWNER',
  'MANAGER',
  'FLORIST',
  'DELIVERY_COORDINATOR',
] as const;

/** The signed-in user's profile (FR-ACC-03). */
export class MeDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ example: 'سارة الأحمد' }) name!: string;
  @ApiProperty({ nullable: true, type: String, example: '+963944123456' })
  phone!: string | null;
  @ApiProperty({ nullable: true, type: String, example: 'sara@example.com' })
  email!: string | null;
  @ApiProperty({ enum: ROLES }) role!: (typeof ROLES)[number];
  @ApiProperty({ enum: ['ar', 'en'] }) language!: 'ar' | 'en';
  @ApiProperty({ enum: ['western', 'arabic'], description: 'FR-LOC-02' })
  numerals!: 'western' | 'arabic';
  @ApiProperty({ description: 'FR-NTF-05: "ورد اليوم والعروض"' })
  marketingOptIn!: boolean;
  @ApiProperty({ description: 'Occasion reminders (screen 33)' })
  notifyOccasions!: boolean;
  @ApiProperty({
    description: 'Order messages on WhatsApp; SMS when off (screen 33)',
  })
  notifyWhatsapp!: boolean;
  @ApiProperty({ nullable: true, type: String, example: 'أبو رمانة' })
  homeArea!: string | null;
  @ApiProperty({
    description: 'Terms of use and privacy policy accepted (LEG-01)',
  })
  termsAccepted!: boolean;
  @ApiProperty({
    description: 'False until a name is set; the app asks for it once',
  })
  profileComplete!: boolean;
  @ApiProperty() createdAt!: Date;

  static from(user: User): MeDto {
    return {
      id: user.id,
      name: user.name,
      phone: user.phone,
      email: user.email,
      role: user.role,
      language: user.language,
      numerals: user.numerals,
      marketingOptIn: user.marketingOptIn,
      notifyOccasions: user.notifyOccasions,
      notifyWhatsapp: user.notifyWhatsapp,
      homeArea: user.homeArea,
      termsAccepted: user.termsAcceptedAt !== null,
      profileComplete:
        user.name.trim().length > 0 && user.termsAcceptedAt !== null,
      createdAt: user.createdAt,
    };
  }
}

export class UpdateMeDto {
  @ApiPropertyOptional({ example: 'سارة الأحمد' })
  @IsOptional()
  @IsString()
  @MinLength(1)
  @MaxLength(80)
  name?: string;

  @ApiPropertyOptional({ example: 'sara@example.com' })
  @IsOptional()
  @IsEmail()
  @MaxLength(254)
  email?: string;

  @ApiPropertyOptional({ enum: ['ar', 'en'] })
  @IsOptional()
  @IsIn(['ar', 'en'])
  language?: 'ar' | 'en';

  @ApiPropertyOptional({ enum: ['western', 'arabic'] })
  @IsOptional()
  @IsIn(['western', 'arabic'])
  numerals?: 'western' | 'arabic';

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  marketingOptIn?: boolean;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  notifyOccasions?: boolean;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  notifyWhatsapp?: boolean;

  @ApiPropertyOptional({ example: 'المزة' })
  @IsOptional()
  @IsString()
  @MaxLength(60)
  homeArea?: string;

  @ApiPropertyOptional({
    description: 'Send true to accept the terms (only true is allowed)',
  })
  @IsOptional()
  @Equals(true)
  acceptTerms?: true;
}

export class RegisterDeviceDto {
  @ApiProperty({ enum: ['android', 'ios'] })
  @IsIn(['android', 'ios'])
  platform!: 'android' | 'ios';

  @ApiProperty({ description: 'FCM registration token' })
  @IsString()
  @MinLength(10)
  @MaxLength(4096)
  pushToken!: string;

  @ApiPropertyOptional({ example: '1.0.0+1' })
  @IsOptional()
  @IsString()
  @MaxLength(32)
  appVersion?: string;

  @ApiPropertyOptional({ enum: ['ar', 'en'] })
  @IsOptional()
  @IsIn(['ar', 'en'])
  locale?: 'ar' | 'en';
}
