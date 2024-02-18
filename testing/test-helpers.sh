#!/usr/bin/env bash

last_suite_name_file=$(mktemp)
error_pipe=$(mktemp)
if [ -p "$error_pipe" ]; then
  mkfifo "$error_pipe"
fi

suite_name="undefined"
test_name="undefined"

assert_equal() {
  local expected=$1
  local actual=$2

  if [[ "$expected" == "$actual" ]]; then
    echo " ✅ "
  else
    count_failure
    echo " FAILED ❌ "
    echo "  Expected: $expected"
    echo "  Actual:   $actual"
    return 1
  fi
}

assert_match() {
  local expected=$1
  local actual=$2

  if [[ "$(remove_colors "$actual")" =~ $expected ]]; then
    echo " ✅ "
  else
    count_failure
    echo " FAILED ❌ "
    echo "  Expected: $expected"
    echo "  Actual:   $actual"
    return 1
  fi
}

before_each() {
  # Not strictly needed for this, but retained as a placeholder.
  # Remember that each test runs in its own subshell, so writes to variables are not persisted.
  test_name="undefined"
}

on_test_completion () {
  report_errors
  rm "$error_pipe"
  rm "$last_suite_name_file"
}

count_failure() {
  echo "$suite_name | $test_name" >> "$error_pipe" &
}

describe() {
  suite_name=$1
}

describe_suite() {
  last_suite_name=$(cat "$last_suite_name_file")
  if [ "$suite_name" == "$last_suite_name" ]; then
    return
  fi
  echo -e "\n$suite_name"
  echo "$suite_name" > "$last_suite_name_file"
}

describe_test() {
  printf "▶︎ it $test_name"
}

it() {
  test_name=$1
  describe_suite
  describe_test
}

remove_colors() {
  echo $1 | sed 's/\x1b\[[0-9;]*m//g'
}

remove_escapes() {
  echo "$1" | sed -E 's/\x1B\[[0-9;]*[JKmsu]//g'
}

report_errors() {
  local failed_tests
  local error_count

  failed_tests=$(uniq "$error_pipe")
  error_count=$(echo "$failed_tests" | wc -l)

  echo "-----"

 if [[ -z "$failed_tests" ]]; then
    echo "Tests: All tests passed"
    return 0
  else
    echo "Tests: $error_count failed ❌ "
    echo "$failed_tests" | sed 's/^/  /'
    return 1
  fi
}

setup_tests() {
  trap on_test_completion EXIT
}
