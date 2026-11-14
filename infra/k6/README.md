# Load tests (k6)

Two scripts for the performance requirements in plan section 5.4:

| Script | Requirement | What it does | Passes when |
|---|---|---|---|
| `browse.js` | NFR-PERF-06 | 100 customers at once for 2 minutes, 1 to 3 seconds on each screen: app config, home, the shop, a product, the designer catalog and a quote, a cart quote | p95 under 500 ms (each endpoint too), under 1% failed |
| `peak.js` | NFR-PERF-08 | The busiest hour, 500 visitors and 50 orders, run 10 times faster (6 minutes). Orders are real: pickup, cash, one iced latte | p95 under 500 ms (orders under 1 s), under 1% failed |

- `STRESS=1` takes the pauses out of `browse.js`, to find how much one API process can take.
- `SPEED=1` runs `peak.js` over a real hour.

## Run

`peak.js` places real orders, so use a database you can throw away. Run the API image next to Postgres on the Compose network: on Windows and macOS, going through Docker Desktop's port forwarding (`localhost:5433`, `host.docker.internal`) slows every database round trip under load and hides the real numbers.

```bash
# A load-test database next to the dev one
docker exec belle-biens-postgres-1 psql -U belle -d postgres -c "create database belle_load;"
cd apps/api
DATABASE_URL=postgresql://belle:...@localhost:5433/belle_load?schema=public \
  sh -c 'pnpm exec prisma migrate deploy && pnpm seed'

# The API image on the Compose network (from the repository root: docker build -f apps/api/Dockerfile -t belle-api:dev .)
# Each k6 user sends its own address in X-Forwarded-For, so the API trusts the
# Docker network and the general limit is lifted (all users come from one machine).
docker run -d --name belle-api-load --network belle-biens_default --env-file .env \
  -e DATABASE_URL=postgresql://belle:...@postgres:5432/belle_load?schema=public \
  -e NODE_ENV=staging -e JOBS_ENABLED=false -e REDIS_URL=redis://redis:6379 \
  -e RATE_LIMIT_PER_MINUTE=1000000 -e TRUST_PROXY="loopback, uniquelocal" -e LOG_LEVEL=warn \
  belle-api:dev

# From infra/k6
docker run --rm -i --network belle-biens_default -e BASE_URL=http://belle-api-load:3000 \
  -v "$PWD:/k6" grafana/k6:1.0.0 run /k6/browse.js
docker run --rm -i --network belle-biens_default -e BASE_URL=http://belle-api-load:3000 \
  -v "$PWD:/k6" grafana/k6:1.0.0 run /k6/peak.js
```

Run them again on staging before release; results go in the plan log (`docs/plan/mobile-and-backend-plan.md`, section 11).

## What we know (2026-11-14, one API process on a laptop)

- `browse.js`: about 60 requests a second, p95 23 ms. `peak.js`: p95 16 ms, orders p95 113 ms, all 50 orders placed.
- `STRESS=1`: one API process tops out at about 180 requests a second with p95 around 510 ms. The process is then at 100% of one core; the database pool is not the limit (10 or 30 connections give the same result).
- The heaviest calls are the product page and the cart quote: about 9 queries each, because every `include` is its own query.
