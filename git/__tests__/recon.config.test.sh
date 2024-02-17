#!/usr/bin/env bash
# This script is used to test git aliases defined in recent.config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
source ../../testing/test-helpers.sh

# Path to the configuration file being tested. Must be an absolute path, because `git -c` doesn't accept relative paths.
DEV_GIT_CONFIG="$HOME/repos/projects/git-recon/git/recon.dev.gitconfig"

devGit() {
  git -c include.path="$DEV_GIT_CONFIG" "$@"
}
# endregion

describe "format-tracking"; (
  it "replaces [behind X] with ↓X"; (
    input="my-local-branch [behind 2]";

    expected='my-local-branch ↓2';
    actual=$(devGit format-tracking "$input")

    assert_equal "$expected" "$actual"
  )

  it "replaces [ahead X] with ↑X"; (
    input="my-local-branch [ahead 3]";

    expected='my-local-branch ↑3';
    actual=$(devGit format-tracking "$input")

    assert_equal "$expected" "$actual"
  )

  it "replaces [ahead X, behind Y] with ↑X↓Y"; (
    input="my-local-branch [ahead 1, behind 2]";

    expected='my-local-branch ↑1↓2';
    actual=$(devGit format-tracking "$input")

    assert_equal "$expected" "$actual"
  )

  it "replaces [gone] with {gone symbol}"; (
    input="my-local-branch [gone]";

    expected='my-local-branch ⚠️';
    actual=$(devGit format-tracking "$input")

    assert_equal "$expected" "$actual"
  )

  it "replaces [synced] with ✔"; (
    input="my-local-branch [synced]";

    expected='my-local-branch ✔';
    actual=$(devGit format-tracking "$input")

    assert_match "$expected" "$actual"
  )
)

describe "list-recent-branches"; (
  it "lists recent branches"; (
    expected='.+|.+|\w{7}|git/1|(\[.*\])?|origin/git/1';
    actual=$(devGit list-recent-branches 1 | grep 'git/1$')
    assert_match "$expected" "$actual"
  )
)
