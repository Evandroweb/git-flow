#!/usr/bin/env bash
set -euo pipefail

DESTDIR=${DESTDIR:-/usr/local/bin}
mkdir -p "$DESTDIR"

echo "Installing git-sync → $DESTDIR/git-sync"
install -m 755 scripts/git-sync "$DESTDIR/git-sync"

echo "Adding Git alias: git sync → git-sync"
git config --global alias.sync "!git-sync"

echo "Done! You can now run:"
echo "  git sync feature/my-feature"
