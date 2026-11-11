import { Injectable } from '@nestjs/common';
import type { Prisma, Role } from '../../generated/prisma/client.js';
import { Clock } from '../../common/clock/clock.js';
import { PrismaService } from '../../infra/prisma/prisma.service.js';

export interface AuditActor {
  id: string;
  role: Role;
}

export interface AuditEntry {
  actor: AuditActor | null;
  /** Verb in dotted form, for example "user.role.change" or "setting.update". */
  action: string;
  entity: string;
  entityId?: string;
  before?: Prisma.InputJsonValue;
  after?: Prisma.InputJsonValue;
}

/**
 * FR-ADM-09: records who changed prices, stock, order status, coupons and user roles,
 * and when. The table is append-only at the database level (NFR-SEC-12).
 * Pass the transaction client so the entry commits or rolls back with the change.
 */
@Injectable()
export class AuditService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
  ) {}

  async record(
    entry: AuditEntry,
    tx: Prisma.TransactionClient = this.prisma,
  ): Promise<void> {
    await tx.auditLog.create({
      data: {
        actorId: entry.actor?.id,
        actorRole: entry.actor?.role,
        action: entry.action,
        entity: entry.entity,
        entityId: entry.entityId,
        before: entry.before,
        after: entry.after,
        createdAt: this.clock.now(),
      },
    });
  }
}
