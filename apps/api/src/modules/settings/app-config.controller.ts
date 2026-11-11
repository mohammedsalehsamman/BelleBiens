import { Controller, Get } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  ApiOkResponse,
  ApiOperation,
  ApiProperty,
  ApiTags,
} from '@nestjs/swagger';
import { GoogleIdentityVerifier } from '../../adapters/identity/google-identity.js';
import type { Env } from '../../config/env.schema.js';
import { Public } from '../accounts/auth/auth.decorators.js';
import { SettingsService } from './settings.service.js';

class WorkingHoursDto {
  @ApiProperty({ example: '10:00' }) open!: string;
  @ApiProperty({ example: '24:00' }) close!: string;
}

class ShopConfigDto {
  @ApiProperty({ enum: ['open', 'busy', 'closed'], description: 'FR-ADM-12' })
  mode!: 'open' | 'busy' | 'closed';

  @ApiProperty({ type: WorkingHoursDto }) workingHours!: WorkingHoursDto;

  @ApiProperty({ nullable: true, type: String, example: '+963944000000' })
  whatsapp!: string | null;

  @ApiProperty({ example: 'Asia/Damascus' }) timeZone!: string;
}

class CurrencyConfigDto {
  @ApiProperty({ example: 'SYP' }) base!: 'SYP';
  @ApiProperty({
    example: '120',
    description: 'SYP per 1 USD, decimal string (FR-PAY-05)',
  })
  usdRate!: string;
}

class PaymentsConfigDto {
  @ApiProperty() cash!: boolean;
  @ApiProperty() shamcash!: boolean;
  @ApiProperty() stripe!: boolean;
}

class AuthConfigDto {
  @ApiProperty({ example: 4 }) otpLength!: number;
  @ApiProperty({ example: 60 }) otpResendSeconds!: number;
  @ApiProperty({ type: [String], example: ['sms', 'whatsapp'] })
  otpChannels!: string[];
  @ApiProperty({ description: 'Google sign-in is configured (EI-SW-06)' })
  google!: boolean;
}

class FeaturesConfigDto {
  @ApiProperty({ description: 'FR-D3D, release 3' }) designer3d!: boolean;
  @ApiProperty({ description: 'FR-DAI, release 3' }) aiPreview!: boolean;
}

export class AppConfigDto {
  @ApiProperty({
    example: '1.0.0',
    description: 'Older apps must update (NFR-CMP-01)',
  })
  minSupportedVersion!: string;

  @ApiProperty({ type: ShopConfigDto }) shop!: ShopConfigDto;
  @ApiProperty({ type: CurrencyConfigDto }) currency!: CurrencyConfigDto;
  @ApiProperty({ type: PaymentsConfigDto }) payments!: PaymentsConfigDto;
  @ApiProperty({ type: AuthConfigDto }) auth!: AuthConfigDto;
  @ApiProperty({ type: FeaturesConfigDto }) features!: FeaturesConfigDto;
}

@ApiTags('app')
@Controller('app')
export class AppConfigController {
  constructor(
    private readonly settings: SettingsService,
    private readonly config: ConfigService<Env, true>,
    private readonly google: GoogleIdentityVerifier,
  ) {}

  @Public()
  @Get('config')
  @ApiOperation({
    summary: 'Everything the app needs at start-up, in one call',
  })
  @ApiOkResponse({ type: AppConfigDto })
  async appConfig(): Promise<AppConfigDto> {
    const [mode, workingHours, whatsapp, usdRate, payments] = await Promise.all(
      [
        this.settings.get('shop.mode'),
        this.settings.get('shop.workingHours'),
        this.settings.get('shop.whatsapp'),
        this.settings.get('currency.usdRate'),
        this.settings.get('payments.enabled'),
      ],
    );
    return {
      minSupportedVersion: this.config.get('APP_MIN_SUPPORTED_VERSION', {
        infer: true,
      }),
      shop: { mode, workingHours, whatsapp, timeZone: 'Asia/Damascus' },
      currency: { base: 'SYP', usdRate },
      payments: { ...payments },
      auth: {
        otpLength: this.config.get('OTP_LENGTH', { infer: true }),
        otpResendSeconds: this.config.get('OTP_RESEND_SECONDS', {
          infer: true,
        }),
        otpChannels: ['sms', 'whatsapp'],
        google: this.google.enabled,
      },
      features: { designer3d: false, aiPreview: false },
    };
  }
}
