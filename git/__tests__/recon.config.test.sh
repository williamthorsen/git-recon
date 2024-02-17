#/usr/bin/env bash
# This script is used to test git aliases defined in recent.config

# Path to the configuration file being tested. Must be an absolute path, because `git -c` doesn't accept relative paths.
DEV_GIT_CONFIG='~/repos/projects/git-recon/git/recon.dev.gitconfig'

suite_name="undefined"
last_suite_name="undefined"
test_name="undefined"
failure_count=0

assert_equal() {
  local expected=$1
  local actual=$2

  describe_suite
  describe_test

  if [[ "$expected" == "$actual" ]]; then
    echo " ✅ "
  else
    let failure_count=failure_count+1
    echo " FAILED ❌ "
    echo "  Expected: $expected"
    echo "  Actual:   $actual"
    return 1
  fi
}

assert_match() {
  local expected=$1
  local actual=$2

  describe_suite
  describe_test

  if [[ "$(remove_colors "$actual")" =~ $expected ]]; then
    echo " ✅ "
  else
    let failure_count=failure_count+1
    echo " FAILED ❌ "
    echo "  Expected: $expected"
    echo "  Actual:   $actual"
    return 1
  fi
}


before_each() {
  # Reset the suite and test names
  suite_name="undefined"
  test_name="undefined"
}

describe() {
  suite_name=$1
}

describe_suite() {
  if [ "$suite_name" == "$last_suite_name" ]; then
    return
  fi
  echo "\n$suite_name"
  last_suite_name=$suite_name
}

describe_test() {
  printf "▶︎ it $test_name"
}

it() {
  before_each
  test_name=$1
}

remove_colors() {
  echo $1 | sed 's/\x1b\[[0-9;]*m//g'
}

remove_escapes() {
  echo "$1" | sed -E 's/\x1B\[[0-9;]*[JKmsu]//g'
}

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

if ((failure_count > 0)); then
  echo "Failed tests: $failure_count"
  exit 1
fi
