#!/usr/bin/env bash
# Performs quick tests of git aliases defined in recon.dev.config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
source ../../testing/test-helpers.sh

# Path to the configuration file being tested. Must be an absolute path, because `git -c` doesn't accept relative paths.
DEV_GIT_CONFIG="$HOME/repos/projects/git-recon/git/git-recon.gitconfig"

devGit() {
  git -c include.path="$DEV_GIT_CONFIG" "$@"
}

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

  ( it "runs recent-local";
    assert_no_error devGit recent-local
  )

  ( it "runs recent-local-legend";
    assert_no_error devGit recent-local-legend
  )

  ( it "runs recent-local-usage";
    assert_no_error devGit recent-local-usage
  )

  ( it "runs recent-prompt-local";
    output=$(echo | devGit recent-prompt-local 2>&1)
    assert_success $? "$output"
  )

  ( it "runs recent-prompt-local-usage";
    assert_no_error devGit recent-prompt-local-usage
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

  ( it "runs recent-prompt-remote";
    output=$(echo | devGit recent-prompt-remote 2>&1)
    assert_success $? "$output"
  )

  ( it "runs recent-prompt-remote-usage";
    assert_no_error devGit recent-prompt-remote-usage
  )

  ( it "runs with-tracking";
    assert_no_error devGit with-tracking
  )
)
