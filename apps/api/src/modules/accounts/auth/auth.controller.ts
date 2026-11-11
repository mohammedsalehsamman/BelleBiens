import {
  Body,
  Controller,
  HttpCode,
  HttpStatus,
  Post,
  Req,
} from '@nestjs/common';
import {
  ApiAcceptedResponse,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import type { Request } from 'express';
import { pickLanguage } from '../../../common/errors/error-codes.js';
import { AuthRateLimited, Public } from './auth.decorators.js';
import { AuthService } from './auth.service.js';
import {
  AuthSessionDto,
  GoogleSignInDto,
  LoginDto,
  OtpRequestedDto,
  PasswordResetConfirmDto,
  PasswordResetRequestDto,
  RefreshDto,
  RegisterDto,
  RequestOtpDto,
  VerifyOtpDto,
} from './dto/auth.dto.js';
import { OtpService } from './otp.service.js';

@ApiTags('auth')
@Public()
@AuthRateLimited()
@Controller('auth')
export class AuthController {
  constructor(
    private readonly auth: AuthService,
    private readonly otp: OtpService,
  ) {}

  @Post('otp/request')
  @HttpCode(HttpStatus.ACCEPTED)
  @ApiOperation({
    summary: 'Send a sign-in code by SMS or WhatsApp (screens 02, 03)',
  })
  @ApiAcceptedResponse({ type: OtpRequestedDto })
  requestOtp(
    @Body() dto: RequestOtpDto,
    @Req() req: Request,
  ): Promise<OtpRequestedDto> {
    return this.otp.request(dto.phone, dto.channel ?? 'sms', language(req));
  }

  @Post('otp/verify')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary:
      'Check the code and sign in; creates the account on first use (screen 04)',
  })
  @ApiOkResponse({ type: AuthSessionDto })
  verifyOtp(
    @Body() dto: VerifyOtpDto,
    @Req() req: Request,
  ): Promise<AuthSessionDto> {
    return this.auth.signInWithOtp(dto, language(req));
  }

  @Post('register')
  @ApiOperation({
    summary: 'Create an account with email and password (FR-ACC-01)',
  })
  @ApiCreatedResponse({ type: AuthSessionDto })
  register(
    @Body() dto: RegisterDto,
    @Req() req: Request,
  ): Promise<AuthSessionDto> {
    return this.auth.register(dto, language(req));
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Sign in with email and password' })
  @ApiOkResponse({ type: AuthSessionDto })
  login(@Body() dto: LoginDto): Promise<AuthSessionDto> {
    return this.auth.login(dto);
  }

  @Post('google')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Sign in with a Google ID token (EI-SW-06)' })
  @ApiOkResponse({ type: AuthSessionDto })
  google(
    @Body() dto: GoogleSignInDto,
    @Req() req: Request,
  ): Promise<AuthSessionDto> {
    return this.auth.signInWithGoogle(dto, language(req));
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary:
      'Exchange a refresh token for a new pair (the old one stops working)',
  })
  @ApiOkResponse({ type: AuthSessionDto })
  refresh(@Body() dto: RefreshDto): Promise<AuthSessionDto> {
    return this.auth.refresh(dto.refreshToken);
  }

  @Post('logout')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'End the session of this refresh token' })
  @ApiNoContentResponse()
  async logout(@Body() dto: RefreshDto): Promise<void> {
    await this.auth.logout(dto.refreshToken);
  }

  @Post('password/reset-request')
  @HttpCode(HttpStatus.ACCEPTED)
  @ApiOperation({
    summary: 'Email a password reset link (FR-ACC-02). Always 202.',
  })
  @ApiAcceptedResponse()
  async requestReset(@Body() dto: PasswordResetRequestDto): Promise<void> {
    await this.auth.requestPasswordReset(dto.email);
  }

  @Post('password/reset')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Set a new password with the emailed token; ends all sessions',
  })
  @ApiNoContentResponse()
  async confirmReset(@Body() dto: PasswordResetConfirmDto): Promise<void> {
    await this.auth.confirmPasswordReset(dto.token, dto.newPassword);
  }
}

function language(req: Request): 'ar' | 'en' {
  return pickLanguage(req.headers['accept-language']);
}
