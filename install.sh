#!/usr/bin/env bash
set -euo pipefail

REPO="EvandroWeb/git-flow"
BRANCH="main"
BASE_URL="https://raw.githack.com/${REPO}/${BRANCH}/scripts"

DEFAULT_DEST="/usr/local/bin"
CMDS=(git-sync)

do_install() {
  local url=$1 dst=$2
  echo "→ Downloading $url"
  if [ -w "$(dirname "$dst")" ]; then
    curl -fsSL "$url" -o "$dst"
  else
    sudo curl -fsSL "$url" -o "$dst"
  fi
  sudo chmod +x "$dst"
}

for cmd in "${CMDS[@]}"; do
  url="${BASE_URL}/${cmd}"
  dst="${DEFAULT_DEST}/${cmd}"
  echo "Installing ${cmd} → ${dst}"
  do_install "$url" "$dst" \
    && echo "✓ ${cmd} installed"
done

git config --global alias.sync "!git-sync"
git config --global alias['sync-push'] '!git sync --push'

cat <<EOF

✔ Installation complete!  
You can now run:
  git sync feature/my-feature

EOF
