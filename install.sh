#!/usr/bin/env bash
set -euo pipefail

GIT_FLOW="git-flow"
REPO="EvandroWeb/${GIT_FLOW}"
BASE_RAW="https://raw.githubusercontent.com/${REPO}/main/scripts"
BIN_PATH="/usr/local/bin/${GIT_FLOW}"
CONFIG_ALIAS=true

echo "→ Installing ${GIT_FLOW} → ${BIN_PATH}"
if [ -w "$(dirname "${BIN_PATH}")" ]; then
  if ! curl -fsSL "${BASE_RAW}/${GIT_FLOW}" -o "${BIN_PATH}"; then
    echo "Error: Failed to download ${BASE_RAW}/${GIT_FLOW}" >&2
    exit 1
  fi
else
  if ! sudo curl -fsSL "${BASE_RAW}/${GIT_FLOW}" -o "${BIN_PATH}"; then
    echo "Error: Failed to download ${BASE_RAW}/${GIT_FLOW} with sudo" >&2
    exit 1
  fi
fi

sudo chmod +x "${BIN_PATH}"

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

You can now run:
  git flow sync [--push]
  git flow feature [--push] <name|feature/<name>>
  git flow hotfix  [--push] <name|hotfix/<name>>
  git flow bugfix  [--push] <name|bugfix/<name>>
  git flow propose

EOF
