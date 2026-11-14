#!/bin/sh
# The quarterly restore test (NFR-REL-02): the newest backup is decrypted and
# restored into a scratch database, checked, and the scratch database dropped.
#   DATABASE_URL        any database on the server, to create the scratch one
#   BACKUP_AGE_IDENTITY path to the age private key file
#   BACKUP_DIR          where the backups are (default /backups)
#   BACKUP_FILE         a given backup instead of the newest
set -eu
: "${DATABASE_URL:?DATABASE_URL is required}"
: "${BACKUP_AGE_IDENTITY:?BACKUP_AGE_IDENTITY is required (age private key file)}"
DIR="${BACKUP_DIR:-/backups}"
FILE="${BACKUP_FILE:-$(ls -1 "$DIR"/belle-*.dump.age 2>/dev/null | sort | tail -1)}"
[ -n "$FILE" ] && [ -f "$FILE" ] || { echo "no backup found in $DIR" >&2; exit 1; }

URL=$(printf '%s' "$DATABASE_URL" | sed 's/[?&]schema=[^&]*//')
SCRATCH="belle_restore_check_$(date -u +%Y%m%d%H%M%S)"
# The same server, the scratch database instead of the one in the URL.
SCRATCH_URL=$(printf '%s' "$URL" | sed "s#/[^/?]*\(?\|\$\)#/$SCRATCH\1#")

psql "$URL" -qc "create database $SCRATCH"
trap 'psql "$URL" -qc "drop database if exists $SCRATCH" >/dev/null' EXIT

started=$(date +%s)
age --decrypt --identity "$BACKUP_AGE_IDENTITY" "$FILE" \
  | pg_restore --no-owner --no-privileges --exit-on-error --dbname "$SCRATCH_URL"
took=$(( $(date +%s) - started ))

q() { psql "$SCRATCH_URL" -tAc "$1"; }
migrations=$(q "select count(*) from _prisma_migrations where finished_at is not null")
orders=$(q 'select count(*) from "order"')
products=$(q 'select count(*) from product')
users=$(q 'select count(*) from app_user')
last=$(q 'select coalesce(max(created_at)::text, '"'"'none'"'"') from "order"')

echo "restored: $FILE in ${took}s"
echo "  migrations applied: $migrations"
echo "  orders: $orders (newest: $last)"
echo "  products: $products, accounts: $users"
[ "$migrations" -gt 0 ] && [ "$products" -gt 0 ] || { echo "restore check FAILED: empty schema or catalog" >&2; exit 1; }
echo "restore check passed"
