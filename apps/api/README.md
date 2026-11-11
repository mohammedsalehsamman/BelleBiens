# @belle/api

The shared Belle Biens backend: one NestJS service split into domain modules (design diagram 6). All three clients use it through the versioned REST API under `/v1` (DC-01, EI-CM-02).

## Layout

```
src/
  main.ts                    server entry
  bootstrap/configure-app.ts prefix, helmet, ValidationPipe, problem+json filter, OpenAPI document
  config/env.schema.ts       every environment variable, validated with zod at startup
  common/clock/              Clock: the only way business code reads "now" (FixedClock in tests)
  common/errors/             stable error codes with Arabic and English text, problem+json filter
  infra/prisma/              Prisma 7 client over the pg adapter (connects lazily)
  modules/<module>/          domain modules: health now; accounts, catalog, designer, ... per sprint
  openapi/export-openapi.ts  writes packages/contracts/openapi.yaml
prisma/                      schema, migrations, seed
test/                        e2e tests (*.e2e-spec.ts)
```

## Commands

| Command | Does |
|---|---|
| `pnpm start:dev` | Run with reload. Swagger UI at `/docs` outside production |
| `pnpm test` / `pnpm test:cov` | Unit tests (Vitest), with a 70% coverage gate |
| `pnpm test:e2e` | HTTP tests against the real app module |
| `pnpm lint` / `pnpm typecheck` | oxlint (type-aware) / tsc |
| `pnpm prisma:migrate` | Create and apply a migration locally (needs the database from `pnpm infra:up`) |
| `pnpm prisma:deploy` / `pnpm seed` | Apply migrations / load development data |
| `pnpm openapi:export` | Regenerate the contract; CI fails if it differs from the committed file |

## Rules that apply to every module

- Errors: throw `AppError('<CODE>')`. Clients receive `application/problem+json` with `code` and a `title` in the caller's language (NFR-INT-05). Add new codes to `error-codes.ts` with both languages.
- Time: inject `Clock`. Never call `new Date()` in business code.
- Money: integers in minor units with a currency code (ADR 0011).
- Input: DTOs with class-validator. Unknown fields are rejected, so clients can never send prices (NFR-SEC-06).
- Logs: structured JSON. Authorization headers and cookies are redacted. Do not log names, phones or addresses (NFR-SEC-09).
