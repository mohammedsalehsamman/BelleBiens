#!/bin/sh
# One encrypted backup of the database, then old ones removed.
#   DATABASE_URL          the database to back up (read only)
#   BACKUP_AGE_RECIPIENT  age public key ("age1..."); only its private key can
#                         read the backup, and it is not kept on this machine
#   BACKUP_DIR            where backups go (default /backups); copy it off the
#                         server (object storage) after each run
#   BACKUP_KEEP_DAYS      how long to keep them (default 30, NFR-REL-02)
set -eu
: "${DATABASE_URL:?DATABASE_URL is required}"
: "${BACKUP_AGE_RECIPIENT:?BACKUP_AGE_RECIPIENT is required (age public key)}"
DIR="${BACKUP_DIR:-/backups}"
KEEP="${BACKUP_KEEP_DAYS:-30}"
mkdir -p "$DIR"

# Prisma's "?schema=public" is not a libpq option.
URL=$(printf '%s' "$DATABASE_URL" | sed 's/[?&]schema=[^&]*//')
STAMP=$(date -u +%Y%m%dT%H%M%SZ)
FILE="$DIR/belle-$STAMP.dump.age"
TMP="$FILE.partial"

# Custom format: compressed, and pg_restore can pick tables from it.
pg_dump --format=custom --no-owner --no-privileges "$URL" \
  | age --encrypt --recipient "$BACKUP_AGE_RECIPIENT" > "$TMP"
mv "$TMP" "$FILE"
echo "backup: $FILE ($(du -h "$FILE" | cut -f1))"

find "$DIR" -name 'belle-*.dump.age' -mtime +"$KEEP" -print -delete \
  | sed 's/^/removed: /'
