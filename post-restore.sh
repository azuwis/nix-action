#!/usr/bin/env bash
set -eo pipefail

restore_bak() {
  echo "restore bak"
  mv -v /nix/store.bak /nix/store
  mv -v /nix/var/nix/db/db.sqlite.bak /nix/var/nix/db/db.sqlite
  echo "mark cache need update"
  echo "CACHE_NEED_UPDATE=yes" >> "$GITHUB_ENV"
}

if [ -e /nix/store ]
then
  echo "cache hit, try to restore nix"
  nix="$(readlink /nix/var/nix-quick-install-action/nix)"
  "$nix/bin/nix-env" -i "$nix"
  if nix --version
  then
    echo "restore nix succeed"
  else
    echo "restore nix failed, discard cache"
    mv -v /nix/store /nix/var/nix/db/db.sqlite /tmp
    restore_bak
  fi
else
  echo "cache miss"
  restore_bak
fi
