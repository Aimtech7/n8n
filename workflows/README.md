# Example Workflows

Import these workflows into n8n via **Workflows → ⋮ → Import from file**.

---

## 🤖 AI OS — Agentic Workflows

A complete AI operating system built in n8n with modular sub-workflows.

| File | Description |
|------|-------------|
| `AI OS — Bootstrap & Init.json` | Bootstraps the AI OS — run this first |
| `AI OS — Core Router (brain).json` | Central brain that routes tasks to agents |
| `AI OS — Task Agent (sub-workflow).json` | Executes tasks assigned by the router |
| `AI OS — Memory Service (sub-workflow).json` | Manages persistent memory/context |
| `AI OS — Logging Service (sub-workflow).json` | Logs all AI OS activity |
| `AI OS — Notification Service (sub-workflow).json` | Sends alerts and notifications |

**Import order:** Bootstrap → Core Router → all sub-workflows → activate in order.

---

## 📱 Personal Productivity

| File | Description |
|------|-------------|
| `Personal life manager with Telegram, Google services & voice-enabled AI.json` | Full personal life manager: Telegram bot + Google Calendar/Gmail + voice AI |

---

## 🧪 Examples

| File | Description |
|------|-------------|
| `http-request-example.json` | Fetches data from a REST API and extracts fields |
| `scheduled-report-example.json` | Weekday 8AM schedule → fetches data → sends email report |

---

## How to Import

1. Open n8n at [https://n8n-20th.onrender.com](https://n8n-20th.onrender.com)
2. Go to **Workflows → New Workflow**
3. Click **⋮ (three dots)** → **Import from file**
4. Select any `.json` file from this folder
5. Configure credentials and activate

## Contributing

Export your workflow from n8n (**⋮ → Download**) and save the `.json` here with a descriptive name.
