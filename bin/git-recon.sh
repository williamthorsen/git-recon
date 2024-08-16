#!/bin/bash

set -e

BREW_PREFIX=$(brew --prefix)
GITCONFIG_PATH="$HOME/.gitconfig"
GIT_RECON_CONFIG_PATH="$BREW_PREFIX/etc/gitconfig.d/git-recon.gitconfig"
INCLUDE_SECTION="[include]\n    path = $GIT_RECON_CONFIG_PATH\n"

install_config() {
  if [ -f "$GITCONFIG_PATH" ]; then
    if grep -q "$GIT_RECON_CONFIG_PATH" "$GITCONFIG_PATH"; then
      echo "Git-Recon configuration already included in $GITCONFIG_PATH"
    elif grep -q "^\[include\]" "$GITCONFIG_PATH"; then
      echo "Adding Git-Recon configuration to $GITCONFIG_PATH..."
      sed -i '' "/\[include\]/ a\\
$(printf '    ')path = $GIT_RECON_CONFIG_PATH
" "$GITCONFIG_PATH"
    else
      echo "Adding new [include] section with Git-Recon configuration to $GITCONFIG_PATH..."
      printf "\n[include]\n    path = %s\n" "$GIT_RECON_CONFIG_PATH" >> "$GITCONFIG_PATH"
    fi
  else
    echo "Creating $GITCONFIG_PATH with Git-Recon configuration"
    echo -e "$INCLUDE_SECTION" > "$GITCONFIG_PATH"
  fi
}

usage() {
  echo "Usage: git-recon --install [--config-path=/path/to/.gitconfig]"
  exit 1
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --install)
      ACTION="install"
      ;;
    --config-path=*)
      GITCONFIG_PATH="${1#*=}"
      ;;
    *)
      usage
      ;;
  esac
  shift
done

if [ "$ACTION" = "install" ]; then
  install_config
else
  usage
fi
