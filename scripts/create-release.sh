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

# Get the current UTC date in YYYY-MM-DD format
DATE=$(date -u +"%Y-%m-%d")

# Construct the gh release create command
# Note: Currently, notes for all releases are included and must be manually edited.
# TODO: Extract only the notes for the current release.
COMMAND=("gh" "release" "create" "v$VERSION" "--draft" "--generate-notes" "--notes-file=CHANGELOG.md" "--title" "v$VERSION - $DATE")

# Display the command for confirmation
echo "${COMMAND[@]}"

# Run the command
"${COMMAND[@]}"
