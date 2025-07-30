#!/usr/bin/env bash
set -euo pipefail

DEFAULT_DEST="/usr/local/bin"
XDG_LOCAL_BIN="${XDG_DATA_HOME:-$HOME/.local}/bin"

if [ -w "$DEFAULT_DEST" ]; then
  DESTDIR="$DEFAULT_DEST"
else
  DESTDIR="$XDG_LOCAL_BIN"
fi

DESTDIR="${DESTDIR:-$DEFAULT_DEST}"

echo "Installing git-sync → $DESTDIR/git-sync"

mkdir -p "$DESTDIR"

install -m 755 scripts/git-sync "$DESTDIR/git-sync" \
  && echo "✓ Installed git-sync to $DESTDIR" \
  || { echo "❌ Failed to install to $DESTDIR"; exit 1; }

if ! command -v git-sync &>/dev/null; then
  echo
  echo "⚠️  '$DESTDIR' is not in your PATH."
  echo "    Add to your shell profile, e.g.:"
  echo "      export PATH=\"$DESTDIR:\$PATH\""
fi

# Cria o alias Git
echo "Adding Git alias: git sync → git-sync"
git config --global alias.sync "!git-sync"

cat <<EOF

✔ Installation complete!

You can now run:
  git sync feature/my-feature

EOF
