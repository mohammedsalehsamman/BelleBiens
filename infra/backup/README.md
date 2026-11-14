# Database backups

NFR-REL-02: a daily backup, kept for 30 days, and a restore test every quarter. NFR-SEC-09: backups are encrypted.

The image is `postgres:16-alpine` (the server's major version) with [age](https://age-encryption.org):

```bash
docker build -t belle-backup infra/backup
```

## Keys

Backups are encrypted to an age **public** key. The matching private key can read every backup, so it never lives on the server:

```bash
docker run --rm -v "$PWD:/keys" belle-backup age-keygen -o /keys/belle-backup.key
# Prints "Public key: age1..."; that line goes to BACKUP_AGE_RECIPIENT on the server.
```

Keep `belle-backup.key` offline in two places the owner controls (for example a password manager and a USB key in the shop's safe). Without it no backup can be restored.

## Daily backup

Run once a day from the host's scheduler (cron, a scheduled job on the hosting provider):

```bash
docker run --rm --network <db-network> \
  -e DATABASE_URL=postgresql://... \
  -e BACKUP_AGE_RECIPIENT=age1... \
  -v /srv/belle/backups:/backups \
  belle-backup backup.sh
```

- It writes `belle-<UTC time>.dump.age` and removes backups older than `BACKUP_KEEP_DAYS` (30).
- Copy `/srv/belle/backups` off the server after each run (object storage in another region or with another provider). A backup on the same disk as the database does not survive losing that disk.
- If the provider offers managed Postgres with point-in-time recovery, keep these daily files as well: they are portable to another provider.

**Media is not in the database.** Product photos and Sham Cash receipts (payment records) live in the S3 bucket (`S3_BUCKET`). Turn on versioning and a copy to a second bucket at the provider.

## Restore test (every quarter)

```bash
docker run --rm --network <db-network> \
  -e DATABASE_URL=postgresql://... \
  -e BACKUP_AGE_IDENTITY=/keys/belle-backup.key \
  -v /srv/belle/backups:/backups -v /path/to/keys:/keys:ro \
  belle-backup restore-check.sh
```

It restores the newest backup (or `BACKUP_FILE`) into a scratch database on the same server, prints the migrations, orders, products and accounts it found, and drops the scratch database. Write the result and the time it took in the plan log. CI runs the same round trip on every API change (`.github/workflows/api.yml`, job `backup`).

## Restoring for real

1. Stop the API (or put the shop in "closed" mode) so nothing writes during the restore.
2. Create an empty database and restore into it:
   ```bash
   age --decrypt --identity belle-backup.key belle-<time>.dump.age \
     | pg_restore --no-owner --no-privileges --exit-on-error --dbname postgresql://.../belle_restored
   ```
3. Point `DATABASE_URL` at `belle_restored`, start the API, check `/v1/health/ready`, place a test order and cancel it.
4. Orders placed after the backup are lost from the database. Notifications in WhatsApp and the shop's own records are the way to recover them.
