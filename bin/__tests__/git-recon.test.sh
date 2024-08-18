#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Change to the directory where the script is located
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

# Load the test helpers
source ../../testing/test-helpers.sh

BREW_PREFIX=$(brew --prefix)

# Create a temporary directory for testing
TEMP_DIR=$(mktemp -d)
GITCONFIG_PATH="$TEMP_DIR/test.gitconfig"
GIT_RECON_SCRIPT="../../bin/git-recon.sh"

# Ensure the temporary directory is created
mkdir -p "$TEMP_DIR"

# Function to set up the environment for each test
prepare_environment() {
  if [ -f "$1" ]; then
    cp "$1" "$GITCONFIG_PATH"
  else
    echo -e "\n\033[0;31mError: File $1 does not exist.\033[0m" >&2
    exit 1
  fi
}

# Function to run the script in its directory
run_script() {
  (
    cd "$(dirname "$GIT_RECON_SCRIPT")" || exit 1
    "./$(basename "$GIT_RECON_SCRIPT")" "$@"
  )
}

# Safely clean up the temporary directory after the tests
cleanup_temp_dir() {
  if [[ "$TEMP_DIR" == /tmp/* || "$TEMP_DIR" == /var/folders/* ]]; then
    rm -rf "$TEMP_DIR"
  else
    echo "Warning: Skipping cleanup of unexpected temporary directory $TEMP_DIR"
  fi
}

# Test cases
set_up_tests

describe "git-recon.sh installation process"; (

  ( it "handles missing test.gitconfig file by creating one with Git-Recon configuration";
    rm -f "$GITCONFIG_PATH"  # Ensure the test.gitconfig file does not exist
    output=$(run_script --install --config-path="$GITCONFIG_PATH" 2>&1)
    assert_success $? "$output"
    assert_file_contains "$GITCONFIG_PATH" "[include]"
    assert_file_contains "$GITCONFIG_PATH" "path = $BREW_PREFIX/share/gitconfig.d/git-recon.gitconfig"
  )

  ( it "adds [include] section to existing test.gitconfig without include section";
    prepare_environment "./fixtures/without-include.gitconfig"
    output=$(run_script --install --config-path="$GITCONFIG_PATH" 2>&1)
    assert_success $? "$output"
    assert_file_contains "$GITCONFIG_PATH" "[include]"
    assert_file_contains "$GITCONFIG_PATH" "path = $BREW_PREFIX/share/gitconfig.d/git-recon.gitconfig"
  )

  ( it "adds path to existing test.gitconfig with [include] section but without any paths";
    prepare_environment "./fixtures/with-include.gitconfig"
    output=$(run_script --install --config-path="$GITCONFIG_PATH" 2>&1)
    assert_success $? "$output"
    assert_file_contains "$GITCONFIG_PATH" "path = $BREW_PREFIX/share/gitconfig.d/git-recon.gitconfig"
  )

  ( it "adds path to existing paths under [include] section in test.gitconfig";
    prepare_environment "./fixtures/with-path.gitconfig"
    output=$(run_script --install --config-path="$GITCONFIG_PATH" 2>&1)
    assert_success $? "$output"
    assert_file_contains "$GITCONFIG_PATH" "path = $BREW_PREFIX/share/gitconfig.d/git-recon.gitconfig"
  )

  ( it "does nothing if path already exists in test.gitconfig";
    prepare_environment "./fixtures/with-path.gitconfig"
    # Add the path to the test.gitconfig file
    run_script --install --config-path="$GITCONFIG_PATH" > /dev/null 2>&1
    # Add again to test how the script handles an existing path
    output=$(run_script --install --config-path="$GITCONFIG_PATH" 2>&1)
    assert_success $? "$output"
    assert_match "$output" "Nothing to do"
  )

  # TODO: Handle edge cases, such as when `path` exists but is wrongly placed outside of the `include` section.
)

cleanup_temp_dir
