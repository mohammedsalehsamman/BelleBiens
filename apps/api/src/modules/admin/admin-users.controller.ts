import {
  Body,
  Controller,
  Get,
  Param,
  ParseUUIDPipe,
  Patch,
  Query,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiProperty,
  ApiPropertyOptional,
  ApiTags,
} from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { AppError } from '../../common/errors/app-error.js';
import type { Role } from '../../generated/prisma/client.js';
import { PrismaService } from '../../infra/prisma/prisma.service.js';
import {
  type AuthUser,
  CurrentUser,
  Roles,
} from '../accounts/auth/auth.decorators.js';
import { MeDto } from '../accounts/me/dto/me.dto.js';
import { AuditService } from '../audit/audit.service.js';

const ROLES = [
  'CUSTOMER',
  'OWNER',
  'MANAGER',
  'FLORIST',
  'DELIVERY_COORDINATOR',
] as const;

export class ChangeRoleDto {
  @ApiProperty({ enum: ROLES })
  @IsIn(ROLES)
  role!: Role;
}

export class AuditQueryDto {
  @ApiPropertyOptional({ example: 'user' })
  @IsOptional()
  @IsString()
  @MaxLength(40)
  entity?: string;

  @ApiPropertyOptional({ example: 50, maximum: 200 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(200)
  limit?: number;
}

export class AuditEntryDto {
  @ApiProperty() id!: string;
  @ApiProperty({ nullable: true, type: String }) actorId!: string | null;
  @ApiProperty({ nullable: true, enum: ROLES }) actorRole!: Role | null;
  @ApiProperty({ example: 'user.role.change' }) action!: string;
  @ApiProperty({ example: 'user' }) entity!: string;
  @ApiProperty({ nullable: true, type: String }) entityId!: string | null;
  @ApiProperty({ nullable: true, type: Object }) before!: unknown;
  @ApiProperty({ nullable: true, type: Object }) after!: unknown;
  @ApiProperty() createdAt!: Date;
}

/** Staff administration. Permissions follow the table in design diagram 13 (to be confirmed by the shop). */
@ApiTags('admin')
@ApiBearerAuth()
@Controller('admin')
export class AdminUsersController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  /** Users and roles: Owner only. */
  @Patch('users/:id/role')
  @Roles('OWNER')
  @ApiOperation({ summary: 'Change a user role (Owner only, audited)' })
  @ApiOkResponse({ type: MeDto })
  async changeRole(
    @CurrentUser() actor: AuthUser,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: ChangeRoleDto,
  ): Promise<MeDto> {
    if (id === actor.id) {
      // An owner cannot demote themselves and leave the shop without an owner.
      throw new AppError('FORBIDDEN', { detail: 'cannot_change_own_role' });
    }
    const updated = await this.prisma.$transaction(async (tx) => {
      const before = await tx.user.findUnique({
        where: { id },
        select: { role: true },
      });
      if (!before) throw new AppError('NOT_FOUND');
      const user = await tx.user.update({
        where: { id },
        data: { role: dto.role },
      });
      await this.audit.record(
        {
          actor,
          action: 'user.role.change',
          entity: 'user',
          entityId: id,
          before: { role: before.role },
          after: { role: dto.role },
        },
        tx,
      );
      return user;
    });
    return MeDto.from(updated);
  }

  /** Audit log: Owner full access, Manager view only (diagram 13). */
  @Get('audit-log')
  @Roles('OWNER', 'MANAGER')
  @ApiOperation({ summary: 'Latest audit log entries (FR-ADM-09)' })
  @ApiOkResponse({ type: [AuditEntryDto] })
  async auditLog(@Query() query: AuditQueryDto): Promise<AuditEntryDto[]> {
    return this.prisma.auditLog.findMany({
      where: query.entity ? { entity: query.entity } : undefined,
      orderBy: { createdAt: 'desc' },
      take: query.limit ?? 50,
    });
  }
}
