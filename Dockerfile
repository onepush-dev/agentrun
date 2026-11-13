# AgentRun Server on Railway: the official upstream image (Parcha-ai/agentrun, Apache-2.0), app unmodified.
# Mirrors upstream render.yaml (one web service + a /data disk, no Docker socket, so runs have no Docker sandbox).
# The wrapper only: chowns the Railway volume (mounted root-owned) for the image's "node" user, then starts the
# upstream launcher as "node" on port 8080. Defaults are baked as ENV because Railway templates drop plain values.
FROM ghcr.io/parcha-ai/agentrun-server:v0.1.0-beta.35
LABEL org.opencontainers.image.source="https://github.com/onepush-dev/agentrun"
USER root
RUN command -v setpriv
COPY railway/start.sh /opt/railway/start.sh
RUN chmod 755 /opt/railway/start.sh
ENV NODE_ENV=production \
    PORT=8080 \
    HOME=/home/node
EXPOSE 8080
ENTRYPOINT ["/opt/railway/start.sh"]
CMD ["--data", "/data", "--listen", "0.0.0.0", "--port", "8080", "--drain-timeout", "6s"]
