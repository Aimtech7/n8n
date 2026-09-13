# n8n — Self-Hosted Workflow Automation

![n8n](https://img.shields.io/badge/n8n-latest-orange?style=for-the-badge&logo=n8n)
![Docker](https://img.shields.io/badge/Docker-ready-blue?style=for-the-badge&logo=docker)
![CI/CD](https://img.shields.io/github/actions/workflow/status/Aimtech7/n8n/deploy.yml?style=for-the-badge&label=Deploy)
![License](https://img.shields.io/badge/license-Sustainable_Use-green?style=for-the-badge)

> [n8n](https://n8n.io) is a powerful, open-source workflow automation tool — connect 400+ apps, build AI agents, and automate anything, all while keeping full control of your data.

---

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Deployment Options](#deployment-options)
  - [Local — Docker Compose](#1-local--docker-compose)
  - [With PostgreSQL](#2-with-postgresql-recommended-for-production)
  - [With Nginx + SSL](#3-with-nginx--ssl)
  - [Render.com](#4-rendercom-one-click-cloud)
  - [Railway.app](#5-railwayapp)
  - [Fly.io](#6-flyio)
  - [Kubernetes](#7-kubernetes)
  - [Docker Swarm](#8-docker-swarm)
- [Configuration](#configuration)
- [Security](#security)
- [Custom Nodes](#custom-nodes)
- [Example Workflows](#example-workflows)
- [Backup & Restore](#backup--restore)
- [Updating n8n](#updating-n8n)
- [CI/CD](#cicd)
- [Troubleshooting](#troubleshooting)

---

## Quick Start

```bash
git clone https://github.com/Aimtech7/n8n.git
cd n8n
cp .env.example .env        # edit .env with your settings
docker compose up -d
```

Open [http://localhost:5678](http://localhost:5678) → create your owner account → start automating.

---

## Deployment Options

### 1. Local — Docker Compose

Simple SQLite-backed local instance.

```bash
cp .env.example .env
docker compose up -d
```

**Stop:** `docker compose down`  
**Logs:** `docker compose logs -f`

---

### 2. With PostgreSQL *(recommended for production)*

```bash
cp .env.example .env
# Edit .env — uncomment and fill in DB_POSTGRESDB_* variables

docker compose \
  -f docker-compose.yml \
  -f docker-compose.postgres.yml \
  up -d
```

This starts a `postgres:16` container alongside n8n. The n8n container waits for Postgres to be healthy before starting.

---

### 3. With Nginx + SSL

Serves n8n on port 443 with HTTPS termination.

**Step 1:** Place your SSL certificate files:
```
nginx/ssl/cert.pem
nginx/ssl/key.pem
```
> **Self-signed (dev):** `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx/ssl/key.pem -out nginx/ssl/cert.pem`

**Step 2:** Start:
```bash
docker compose \
  -f docker-compose.yml \
  -f docker-compose.nginx.yml \
  up -d
```

n8n is now accessible at `https://your-server-ip/`.

---

### 4. Render.com *(one-click cloud)*

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/Aimtech7/n8n)

Or manually:
1. Go to [render.com](https://render.com) → **New → Blueprint**
2. Connect `Aimtech7/n8n` repo
3. Render auto-detects `render.yaml` — click **Apply**

Render provisions: HTTPS, 1 GB persistent disk, auto-generated encryption key.

---

### 5. Railway.app

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template)

1. Push this repo to GitHub
2. Go to [railway.app](https://railway.app) → **New Project → Deploy from GitHub**
3. Select the repo — Railway detects `railway.json` and `Dockerfile`
4. Add environment variables from `.env.example` in the Railway dashboard

---

### 6. Fly.io

```bash
# Install flyctl: https://fly.io/docs/hands-on/install-flyctl/
fly auth login

# Edit fly.toml — change app name and region
fly launch --no-deploy

# Set secrets
fly secrets set N8N_ENCRYPTION_KEY="your-32-char-key"
fly secrets set WEBHOOK_URL="https://your-app.fly.dev/"

# Deploy
fly deploy
```

---

### 7. Kubernetes

```bash
# Apply in order
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml

# Edit k8s/secret.yaml — replace base64-encoded placeholder values
kubectl apply -f k8s/secret.yaml

kubectl apply -f k8s/pvc.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Edit k8s/ingress.yaml — set your domain
kubectl apply -f k8s/ingress.yaml
```

**Or apply everything at once:**
```bash
kubectl apply -f k8s/
```

> Requires: nginx ingress controller + cert-manager for automatic TLS.

---

### 8. Docker Swarm

```bash
# Initialize swarm (if not already)
docker swarm init

# Create encryption key secret
echo "your-32-char-key" | docker secret create n8n_encryption_key -

# Deploy the stack
docker stack deploy -c docker-compose.swarm.yml n8n

# Check status
docker service ls
docker service logs n8n_n8n
```

---

## Configuration

Edit `.env` (copied from `.env.example`) to configure your instance:

| Variable | Default | Description |
|----------|---------|-------------|
| `N8N_HOST` | `localhost` | Host n8n listens on |
| `N8N_PORT` | `5678` | Port number |
| `N8N_PROTOCOL` | `http` | `http` or `https` |
| `WEBHOOK_URL` | `http://localhost:5678/` | Public URL for webhooks |
| `GENERIC_TIMEZONE` | `Africa/Nairobi` | Timezone for schedules |
| `N8N_ENCRYPTION_KEY` | *(required)* | Credential encryption key |
| `DB_TYPE` | `sqlite` | `sqlite` or `postgresdb` |
| `EXECUTIONS_DATA_PRUNE` | `true` | Auto-delete old executions |
| `EXECUTIONS_DATA_MAX_AGE` | `720` | Hours to keep executions |

Full list: [n8n environment variables docs](https://docs.n8n.io/hosting/configuration/environment-variables/)

---

## Security

### Basic Auth (quick protection)
```env
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=strong-password-here
```

### Production hardening
```bash
docker compose \
  -f docker-compose.yml \
  -f docker-compose.prod.yml \
  up -d
```

Adds: resource limits (1 CPU / 1 GB RAM), read-only filesystem, no-new-privileges, structured logging.

### SSL/TLS
- Use the [Nginx override](#3-with-nginx--ssl) for self-hosted instances
- Render, Railway, and Fly.io handle TLS automatically
- Kubernetes: use `cert-manager` with Let's Encrypt (see `k8s/ingress.yaml`)

---

## Custom Nodes

Custom nodes live in `custom-nodes/`. A starter node (`ExampleNode`) is included.

```bash
cd custom-nodes
npm install
npm run build
```

See [`custom-nodes/README.md`](./custom-nodes/README.md) for full instructions on creating and loading custom nodes.

---

## Example Workflows

Pre-built workflows are in `workflows/`. Import them via **n8n UI → Workflows → Import from file**.

| Workflow | Description |
|----------|-------------|
| `http-request-example.json` | Fetches data from an API and extracts fields |
| `scheduled-report-example.json` | Sends a daily email report on a weekday schedule |

See [`workflows/README.md`](./workflows/README.md) for import instructions.

---

## Backup & Restore

### Manual backup
```bash
bash scripts/backup.sh
# Backup saved to ./backups/n8n_backup_YYYYMMDD_HHMMSS.tar.gz
```

### Backup to S3
```bash
S3_BUCKET=s3://your-bucket/n8n-backups bash scripts/backup.sh
```

### Restore
```bash
bash scripts/restore.sh ./backups/n8n_backup_20240101_120000.tar.gz
```

### Automated (cron)
```bash
# Add to crontab — backup at 2AM every day
0 2 * * * cd /opt/n8n && bash scripts/backup.sh >> /var/log/n8n-backup.log 2>&1
```

> Automated cloud backups via GitHub Actions are also configured — see [CI/CD](#cicd).

---

## Updating n8n

```bash
bash scripts/update.sh
```

This automatically:
1. Creates a backup
2. Pulls the latest `n8n` image
3. Recreates the container
4. Prunes old images

---

## CI/CD

GitHub Actions workflows in `.github/workflows/`:

| Workflow | Trigger | Action |
|----------|---------|--------|
| `deploy.yml` | Push to `main` | Validates configs → triggers Render deploy |
| `backup.yml` | Daily at 2AM UTC | SSH into server → runs backup → uploads to S3 |

### Setup

**For auto-deploy (Render):**  
Add `RENDER_DEPLOY_HOOK_URL` to GitHub repo **Settings → Secrets → Actions**.

**For scheduled backups:**  
Add these secrets:
- `SSH_HOST`, `SSH_USER`, `SSH_PRIVATE_KEY` — your server access
- `S3_BUCKET` — e.g. `s3://my-bucket/n8n-backups`
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` — S3 credentials

---

## Troubleshooting

**n8n won't start**
```bash
docker compose logs -f n8n
```

**Port already in use**
```bash
# Windows
netstat -ano | findstr 5678
# Linux/Mac
lsof -i :5678
```

**Webhooks not working locally**  
Use [ngrok](https://ngrok.com):
```bash
ngrok http 5678
# Then set: WEBHOOK_URL=https://xxxx.ngrok.io/
```

**Forgot password**
```bash
docker exec -it n8n n8n user-management:reset
```

**Database migration error (SQLite → PostgreSQL)**
```bash
# Export workflows first, then switch DB type and re-import
docker exec -it n8n n8n export:workflow --all --output=/home/node/.n8n/workflows-export.json
```

---

## 📚 Resources

- [n8n Documentation](https://docs.n8n.io)
- [n8n Community Forum](https://community.n8n.io)
- [n8n Workflow Templates](https://n8n.io/workflows)
- [Creating Custom Nodes](https://docs.n8n.io/integrations/creating-nodes/)
- [n8n GitHub](https://github.com/n8n-io/n8n)

---

## License

n8n is licensed under the [Sustainable Use License](https://github.com/n8n-io/n8n/blob/master/LICENSE.md).  
This deployment configuration is MIT licensed.
