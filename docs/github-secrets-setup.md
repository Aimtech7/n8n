# GitHub Actions — Secrets Setup Guide

To enable CI/CD (auto-deploy) and other automations, add these secrets to your GitHub repo:

**Go to:** `https://github.com/Aimtech7/n8n/settings/secrets/actions`

---

## Required Secrets

### Auto-Deploy to Render

| Secret Name | Where to get it | Description |
|-------------|----------------|-------------|
| `RENDER_DEPLOY_HOOK_URL` | Render Dashboard → n8n service → **Settings** → **Deploy Hooks** → Create Hook | Triggers a new Render deploy on every push to `main` |

### Steps
1. Open [Render Dashboard](https://dashboard.render.com)
2. Click your **n8n** service
3. Go to **Settings** → scroll to **Deploy Hooks**
4. Click **Add Deploy Hook** → name it `GitHub Actions`
5. Copy the URL → paste as `RENDER_DEPLOY_HOOK_URL` secret in GitHub

---

## Optional Secrets (for scheduled backups via SSH)

Only needed if you self-host and want the `.github/workflows/backup.yml` to run:

| Secret Name | Value |
|-------------|-------|
| `SSH_HOST` | Your server IP or hostname |
| `SSH_USER` | SSH username (e.g. `ubuntu`) |
| `SSH_PRIVATE_KEY` | Your private SSH key content |
| `S3_BUCKET` | e.g. `s3://my-bucket/n8n-backups` |
| `AWS_ACCESS_KEY_ID` | AWS key with S3 write access |
| `AWS_SECRET_ACCESS_KEY` | AWS secret |
| `AWS_REGION` | e.g. `us-east-1` |

---

## Verifying CI/CD Works

After adding `RENDER_DEPLOY_HOOK_URL`:
1. Make any small change and push to `main`
2. Go to **GitHub → Actions** tab
3. Watch the `Deploy n8n` workflow run
4. It should trigger a new build in your Render dashboard

Status badge for your README:
```markdown
![CI/CD](https://img.shields.io/github/actions/workflow/status/Aimtech7/n8n/deploy.yml?label=Deploy)
```
