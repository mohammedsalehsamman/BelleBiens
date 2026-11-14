# Security scan (OWASP ZAP)

An active scan of every endpoint in `packages/contracts/openapi.yaml` (plan 5.1, S8). It sends attacks, so run it only against a throwaway instance, never against a shared or production database.

```bash
# The API image on the Compose network with a throwaway database (see infra/k6/README.md)
docker run -d --name belle-api-load --network belle-biens_default --env-file apps/api/.env \
  -e DATABASE_URL=postgresql://belle:...@postgres:5432/belle_load?schema=public \
  -e NODE_ENV=staging -e JOBS_ENABLED=false -e REDIS_URL=redis://redis:6379 \
  -e RATE_LIMIT_PER_MINUTE=1000000 belle-api:dev

# From the repository root
mkdir -p zap-out && cp packages/contracts/openapi.yaml infra/zap/rules.tsv zap-out/
docker run --rm --network belle-biens_default -v "$PWD/zap-out:/zap/wrk:rw" \
  ghcr.io/zaproxy/zaproxy:stable zap-api-scan.py -t /zap/wrk/openapi.yaml -f openapi \
  -O http://belle-api-load:3000 -c rules.tsv -r report.html -I
```

`rules.tsv` lists the warnings we accept, with the reason.

## Results

2026-11-14 (S8), 122 rules:

- No failures.
- **Fixed:** a NUL character (`%00`) in a search or filter parameter made Postgres fail with a 500. Every path, query and body is now checked first and refused with `VALIDATION_FAILED` (`NoNullBytesPipe`).
- **Accepted:** `/v1/auth/google` answers 503 while no Google client id is set (`GOOGLE_CLIENT_IDS`); errors use `application/problem+json`, which ZAP does not expect.

Run it again against staging before release, signed in as a customer and as staff, to cover the endpoints behind a token.
