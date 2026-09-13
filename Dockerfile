FROM n8nio/n8n:latest

# Allow mounting custom nodes at build or run time
ENV N8N_CUSTOM_EXTENSIONS=/home/node/.n8n/custom

# Copy custom nodes if they exist (optional — only needed if building with custom nodes)
# COPY --chown=node:node custom-nodes/ /home/node/.n8n/custom/

EXPOSE 5678
