# AgentRun Server on Railway

AgentRun — open-source managed-agents server (self-improving agents, durable runs, workflows, MCP, a web console). Deploy on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/ns0TOi)

Upstream: [Parcha-ai/agentrun](https://github.com/Parcha-ai/agentrun) (Apache-2.0). This repo only wraps the official
image `ghcr.io/parcha-ai/agentrun-server:v0.1.0-beta.35` (app unmodified) as `ghcr.io/onepush-dev/agentrun:0.1.0-beta.35`.

## What you get

- One service, `agentrun`, on port 8080, with a Railway volume at `/data` (SQLite agent store, runs, learning, sessions).
- Mirrors upstream's own `render.yaml`: no Docker socket, so runs have no Docker sandbox ("Boxes: none").
- `AGENTRUN_TOKEN` (API token / setup code) and `AGENTRUN_SEAL_KEY` (seals saved model keys, MCP credentials, trigger secrets) are generated per deploy.
- `AGENTRUN_PUBLIC_URL` is your Railway domain, so the console is never an open setup: setting the owner password takes the token.
- Healthcheck `GET /v2/health`. Give the service at least 2 GB RAM (Claude Code / Codex install onto the volume on first use).

## First sign-in

1. Open the service's **Variables** tab and copy `AGENTRUN_TOKEN`.
2. Open your Railway domain, go to `/setup`, paste the token as the setup code, and choose a password (12+ characters).
3. Add a model key: in the console's settings, or as service variables (`OPENROUTER_API_KEY`, `ANTHROPIC_API_KEY`,
   `OPENAI_API_KEY`, optionally `AGENT_MODEL`). No key is needed for the server to start; agents just can't run until one is added.

Scripts and the CLI use `AGENTRUN_BASE_URL=https://<your-domain>` and `AGENTRUN_API_KEY=<AGENTRUN_TOKEN>`.

## Notes

- **Keep `AGENTRUN_SEAL_KEY`.** A store sealed under one key refuses to start with another; losing it loses saved keys.
- Forgot the password: `node /opt/agentrun/packages/serve/dist/cli.js reset-password --data /data` from a Railway shell, then visit `/setup` again.
- Keep one replica (single SQLite store on one volume).
