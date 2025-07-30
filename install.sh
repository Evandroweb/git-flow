#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME=$(basename "$0")
DEFAULT_DEST="/usr/local/bin"
FALLBACK_DEST="${XDG_DATA_HOME:-$HOME/.local}/bin"

do_install() {
  local src=$1 dst=$2
  if [ -w "$(dirname "$dst")" ]; then
    install -m755 "$src" "$dst"
  else
    echo "→ Need sudo to install to $dst"
    sudo install -m755 "$src" "$dst"
  fi
}

CMDS=(git-sync)

for cmd in "${CMDS[@]}"; do
  src="scripts/$cmd"
  dst="$DEFAULT_DEST/$cmd"
  echo "Installing $cmd → $dst"
  if do_install "$src" "$dst"; then
    echo "✓ $cmd installed to $dst"
  else
    echo "⚠️  Could not install to $DEFAULT_DEST, skipping..."
  fi
done

if ! command -v git-sync &>/dev/null; then
  echo
  echo "→ Falling back to user directory: $FALLBACK_DEST"
  mkdir -p "$FALLBACK_DEST"
  for cmd in "${CMDS[@]}"; do
    src="scripts/$cmd"
    dst="$FALLBACK_DEST/$cmd"
    echo "Installing $cmd → $dst"
    install -m755 "$src" "$dst"
  done
  echo
  echo "⚠️  NOTICE: $FALLBACK_DEST must be on your PATH."
  echo "   But to avoid manual steps, re‑run with sudo to install globally:"
  echo "     curl … | sudo bash"
fi

echo "Adding Git alias: git sync → git-sync"
git config --global alias.sync "!git-sync"

cat <<EOF

✔ Installation complete!

You can now run:
  git sync feature/my-feature

EOF
