#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Change to the repo root
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

bin/git-recon.sh --install --config-path=bin/__tests__/without-include.gitconfig
echo ""
bin/git-recon.sh --install --config-path=bin/__tests__/with-include.gitconfig
echo ""
bin/git-recon.sh --install --config-path=bin/__tests__/with-path.gitconfig
echo ""
bin/git-recon.sh --install --config-path=bin/__tests__/with-recon-path.gitconfig
echo ""
