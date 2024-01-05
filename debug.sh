#!/usr/bin/env bash
set -eo pipefail

if [ -n "$TTYD_CREDENTIAL" ]
then
  nixpkgs="https://github.com/NixOS/nixpkgs/archive/refs/heads/release-23.11.tar.gz"
  nix-env -f $nixpkgs -iA cloudflared ttyd
  cloudflared tunnel --url http://127.0.0.1:3456 2>&1 | tee /tmp/cloudflared.log &
  ttyd --interface 127.0.0.1 --port 3456 --writable --once --credential "$TTYD_CREDENTIAL" bash --login &
  while [ ! -f ../continue ]
  do
    sleep 10
    grep -F '.trycloudflare.com' /tmp/cloudflared.log || true
  done
else
  echo "env TTYD_CREDENTIAL is empty, skip debug"
fi
