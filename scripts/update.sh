#!/usr/bin/env bash
set -euo pipefail

# Update all images and recreate the stack
# Usage: ./scripts/update.sh

echo "Pulling images..."
docker compose pull

echo "Bringing services up..."
docker compose up -d

echo "Pruning unused images..."
docker image prune -f

echo "Update complete. Review container status with 'docker compose ps'"
