# Belle Biens Platform

Monorepo for the Belle Biens platform (BB-SRS-001): the shared backend API and the customer mobile app. The website and the admin dashboard get their own plan later.

| Path | What it is |
|---|---|
| [apps/api](apps/api) | NestJS 12 API on PostgreSQL (Prisma 7) and Redis |
| [apps/mobile](apps/mobile) | Flutter app for Android 9+ and iOS 15+ |
| [packages/contracts](packages/contracts) | OpenAPI, JSON Schemas and shared test vectors |
| [infra](infra) | Local services (docker compose) and load tests |
| [docs](docs) | Plan, ADRs, SRS, design diagrams, HTML screen designs |

The plan is in [docs/plan/mobile-and-backend-plan.md](docs/plan/mobile-and-backend-plan.md), and the decisions are in [docs/adr](docs/adr).

## Requirements

Node 24, pnpm 10, Flutter 3.47 (Dart 3.13), Docker Desktop, and the Android SDK. iOS builds run on Codemagic.

## First run

```bash
pnpm install                       # also generates the Prisma client
pnpm infra:up                      # Postgres, Redis, SeaweedFS (S3), Mailpit (Docker must be running)
cp apps/api/.env.example apps/api/.env
pnpm api prisma:deploy             # apply migrations
pnpm api seed
pnpm api start:dev                 # http://localhost:3000/v1/health, docs at http://localhost:3000/docs

cd apps/mobile
flutter pub get
dart run build_runner build -d
flutter run --flavor dev --dart-define-from-file=env/dev.json
```

## Checks (the same ones CI runs)

```bash
pnpm contracts test                          # schemas and vectors
pnpm api lint && pnpm api typecheck
pnpm api test && pnpm api test:e2e
pnpm api openapi:export                      # then: git diff packages/contracts/openapi.yaml
cd apps/mobile && flutter analyze && flutter test
```
