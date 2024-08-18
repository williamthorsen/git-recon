#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Change directory to the root of the repository
cd "$(git rev-parse --show-toplevel)" || exit 1

# Get the version number from metadata.ts
if ! VERSION=$(deno run --allow-read scripts/helpers/readVersionNumber.ts) || [ -z "$VERSION" ]; then
  echo "Error: Could not retrieve the version number from package.json."
  exit 1
fi

# Construct the gh release create command
COMMAND=("gh" "release" "create" "v$VERSION" "--draft" "--title" "v$VERSION Release")

# Display the command for confirmation
echo "${COMMAND[@]}"

# Run the command
"${COMMAND[@]}"
