#!/bin/bash

# Get the version number from package.json
VERSION=$(jq -r .version package.json)

# Check if jq command succeeded
if [ $? -ne 0 ] || [ -z "$VERSION" ]; then
  echo "Error: Could not retrieve the version number from package.json."
  exit 1
fi

# Construct the git tag command
COMMAND=("git" "tag" "--annotate" "v$VERSION" "--message" "Release v$VERSION")

# Display the command for confirmation
echo "git tag --annotate v$VERSION --message \"Release v$VERSION\""


# Run the command
"${COMMAND[@]}"
