#!/usr/bin/env bash
#
# git-sync <feature/xyz|hotfix/xyz|bugfix/xyz>
# Sync your feature, bugfix or hotfix branch with develop/main.
#

set -euo pipefail

error() { printf 'Error: %s\n' "$1" >&2; exit 1; }

usage() {
  cat <<EOF
Usage: $(basename "$0") <branch>
  branch must start with feature/, bugfix or hotfix/
EOF
  exit 1
}

require_name() {
  [[ $# -ge 1 ]] && NAME=$1 || usage
}

do_stash() {
  echo "→ Stashing uncommitted changes…"
  git stash push --keep-index --include-untracked
}

do_pop() {
  echo "→ Restoring stash…"
  git stash pop || echo "⚠️  Nothing to pop."
}

sync_existing() {
  require_name "$@"
  FULL=$NAME

  if [[ ! "$FULL" =~ ^(feature|bugfix|hotfix)\/.+$ ]]; then
    error "Branch name must start with feature/ or hotfix/."
  fi

  PREFIX=${FULL%%/*}
  BASE=develop
  [[ "$PREFIX" == hotfix ]] && BASE=main

  echo "→ Fetching remote and pruning…"
  git fetch --prune origin

  if ! git ls-remote --exit-code --heads origin "$FULL" &>/dev/null; then
    cat <<EOF

⚠️  Remote branch 'origin/${FULL}' not found.

Possible reasons:
  • You forgot to push your branch.
  • It was deleted remotely.

Fixes:
  1. Push it:
       git push -u origin "${FULL}"
  2. If deleted upstream, review or rename:
       git log "${FULL}"
       git branch -m "${FULL}" new-name

EOF
    exit 0
  fi

  do_stash

  echo "→ Syncing base '${BASE}'…"
  git checkout "$BASE"
  git pull --ff-only origin "$BASE"

  echo "→ Checking out '${FULL}'…"
  git checkout "$FULL"

  echo "→ Merging '${BASE}' → '${FULL}'…"
  git merge --no-ff "$BASE"

  do_pop

  echo "✔ Synchronized '${FULL}' with '${BASE}'"
}

if [ $# -ne 1 ]; then
  usage
fi

sync_existing "$1"
