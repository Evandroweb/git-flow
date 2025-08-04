#!/usr/bin/env bash
set -euo pipefail

GIT_FLOW="git-flow"

REPO="EvandroWeb/${GIT_FLOW}"
BASE_RAW="https://raw.githack.com/${REPO}/main/scripts"

BIN_PATH="/usr/local/bin/${GIT_FLOW}"

echo "→ Installing ${GIT_FLOW} → ${BIN_PATH}"
if [ -w "$(dirname "$BIN_PATH")" ]; then
  curl -fsSL "${BASE_RAW}/${GIT_FLOW}" -o "${BIN_PATH}"
else
  sudo curl -fsSL "${BASE_RAW}/${GIT_FLOW}" -o "${BIN_PATH}"
fi

sudo chmod +x "${BIN_PATH}"

git config --global alias.flow     "!${GIT_FLOW}"
git config --global alias.sync     "!${GIT_FLOW} sync"
git config --global alias.feature  "!${GIT_FLOW} feature"
git config --global alias.hotfix   "!${GIT_FLOW} hotfix"
git config --global alias.bugfix   "!${GIT_FLOW} bugfix"
git config --global alias.propose  "!${GIT_FLOW} propose"
git config --global alias.pr       "!${GIT_FLOW} propose"

cat <<EOF

✔ Installation complete!

You can now run:
  git flow sync [--push]
  git flow feature [--push] <name|feature/<name>>
  git flow hotfix  [--push] <name|hotfix/<name>>
  git flow bugfix  [--push] <name|bugfix/<name>>
  git flow propose

EOF
