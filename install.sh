#!/usr/bin/env bash
set -euo pipefail

REPO="EvandroWeb/git-flow"
BRANCH="main"
BASE_URL="https://raw.githack.com/${REPO}/${BRANCH}/scripts"

BIN_NAME="git-flow"
BIN_PATH="/usr/local/bin/${BIN_NAME}"

echo "→ Installing ${BIN_NAME} → ${BIN_PATH}"
if [ -w "$(dirname "$BIN_PATH")" ]; then
  curl -fsSL "${BASE_RAW}/${BIN_NAME}" -o "${BIN_PATH}"
else
  sudo curl -fsSL "${BASE_RAW}/${BIN_NAME}" -o "${BIN_PATH}"
fi

sudo chmod +x "${BIN_PATH}"

git config --global alias.flow "!${BIN_NAME}"

cat <<EOF

✔ Installation complete!

You can now run:
  git flow sync [--push]
  git flow feature [--push] <name|feature/<name>>
  git flow hotfix  [--push] <name|hotfix/<name>>
  git flow bugfix  [--push] <name|bugfix/<name>>
  git flow propose

EOF
