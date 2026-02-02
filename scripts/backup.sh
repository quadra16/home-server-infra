#!/usr/bin/env bash
set -euo pipefail

# Simple backup script for important paths and the Immich Postgres DB
# Usage: ./scripts/backup.sh

BASEDIR="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$BASEDIR/backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Load immich env if present (prefer `env/immich.env` but fall back to example)
if [ -f "$BASEDIR/env/immich.env" ]; then
	# shellcheck disable=SC1090
	source "$BASEDIR/env/immich.env"
elif [ -f "$BASEDIR/env/immich.env.example" ]; then
	# shellcheck disable=SC1090
	source "$BASEDIR/env/immich.env.example"
fi

echo "Backing up to $BACKUP_DIR"

# Dump Immich Postgres DB (if container exists)
if docker ps -a --format '{{.Names}}' | grep -q '^immich-db$'; then
	echo "Dumping Immich DB..."
	docker exec -i immich-db pg_dump -U "${IMMICH_DB_USER:-postgres}" -d "${IMMICH_DB_NAME:-postgres}" > "$BACKUP_DIR/immich-db.sql" || echo "DB dump failed"
else
	echo "immich-db container not found; skipping DB dump"
fi

# Archive configured data paths if they exist
for path in /data/config /server/data /media; do
	if [ -e "$path" ]; then
		echo "Archiving $path"
		tar -czf "$BACKUP_DIR/$(basename "$path").tar.gz" -C / "${path#/}"
	fi
done

echo "Backup complete: $BACKUP_DIR"
