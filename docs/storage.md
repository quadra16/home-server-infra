 # Storage
 
 This project uses host-mounted directories and named volumes to persist data.
 
 - Host mounts used in the compose file (examples):
	 - `/server/data/...` — primary host-managed data directory for service configs and media
	 - `/data/config/...` — configuration data for specific services (Immich, DB data)
 
 - Named volumes:
	 - `model-cache` — stores machine learning models and caches for the `immich-machine-learning` service
 
 Backup guidance:
 - Use `./scripts/backup.sh` to produce DB dumps and tarballs of common data paths. Store backups off-host when possible.
 - Test restores regularly using `./scripts/restore.sh <backup-folder>` in a safe environment before relying on them.
 
 Permissions:
 - Ensure files owned by the host user mapped to the PUID/PGID environment variables used by containers. Avoid running containers as root where possible.
