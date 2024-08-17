#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Change to the repo root
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

source testing/test-helpers.sh

FIXTURE_PATH="local/tmp/$(generate_timestamp)"
mkdir -p "$FIXTURE_PATH"

# Copy the test fixtures to the temporary directory
cp bin/__tests__/fixtures/* "$FIXTURE_PATH"

bin/git-recon.sh --install --config-path="$FIXTURE_PATH/without-include.gitconfig"
echo
bin/git-recon.sh --install --config-path="$FIXTURE_PATH/with-include.gitconfig"
echo
bin/git-recon.sh --install --config-path="$FIXTURE_PATH/with-path.gitconfig"
echo
bin/git-recon.sh --install --config-path="$FIXTURE_PATH/with-recon-path.gitconfig"
echo
bin/git-recon.sh --install --config-path="$FIXTURE_PATH/test.gitconfig"
