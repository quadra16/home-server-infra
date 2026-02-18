# Storage

This project uses host-mounted directories and named volumes to persist data.

- Host mounts used in the compose file (examples):
  - `/server/data/...` — primary host-managed data directory for service configs and media
  - `/data/config/...` — configuration data for specific services (Immich, DB data)

- Named volumes:
  - `model-cache` — stores machine learning models and caches for the `immich-machine-learning` service

Backup guidance:

- Back up service config directories under `/server/data/` and `/data/config/` regularly
- Dump the Immich Postgres database with `docker exec immich-db pg_dump -U <user> -d <db>` before backing up
- Store backups off-host when possible
- Test restores in a safe environment before relying on them

Permissions:

- Ensure files owned by the host user mapped to the PUID/PGID environment variables used by containers. Avoid running containers as root where possible.
