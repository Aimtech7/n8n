#!/usr/bin/env bash
# =============================================================
# n8n Restore Script
# Restores n8n data from a backup archive.
#
# Usage:
#   ./scripts/restore.sh ./backups/n8n_backup_20240101_120000.tar.gz
# =============================================================

set -euo pipefail

BACKUP_FILE="${1:-}"
VOLUME_NAME="${N8N_VOLUME:-n8n_data}"
CONTAINER_NAME="${N8N_CONTAINER:-n8n}"

if [ -z "${BACKUP_FILE}" ]; then
  echo "❌ Usage: $0 <backup-file.tar.gz>"
  exit 1
fi

if [ ! -f "${BACKUP_FILE}" ]; then
  echo "❌ Backup file not found: ${BACKUP_FILE}"
  exit 1
fi

echo "⚠️  WARNING: This will OVERWRITE all current n8n data!"
read -r -p "Type 'yes' to confirm: " CONFIRM
if [ "${CONFIRM}" != "yes" ]; then
  echo "Aborted."
  exit 0
fi

echo "⏸  Stopping n8n..."
docker stop "${CONTAINER_NAME}" 2>/dev/null || true

echo "🗑  Clearing existing data volume..."
docker run --rm -v "${VOLUME_NAME}:/data" alpine sh -c "rm -rf /data/*"

echo "📦 Restoring from: ${BACKUP_FILE}"
docker run --rm \
  -v "${VOLUME_NAME}:/data" \
  -v "$(realpath "$(dirname "${BACKUP_FILE}")"):/backup:ro" \
  alpine \
  tar xzf "/backup/$(basename "${BACKUP_FILE}")" -C /data

echo "▶️  Starting n8n..."
docker start "${CONTAINER_NAME}" 2>/dev/null || true

echo "✅ Restore complete! n8n is starting up."
