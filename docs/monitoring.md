# Monitoring Setup

This guide covers setting up uptime monitoring for your n8n instance at `https://n8n-20th.onrender.com`.

## Option 1 — UptimeRobot (Free, Recommended)

[UptimeRobot](https://uptimerobot.com) monitors your n8n URL every 5 minutes and alerts you if it goes down.

### Setup Steps

1. Go to [uptimerobot.com](https://uptimerobot.com) and create a free account
2. Click **Add New Monitor**
3. Fill in:

| Field | Value |
|-------|-------|
| Monitor Type | `HTTPS` |
| Friendly Name | `n8n Production` |
| URL | `https://n8n-20th.onrender.com/healthz` |
| Monitoring Interval | `5 minutes` |
| Alert Contacts | Your email |

4. Click **Create Monitor**

### Status Badge (add to README)

After creating, grab your badge URL from UptimeRobot and add to `README.md`:
```markdown
![Uptime](https://img.shields.io/uptimerobot/status/m123456789-xxxx)
```

---

## Option 2 — GitHub Actions Heartbeat

A simple scheduled workflow that pings `/healthz` and fails loudly if n8n is down.
Already configured in `.github/workflows/deploy.yml`.

---

## Option 3 — Betteruptime / Freshping

Both offer free tiers with more advanced features (incident management, status pages):
- [betteruptime.com](https://betteruptime.com)
- [freshping.io](https://freshping.io)

Monitor URL: `https://n8n-20th.onrender.com/healthz`  
Expected response: `200 OK`
