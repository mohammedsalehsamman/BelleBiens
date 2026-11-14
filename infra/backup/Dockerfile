# Database backups (NFR-REL-02, NFR-SEC-09): pg_dump of the same major
# version as the server, encrypted with age.
FROM postgres:16-alpine
RUN apk add --no-cache age
COPY backup.sh restore-check.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/backup.sh /usr/local/bin/restore-check.sh
ENTRYPOINT []
CMD ["backup.sh"]
