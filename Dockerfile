FROM mirror.gcr.io/n8nio/n8n:latest

# Railway provides the PORT env var; n8n reads N8N_PORT
ENV N8N_PORT=5678
EXPOSE 5678

# Pin n8n's data directory to the exact path Railway mounts the persistent
# volume on. Without this, n8n falls back to resolving it as ~/.n8n, which
# depends on $HOME at runtime -- and since this image ships neither su-exec
# nor gosu, the entrypoint below silently falls through to running n8n as
# root with HOME=/root, so it reads/writes /root/.n8n instead of the mounted
# volume. That mismatch is why data disappeared on every redeploy even
# though the volume itself was attached correctly.
ENV N8N_USER_FOLDER=/home/node/.n8n

# Railway mounts fresh volumes as root-owned, but the base image's default
# user (node) can't write to /home/node/.n8n until ownership is fixed.
USER root
RUN printf '#!/bin/sh\nset -e\nchown -R node:node /home/node/.n8n 2>/dev/null || true\nif command -v su-exec >/dev/null 2>&1; then\n  exec su-exec node n8n "$@"\nelif command -v gosu >/dev/null 2>&1; then\n  exec gosu node n8n "$@"\nelse\n  exec n8n "$@"\nfi\n' > /fix-volume-perms.sh \
    && chmod +x /fix-volume-perms.sh

ENTRYPOINT ["/fix-volume-perms.sh"]
CMD ["start"]
