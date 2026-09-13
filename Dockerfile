FROM n8nio/n8n:latest

# Allow mounting custom nodes at build or run time
ENV N8N_CUSTOM_EXTENSIONS=/home/node/.n8n/custom

# Copy custom nodes if they exist (optional — only needed if building with custom nodes)
# COPY --chown=node:node custom-nodes/ /home/node/.n8n/custom/

EXPOSE 5678

# The base image ENTRYPOINT is: tini -- /docker-entrypoint.sh
# That wrapper prepends 'n8n' to any CMD, so 'sh -c ...' becomes 'n8n sh -c ...' — which fails.
# Clearing ENTRYPOINT lets /bin/sh run directly.
# Render (and similar PaaS) inject $PORT; n8n reads N8N_PORT, so we map them here.
# Falls back to 5678 for local Docker usage.
ENTRYPOINT []
CMD ["/bin/sh", "-c", "N8N_PORT=${PORT:-5678} n8n"]
