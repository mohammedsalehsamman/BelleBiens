import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Patch,
  Put,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { AppError } from '../../../common/errors/app-error.js';
import { type AuthUser, CurrentUser, Public } from '../auth/auth.decorators.js';
import { MeDto, RegisterDeviceDto, UpdateMeDto } from './dto/me.dto.js';
import { MeService } from './me.service.js';

@ApiTags('me')
@ApiBearerAuth()
@Controller('me')
export class MeController {
  constructor(private readonly me: MeService) {}

  @Get()
  @ApiOperation({ summary: 'The signed-in profile' })
  @ApiOkResponse({ type: MeDto })
  get(@CurrentUser() user: AuthUser): Promise<MeDto> {
    return this.me.get(user.id);
  }

  @Patch()
  @ApiOperation({
    summary:
      'Edit name, email, language, digits, marketing consent (FR-ACC-03)',
  })
  @ApiOkResponse({ type: MeDto })
  update(
    @CurrentUser() user: AuthUser,
    @Body() dto: UpdateMeDto,
  ): Promise<MeDto> {
    return this.me.update(user.id, dto);
  }

  /** Public so a guest's phone can receive notifications for its orders. */
  @Public()
  @Put('devices')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Register this phone for push notifications (EI-SW-09)',
  })
  @ApiNoContentResponse()
  async registerDevice(
    @CurrentUser() user: AuthUser | undefined,
    @Body() dto: RegisterDeviceDto,
  ): Promise<void> {
    await this.me.registerDevice(user?.id, dto);
  }

  @Delete('devices/:pushToken')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Stop sending this account notifications to this phone',
  })
  @ApiNoContentResponse()
  async removeDevice(
    @CurrentUser() user: AuthUser,
    @Param('pushToken') pushToken: string,
  ): Promise<void> {
    if (pushToken.length > 4096) throw new AppError('BAD_REQUEST');
    await this.me.removeDevice(user.id, pushToken);
  }
}
