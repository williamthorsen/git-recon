#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

BREW_PREFIX=$(brew --prefix)
GITCONFIG_PATH="$HOME/.gitconfig"
GIT_RECON_CONFIG_PATH="$BREW_PREFIX/etc/gitconfig.d/git-recon.gitconfig"
INCLUDE_SECTION="[include]\n    path = $GIT_RECON_CONFIG_PATH\n"

install_config() {
  echo "Starting installation of Git-Recon configuration..."

  if [ -f "$GITCONFIG_PATH" ]; then
    if grep -q "$GIT_RECON_CONFIG_PATH" "$GITCONFIG_PATH"; then
      echo "Nothing to do. Git-Recon configuration is already included in $GITCONFIG_PATH."
      echo "Done."
      exit 0
    fi
    echo "Modifying $GITCONFIG_PATH..."
    if grep -q "^\[include\]" "$GITCONFIG_PATH"; then
      sed -i '' "/\[include\]/ a\\
$(printf '    ')path = $GIT_RECON_CONFIG_PATH
" "$GITCONFIG_PATH"
    else
      printf "\n[include]\n    path = %s\n" "$GIT_RECON_CONFIG_PATH" >> "$GITCONFIG_PATH"
      echo "Added [include] section."
    fi
    echo "Added Git-Recon configuration path: $GIT_RECON_CONFIG_PATH..."
  else
    echo -e "$INCLUDE_SECTION" > "$GITCONFIG_PATH"
    echo "Created $GITCONFIG_PATH with Git-Recon configuration."
  fi

  echo "Git-Recon configuration path was successfully added to $GITCONFIG_PATH."
  echo "Done."
}

usage() {
  echo "Usage: git-recon --install [--config-path=PATH]"
  echo "  --install                Install the Git-Recon configuration."
  echo "  --config-path=PATH       Specify the path to the .gitconfig file. Defaults to ~/.gitconfig."
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
      echo "Error: Invalid option '$1'"
      usage
      ;;
  esac
  shift
done

if [ "$ACTION" = "install" ]; then
  install_config
else
  echo "Error: No action specified."
  usage
fi
