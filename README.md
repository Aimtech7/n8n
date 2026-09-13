# n8n — Self-Hosted Workflow Automation

![n8n](https://img.shields.io/badge/n8n-latest-orange?style=for-the-badge&logo=n8n)
![Docker](https://img.shields.io/badge/Docker-ready-blue?style=for-the-badge&logo=docker)
![License](https://img.shields.io/badge/license-Sustainable_Use-green?style=for-the-badge)

> [n8n](https://n8n.io) is a powerful, open-source workflow automation tool that lets you connect apps, automate tasks, and build AI-powered workflows — all without giving up control of your data.

---

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Option 1 — Local with Docker Compose](#option-1--local-with-docker-compose)
- [Option 2 — Deploy to Render.com](#option-2--deploy-to-rendercom)
- [Option 3 — Run with Docker directly](#option-3--run-with-docker-directly)
- [Accessing n8n](#accessing-n8n)
- [Configuration](#configuration)
- [Persisting Data](#persisting-data)
- [Updating n8n](#updating-n8n)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

| Tool | Min Version | Install |
|------|-------------|---------|
| Docker | 20.x+ | [docs.docker.com](https://docs.docker.com/get-docker/) |
| Docker Compose | v2+ | Bundled with Docker Desktop |
| Git | any | [git-scm.com](https://git-scm.com) |

---

## Option 1 — Local with Docker Compose

The easiest way to run n8n locally with persistent data.

### 1. Clone the repo

```bash
git clone https://github.com/Aimtech7/n8n.git
cd n8n
```

### 2. Start n8n

```bash
docker compose up -d
```

### 3. Open n8n

Navigate to [http://localhost:5678](http://localhost:5678) in your browser.

### 4. Stop n8n

```bash
docker compose down
```

---

## Option 2 — Deploy to Render.com

One-click cloud deployment using the included [`render.yaml`](./render.yaml) blueprint.

### Steps

1. **Fork or push** this repo to your GitHub account.
2. Go to [render.com](https://render.com) and sign in.
3. Click **New → Blueprint**.
4. Connect your GitHub repo (`Aimtech7/n8n`).
5. Render will auto-detect `render.yaml` and configure the service.
6. Click **Apply** — Render will build and deploy n8n automatically.

### What Render provisions

| Resource | Details |
|----------|---------|
| Service type | Web service (Docker) |
| Plan | Starter |
| Port | `5678` |
| Persistent disk | 1 GB mounted at `/home/node/.n8n` |
| Protocol | HTTPS (auto-managed SSL) |
| Encryption key | Auto-generated and stored securely |
| Health check | `/healthz` |

> Your n8n instance will be available at `https://n8n-<hash>.onrender.com`

---

## Option 3 — Run with Docker directly

No Compose needed — single command:

```bash
docker run -d \
  --name n8n \
  --restart unless-stopped \
  -p 5678:5678 \
  -e N8N_HOST=localhost \
  -e N8N_PORT=5678 \
  -e N8N_PROTOCOL=http \
  -e NODE_ENV=production \
  -e WEBHOOK_URL=http://localhost:5678/ \
  -e GENERIC_TIMEZONE=Africa/Nairobi \
  -v n8n_data:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n:latest
```

---

## Accessing n8n

| Deployment | URL |
|------------|-----|
| Local (Docker Compose / Docker) | `http://localhost:5678` |
| Render.com | `https://<your-service>.onrender.com` |

On first launch, n8n will ask you to create an **owner account**. Fill in your name, email, and password — this becomes the admin account.

---

## Configuration

Key environment variables you can customize in [`docker-compose.yml`](./docker-compose.yml) or [`render.yaml`](./render.yaml):

| Variable | Default | Description |
|----------|---------|-------------|
| `N8N_HOST` | `localhost` | Hostname n8n listens on |
| `N8N_PORT` | `5678` | Port n8n runs on |
| `N8N_PROTOCOL` | `http` | `http` or `https` |
| `WEBHOOK_URL` | `http://localhost:5678/` | Public URL for webhooks |
| `GENERIC_TIMEZONE` | `Africa/Nairobi` | Timezone for scheduling |
| `N8N_ENCRYPTION_KEY` | *(auto on Render)* | Key to encrypt credentials |
| `N8N_BASIC_AUTH_ACTIVE` | `false` | Enable basic auth |
| `N8N_BASIC_AUTH_USER` | — | Basic auth username |
| `N8N_BASIC_AUTH_PASSWORD` | — | Basic auth password |

> For a full list of variables, see the [n8n environment variables docs](https://docs.n8n.io/hosting/configuration/environment-variables/).

---

## Persisting Data

All workflows, credentials, and settings are stored in `/home/node/.n8n` inside the container.

- **Docker Compose** — mapped to a named Docker volume `n8n_data` (survives container restarts/updates)
- **Render.com** — mapped to a 1 GB persistent disk (survives deploys)

> ⚠️ **Never delete the volume/disk** — it contains all your workflows and encrypted credentials.

---

## Updating n8n

### Docker Compose

```bash
# Pull the latest image
docker compose pull

# Restart with the new image
docker compose up -d
```

### Docker (standalone)

```bash
docker pull docker.n8n.io/n8nio/n8n:latest
docker stop n8n && docker rm n8n
# Re-run the docker run command from Option 3
```

### Render.com

Trigger a **Manual Deploy** from the Render dashboard, or enable **Auto-Deploy** from your GitHub repo.

---

## Troubleshooting

**n8n won't start**
- Check logs: `docker compose logs -f`
- Make sure port `5678` isn't already in use: `netstat -ano | findstr 5678` (Windows) or `lsof -i :5678` (Mac/Linux)

**Webhooks not working locally**
- Webhooks require a publicly accessible URL. Use [ngrok](https://ngrok.com) to expose your local instance:
  ```bash
  ngrok http 5678
  ```
  Then set `WEBHOOK_URL=https://<your-ngrok-url>/` in your environment.

**Lost access / forgot password**
- Reset via CLI inside the container:
  ```bash
  docker exec -it n8n n8n user-management:reset
  ```

**Data not persisting after restart**
- Ensure the Docker volume exists: `docker volume ls | grep n8n_data`
- Never use `docker compose down -v` — the `-v` flag deletes volumes.

---

## 📚 Resources

- [n8n Documentation](https://docs.n8n.io)
- [n8n Community Forum](https://community.n8n.io)
- [n8n Workflow Templates](https://n8n.io/workflows)
- [n8n GitHub](https://github.com/n8n-io/n8n)

---

## License

n8n is licensed under the [Sustainable Use License](https://github.com/n8n-io/n8n/blob/master/LICENSE.md).
