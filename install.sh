#!/usr/bin/env bash
set -euo pipefail

GIT_FLOW="git-flow"
REPO="EvandroWeb/${GIT_FLOW}"
BASE_RAW="https://raw.githubusercontent.com/${REPO}/main/scripts"
BIN_PATH="/usr/local/bin/${GIT_FLOW}"
CONFIG_ALIAS=true

error() { printf '❌ Error: %s\n' "$1" >&2; exit 1; }

echo "→ Installing ${GIT_FLOW}…"

if ! command -v curl >/dev/null 2>&1; then
  error "curl is not installed. Please install curl."
fi

if ! sudo curl -fsSL "${BASE_RAW}/${GIT_FLOW}" -o "${BIN_PATH}"; then
  error "Failed to download ${BASE_RAW}/${GIT_FLOW} with sudo"
fi

if ! sudo chmod +x "${BIN_PATH}"; then
  error "Failed to change permissions for ${BIN_PATH}"
fi

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --no-alias)
      CONFIG_ALIAS=false
      shift
      ;;
    *)
      shift
      ;;
  esac
done

if [ "$CONFIG_ALIAS" = true ]; then
  git config --global alias.flow     "!${GIT_FLOW}"
  git config --global alias.sync     "!${GIT_FLOW} sync"
  git config --global alias.feature  "!${GIT_FLOW} feature"
  git config --global alias.hotfix   "!${GIT_FLOW} hotfix"
  git config --global alias.bugfix   "!${GIT_FLOW} bugfix"
  git config --global alias.propose  "!${GIT_FLOW} propose"
  git config --global alias.pr       "!${GIT_FLOW} propose"
fi

cat <<EOF

✔ Installation complete!
→ Installed at: ${BIN_PATH}

You can now run:
  git flow sync [--push]
  git flow feature [--push] <name|feature/<name>>
  git flow hotfix  [--push] <name|hotfix/<name>>
  git flow bugfix  [--push] <name|bugfix/<name>>
  git flow propose

EOF
