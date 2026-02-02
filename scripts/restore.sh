# !/usr/bin/env bash
# set -euo pipefail

# Simple restore script
# Usage: ./scripts/restore.sh /path/to/backup-folder

if [ $# -lt 1 ]; then
	echo "Usage: $0 <backup-folder>"
	exit 1
fi

BACKUP_DIR="$1"
if [ ! -d "$BACKUP_DIR" ]; then
	echo "Backup folder not found: $BACKUP_DIR"
	exit 2
fi

# Restore DB if SQL dump present
if [ -f "$BACKUP_DIR/immich-db.sql" ]; then
	if docker ps -a --format '{{.Names}}' | grep -q '^immich-db$'; then
		echo "Restoring Immich DB (this will overwrite data)..."
		docker exec -i immich-db psql -U "${IMMICH_DB_USER:-postgres}" -d "${IMMICH_DB_NAME:-postgres}" < "$BACKUP_DIR/immich-db.sql" || echo "DB restore failed"
	else
		echo "immich-db container not found; cannot restore DB"
	fi
fi

# Extract archives into root if present (requires appropriate permissions)
for f in "$BACKUP_DIR"/*.tar.gz; do
	[ -e "$f" ] || continue
	echo "Extracting $f (requires root privileges for system paths)"
	tar -xzf "$f" -C /
done

echo "Restore complete (manual verification recommended)"
