# The Belle Biens API (plan 3.8). Build from the repository root:
#   docker build -f apps/api/Dockerfile -t belle-api .
# Targets: `runtime` (default) serves the API; `migrate` applies the Prisma
# migrations before a release (`prisma migrate deploy`, staging first).

FROM node:24.15.0-bookworm-slim AS base
ENV PNPM_HOME=/pnpm PATH=/pnpm:$PATH
RUN corepack enable
WORKDIR /repo

FROM base AS build
COPY . .
# The API and what it needs from the workspace (packages/contracts).
RUN pnpm install --frozen-lockfile --filter "@belle/api..."
RUN pnpm --filter @belle/api build
# Production dependencies only; the Prisma client is already compiled into
# dist (src/generated), so no install scripts run here.
RUN pnpm deploy --filter @belle/api --prod --legacy --ignore-scripts /out \
 && rm -rf /out/dist && cp -r apps/api/dist /out/dist

FROM build AS migrate
WORKDIR /repo/apps/api
CMD ["pnpm", "exec", "prisma", "migrate", "deploy"]

FROM node:24.15.0-bookworm-slim AS runtime
ENV NODE_ENV=production PORT=3000
WORKDIR /app
COPY --from=build --chown=node:node /out .
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:'+process.env.PORT+'/v1/health').then(r=>process.exit(r.ok?0:1),()=>process.exit(1))"
CMD ["node", "dist/main.js"]
