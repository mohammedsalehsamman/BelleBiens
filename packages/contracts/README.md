# @belle/contracts

The single source of truth shared by the API (NestJS), the Flutter app and, later, the website (NFR-MNT-03, NFR-MNT-04).

| Path | What it is | Who must pass it |
|---|---|---|
| `schemas/bouquet-spec.v1.json` | SRS Appendix B as JSON Schema 2020-12 | API (Ajv), app (`json_schema`) |
| `schemas/box-spec.v1.json` | Split box spec (FR-BOX-03) | API, app |
| `examples/specs.json` | Specs the schemas must accept or reject | API, app |
| `vectors/pricing.json` | Price pipeline cases (diagram 9), including the README cart: 7,266 SYP / $60.55 | API pricing module, app `PricingEstimator` |
| `vectors/arabic-normalize.json` | Search normalization (FR-CAT-04) | API search, app offline search |
| `vectors/phone.json` | Phone validation to E.164 (FR-CRT-09) | API, app |
| `vectors/spec-hash.json` | Spec hash for AI preview cache (FR-DAI-06). Generated | API, app |
| `openapi.yaml` | Exported from the API (from S1). CI fails if it drifts | Dart and TS clients |

Planned (added in their sprint): `vectors/layout.json` (S3, FR-D2D-03), `vectors/delivery-calendar.json` (S5, FR-DLV-03/05/09).

## Commands

```bash
pnpm --filter @belle/contracts test            # validates schemas and proves every vector with src/reference.mjs
pnpm --filter @belle/contracts vectors:update  # regenerates spec-hash.json after changing examples
```

`src/reference.mjs` only proves the vectors are self-consistent. The API and the app keep their own implementations and must reproduce every vector exactly.

## Changing a contract

A change to a schema or a vector is a change to the requirements it encodes: update the SRS reference in the PR, bump `schemaVersion` for a breaking spec change (the server rejects unknown versions), and update both implementations in the same PR.
