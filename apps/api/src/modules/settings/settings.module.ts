import { Global, Module } from '@nestjs/common';
import { AppConfigController } from './app-config.controller.js';
import { SettingsService } from './settings.service.js';

@Global()
@Module({
  controllers: [AppConfigController],
  providers: [SettingsService],
  exports: [SettingsService],
})
export class SettingsModule {}
