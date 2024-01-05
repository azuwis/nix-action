#!/usr/bin/env bash
set -eo pipefail

mv -v /nix/store /nix/store.bak
mv -v /nix/var/nix/db/db.sqlite /nix/var/nix/db/db.sqlite.bak
echo "CACHE_KEY=$CACHE_KEY" >> "$GITHUB_ENV"
echo "CACHE_TIMESTAMP=$(date +%s)" >> "$GITHUB_ENV"
