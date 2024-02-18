#!/usr/bin/env bash
# Performs quick tests of git aliases defined in recon.dev.config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
source ../../testing/test-helpers.sh

# Path to the configuration file being tested. Must be an absolute path, because `git -c` doesn't accept relative paths.
DEV_GIT_CONFIG="$HOME/repos/projects/git-recon/git/recon.dev.gitconfig"

devGit() {
  git -c include.path="$DEV_GIT_CONFIG" "$@"
}

# endregion

setup_tests

describe "git aliases"; (
  # Early exit if the configuration file is not found.
  it "has a valid configuration file";
  output=$(devGit config --list 2>&1)
  assert_critical_success $? "$output"

  it "runs format-tracking"; (
    assert_no_error devGit format-tracking "my-local-branch [behind 2]"
  )

  it "runs list-recent-branches"; (
    assert_no_error devGit list-recent-branches
  )

  it "runs list-recent-remote-branches"; (
    assert_no_error devGit list-recent-remote-branches
  )

  it "runs map-remote-branches-to-local-branches"; (
    assert_no_error devGit map-remote-branches-to-local-branches
  )

  it "runs recent-branches"; (
    output=$(devGit recent-branches 2>&1)
    assert_success $? "$output"
  )

  it "runs recent-branches-prompt"; (
    output=$(echo | devGit recent-branches-prompt 2>&1)
    assert_success $? "$output"
  )

  it "runs recent-remote-branches"; (
    assert_no_error devGit recent-remote-branches
  )

  it "runs recent-remote-branches-prompt"; (
    output=$(echo | devGit recent-remote-branches-prompt 2>&1)
    assert_success $? "$output"
  )

  it "runs show-recent-branches-prompt-usage"; (
    assert_no_error devGit show-recent-branches-prompt-usage
  )

  it "runs show-recent-branches-usage"; (
    assert_no_error devGit show-recent-branches-usage
  )

  it "runs show-recent-remote-branches-prompt-usage"; (
    assert_no_error devGit show-recent-remote-branches-prompt-usage
  )

  it "show-recent-remote-branches-prompt-usage"; (
    assert_no_error devGit show-recent-remote-branches-prompt-usage
  )
)
