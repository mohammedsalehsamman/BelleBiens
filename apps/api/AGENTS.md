# AGENTS.md (apps/api)

Notes for anyone, human or AI, changing this service. The plan is in `docs/plan/mobile-and-backend-plan.md`, and the decisions are in `docs/adr`.

## Stack facts that differ from older NestJS projects

- NestJS 12, ESM only: relative imports end in `.js`, there is no `__dirname` (use `import.meta.dirname`), and tests run on Vitest (`vi.fn()`, not `jest.fn()`). Docs index: https://docs.nestjs.com/llms.txt
- Prisma 7 with the `@prisma/adapter-pg` driver adapter. The client is generated into `src/generated/prisma` on install. Do not edit it.
- Check Nest's first-party packages before adding a library, for example `@nestjs/throttler`, `@nestjs/bullmq`, `@nestjs/schedule`, `@nestjs/idempotency` and `@nestjs/webhooks`. Any new dependency needs a line in the matching ADR.
- `tsx` does not emit decorator metadata. Scripts that boot the Nest app run from `nest build` output (see `openapi:export`).

## Project rules

- Observability is pino structured logs plus Sentry (NFR-MNT-05, ADR 0002). Do not add other telemetry services without a new ADR.
- Errors: `AppError(code)` gives problem+json with Arabic and English titles. Time: inject `Clock`. Money: integers in minor units (ADR 0011).
- Clients never send prices (NFR-SEC-06): DTOs reject unknown fields.
- Shared behaviour (pricing, Arabic search normalization, phone, spec hash, layout) must pass the vectors in `packages/contracts/vectors`.
- After changing routes or DTOs, run `pnpm openapi:export` and commit `packages/contracts/openapi.yaml`.
