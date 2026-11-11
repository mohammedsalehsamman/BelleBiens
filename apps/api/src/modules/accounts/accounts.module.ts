import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import type { Env } from '../../config/env.schema.js';
import { AdminUsersController } from '../admin/admin-users.controller.js';
import { AuthController } from './auth/auth.controller.js';
import { AuthService } from './auth/auth.service.js';
import { OtpService } from './auth/otp.service.js';
import { PasswordService } from './auth/password.service.js';
import { TokenService } from './auth/token.service.js';
import { MeController } from './me/me.controller.js';
import { MeService } from './me/me.service.js';

@Module({
  imports: [
    JwtModule.registerAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService<Env, true>) => ({
        secret: config.get('JWT_ACCESS_SECRET', { infer: true }),
        signOptions: { algorithm: 'HS256' },
        verifyOptions: { algorithms: ['HS256'] },
      }),
    }),
  ],
  controllers: [AuthController, MeController, AdminUsersController],
  providers: [
    AuthService,
    OtpService,
    PasswordService,
    TokenService,
    MeService,
  ],
  exports: [TokenService],
})
export class AccountsModule {}
