#!/bin/sh
# Railway start wrapper for AgentRun Server: make the volume the "node" user's own (0700, as the image's /data is),
# then hand off to upstream's launcher exactly as the image's own ENTRYPOINT does.
set -e
DATA=/data
mkdir -p "$DATA"
if [ "$(stat -c %U "$DATA")" != node ]; then
  chown -R node:node "$DATA"
fi
chmod 700 "$DATA"
exec setpriv --reuid=node --regid=node --init-groups \
  /opt/agentrun/packages/serve/launcher/agentrun-serve -- /usr/bin/tini -- node /opt/agentrun/packages/serve/dist/cli.js "$@"
