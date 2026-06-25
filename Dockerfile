FROM mirror.gcr.io/n8nio/n8n:latest

# Railway provides the PORT env var; n8n reads N8N_PORT
ENV N8N_PORT=5678
EXPOSE 5678
