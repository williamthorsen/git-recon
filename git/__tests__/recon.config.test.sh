#!/usr/bin/env bash

# This script is used to test git aliases defined in recent.config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
source ../../testing/test-helpers.sh

# Path to the configuration file being tested. Must be an absolute path, because `git -c` doesn't accept relative paths.
DEV_GIT_CONFIG="$HOME/repos/projects/git-recon/git/recon.dev.gitconfig"
BRANCH_PREFIX="automated-tests"
# NONCE=$(date +%Y%m%d-%H%M%S)-$RANDOM
SUCCESS_CODE=0
FAILURE_CODE=1

# region | Helper functions
devGit() {
  git -c include.path="$DEV_GIT_CONFIG" "$@"
}

branchExists() {
  local branch_name="$1"
  git show-ref --verify --quiet "refs/heads/$branch_name"
}

safeCreateTestBranch() {
  local branch_name="$1"
  if [[ -z "$branch_name" ]]; then
    echo "Branch name is required." >&2
    return 1
  fi

  if ! branchExists "$branch_name"; then
    if ! git branch "$branch_name"; then
      return 1
    fi
  fi
}

safeDeleteBranch() {
  local branch_name="$1"
  if [[ -z "$branch_name" ]]; then
    echo "Branch name is required." >&2
    exit 1
  fi

  # Safeguard important branches: main and next
  if [[ "$branch_name" == "main" || "$branch_name" == "next" ]]; then
    echo "Cannot delete branch $branch_name." >&2
    exit 1
  fi

  git branch -D "$branch_name" > /dev/null 2>&1 # Delete the branch if it exists.
}
# endregion

set_up_tests || exit 1

describe "format-tracking"; (
  ( it "replaces [behind X] with ↓X";
    input="my-local-branch [behind 2]"

    expected='my-local-branch ↓2';
    actual=$(devGit format-tracking "$input")

    assert_equal "$expected" "$actual"
  )

  ( it "replaces [ahead X] with ↑X";
    input="my-local-branch [ahead 3]"

    expected='my-local-branch ↑3'
    actual=$(devGit format-tracking "$input")

    assert_equal "$expected" "$actual"
  )

  ( it "replaces [ahead X, behind Y] with ↑X↓Y";
    input="my-local-branch [ahead 1, behind 2]"

    expected='my-local-branch ↑1↓2'
    actual=$(devGit format-tracking "$input")

    assert_equal "$expected" "$actual"
  )

  ( it "replaces [gone] with {gone symbol}";
    input="my-local-branch [gone]"

    expected='my-local-branch ⚠️'
    actual=$(devGit format-tracking "$input")

    assert_equal "$expected" "$actual"
  )

  ( it "replaces [synced] with ✔";
    input="my-local-branch [synced]"

    expected='my-local-branch ✔'
    actual=$(devGit format-tracking "$input")

    assert_match "$expected" "$actual"
  )
)

describe "is-tracking-branch"; (
  ( it "returns 0 code for a tracking branch";
    devGit is-tracking-branch "main"

    assert_equal $? $SUCCESS_CODE
  )

  ( it "returns 1 for a non-tracking branch";
    branch_name="$BRANCH_PREFIX/non-tracking-branch"
    safeCreateTestBranch "$branch_name" || exit 1

    devGit is-tracking-branch "$branch_name"

    assert_equal $? $FAILURE_CODE
  )

  ( it "returns 1 for a nonexistent branch";
    devGit is-tracking-branch "nonexistent-branch"

    assert_equal $? $FAILURE_CODE
  )
)

describe "list-recent-branches"; (
  ( it "lists recent branches";
    expected='.+|.+|\w{7}|git/1|(\[.*\])?|origin/git/1'
    actual=$(devGit list-recent-branches 1 | grep 'git/1$')
    assert_match "$expected" "$actual"
  )
)
