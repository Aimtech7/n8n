#!/usr/bin/env bash
# =============================================================
# n8n Backup Script
# Backs up the n8n data volume to a local directory and
# optionally uploads to an S3-compatible bucket.
#
# Usage:
#   ./scripts/backup.sh                    # local backup only
#   S3_BUCKET=my-bucket ./scripts/backup.sh  # + S3 upload
#
# Requirements: docker, tar, (optional) aws CLI or rclone
# =============================================================

set -euo pipefail

# ── Config ────────────────────────────────────────────────────
BACKUP_DIR="${BACKUP_DIR:-./backups}"
VOLUME_NAME="${N8N_VOLUME:-n8n_data}"
CONTAINER_NAME="${N8N_CONTAINER:-n8n}"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/n8n_backup_${TIMESTAMP}.tar.gz"
RETENTION_DAYS="${RETENTION_DAYS:-30}"   # delete backups older than this
S3_BUCKET="${S3_BUCKET:-}"               # optional: s3://your-bucket/n8n-backups

# ── Setup ─────────────────────────────────────────────────────
mkdir -p "${BACKUP_DIR}"

echo "🔵 [$(date)] Starting n8n backup..."

# ── Stop n8n briefly for a consistent backup ──────────────────
echo "⏸  Pausing n8n container..."
docker stop "${CONTAINER_NAME}" 2>/dev/null || true

# ── Create backup ─────────────────────────────────────────────
echo "📦 Creating backup: ${BACKUP_FILE}"
docker run --rm \
  -v "${VOLUME_NAME}:/data:ro" \
  -v "$(realpath "${BACKUP_DIR}"):/backup" \
  alpine \
  tar czf "/backup/n8n_backup_${TIMESTAMP}.tar.gz" -C /data .

# ── Restart n8n ───────────────────────────────────────────────
echo "▶️  Restarting n8n container..."
docker start "${CONTAINER_NAME}" 2>/dev/null || true

# ── Upload to S3 (optional) ───────────────────────────────────
if [ -n "${S3_BUCKET}" ]; then
  echo "☁️  Uploading to S3: ${S3_BUCKET}..."
  if command -v aws &>/dev/null; then
    aws s3 cp "${BACKUP_FILE}" "${S3_BUCKET}/$(basename "${BACKUP_FILE}")"
  elif command -v rclone &>/dev/null; then
    rclone copy "${BACKUP_FILE}" "${S3_BUCKET}/"
  else
    echo "⚠️  Neither aws CLI nor rclone found. Skipping S3 upload."
  fi
fi

# ── Prune old local backups ───────────────────────────────────
echo "🧹 Removing backups older than ${RETENTION_DAYS} days..."
find "${BACKUP_DIR}" -name "n8n_backup_*.tar.gz" -mtime "+${RETENTION_DAYS}" -delete

BACKUP_SIZE=$(du -sh "${BACKUP_FILE}" | cut -f1)
echo "✅ Backup complete: ${BACKUP_FILE} (${BACKUP_SIZE})"
