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

# Construct the git tag command
COMMAND=("git" "tag" "--annotate" "v$VERSION" "--message" "Release v$VERSION")

# Display the command for confirmation
echo "git tag --annotate v$VERSION --message \"Release v$VERSION\""


# Run the command
"${COMMAND[@]}"
