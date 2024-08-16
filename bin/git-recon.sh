#!/bin/bash

set -e

BREW_PREFIX=$(brew --prefix)
GITCONFIG_PATH="$HOME/.gitconfig"
GIT_RECON_CONFIG_PATH="$BREW_PREFIX/etc/gitconfig.d/git-recon.gitconfig"
INCLUDE_SECTION="[include]\n\tpath = $GIT_RECON_CONFIG_PATH\n"

install_config() {
  if [ -f "$GITCONFIG_PATH" ]; then
    if grep -q "$GIT_RECON_CONFIG_PATH" "$GITCONFIG_PATH"; then
      echo "Git-Recon configuration already included in $GITCONFIG_PATH"
    else
      echo "Adding Git-Recon configuration to $GITCONFIG_PATH..."
      sed -i '' "/\[include\]/ a\\
      \ \ \ \ path = $GIT_RECON_CONFIG_PATH
      " "$GITCONFIG_PATH" || echo -e "$INCLUDE_SECTION" >> "$GITCONFIG_PATH"
    fi
  else
    echo "Creating $GITCONFIG_PATH with Git-Recon configuration"
    echo -e "$INCLUDE_SECTION" > "$GITCONFIG_PATH"
  fi
}

case "$1" in
  --install)
    install_config
    ;;
  *)
    echo "Usage: git-recon --install"
    exit 1
    ;;
esac
