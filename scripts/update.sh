#!/usr/bin/env bash
# =============================================================
# n8n Update Script
# Pulls the latest n8n image and restarts the container.
# Automatically backs up data before updating.
#
# Usage: ./scripts/update.sh
# =============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.yml}"

echo "🔵 [$(date)] Starting n8n update..."

# ── Backup first ──────────────────────────────────────────────
echo "📦 Creating pre-update backup..."
bash "${SCRIPT_DIR}/backup.sh"

# ── Pull latest image ─────────────────────────────────────────
echo "⬇️  Pulling latest n8n image..."
docker compose -f "${COMPOSE_FILE}" pull

# ── Recreate containers ───────────────────────────────────────
echo "🔄 Restarting with new image..."
docker compose -f "${COMPOSE_FILE}" up -d --force-recreate

# ── Clean up old images ───────────────────────────────────────
echo "🧹 Removing dangling images..."
docker image prune -f

echo "✅ n8n updated successfully!"
docker compose -f "${COMPOSE_FILE}" ps
