#!/bin/bash

# Get the version number from package.json
VERSION=$(jq -r .version package.json)

# Check if jq command succeeded
if [ $? -ne 0 ] || [ -z "$VERSION" ]; then
  echo "Error: Could not retrieve the version number from package.json."
  exit 1
fi

# Construct the gh release create command
COMMAND=("gh" "release" "create" "v$VERSION" "--draft" "--title" "v$VERSION Release")

# Display the command for confirmation
echo "${COMMAND[@]}"

# Run the command
"${COMMAND[@]}"
