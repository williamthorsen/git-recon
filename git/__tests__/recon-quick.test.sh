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

set_up_tests

describe "git aliases"; (
  # Early exit if the configuration file is not found.
  if ! ( it "has a valid configuration file";
    output=$(devGit config --list 2>&1)
    assert_critical_success $? "$output"
  ); then
    echo "Aborting"
    exit 1
  fi

  ( it "runs branches-with-tracking";
    assert_no_error devGit branches-with-tracking
  )

  ( it "runs decorated";
    assert_no_error devGit decorated
  )

  ( it "runs decorated-remote";
    assert_no_error devGit decorated-remote
  )

  ( it "runs format-tracking";
    assert_no_error devGit format-tracking "my-local-branch [behind 2]"
  )

  ( it "runs recent";
    assert_no_error devGit recent
  )

  ( it "runs recent";
    assert_no_error devGit recent-legend
  )

  ( it "runs recent-usage";
    assert_no_error devGit recent-usage
  )

  ( it "runs recent-prompt";
    output=$(echo | devGit recent-prompt 2>&1)
    assert_success $? "$output"
  )

  ( it "runs recent-prompt-usage";
    assert_no_error devGit recent-prompt-usage
  )

  ( it "runs recent-remote";
    assert_no_error devGit recent-remote
  )

  ( it "runs recent-remote-legend";
    assert_no_error devGit recent-remote-legend
  )

  ( it "runs recent-remote-usage";
    assert_no_error devGit recent-remote-usage
  )

  ( it "runs recent-remote-prompt";
    output=$(echo | devGit recent-remote-prompt 2>&1)
    assert_success $? "$output"
  )

  ( it "runs recent-remote-prompt-usage";
    assert_no_error devGit recent-remote-prompt-usage
  )

  ( it "runs with-tracking";
    assert_no_error devGit with-tracking
  )
)
