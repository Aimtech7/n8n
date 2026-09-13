FROM n8nio/n8n:latest

# Allow mounting custom nodes at build or run time
ENV N8N_CUSTOM_EXTENSIONS=/home/node/.n8n/custom

# Copy custom nodes if they exist (optional — only needed if building with custom nodes)
# COPY --chown=node:node custom-nodes/ /home/node/.n8n/custom/

EXPOSE 5678

# PaaS platforms (Render, Railway, Fly.io) inject a dynamic $PORT.
# n8n reads N8N_PORT — not a --port flag — so we map them here at runtime.
# Falls back to 5678 for local Docker usage.
CMD ["sh", "-c", "N8N_PORT=${PORT:-5678} n8n"]
