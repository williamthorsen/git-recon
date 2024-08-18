#!/bin/bash

# List all git configs in order of precedence (highest to lowest)
git config --list --show-origin | grep 'file:' | awk '{print $1}' | sed -e 's/^file://g' -e "s|$HOME|~|" | sort | uniq
