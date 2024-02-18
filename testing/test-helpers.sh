#!/usr/bin/env bash

last_suite_name_file=$(mktemp)
test_has_failure=0
error_pipe=$(mktemp)
if [ -p "$error_pipe" ]; then
  mkfifo "$error_pipe"
fi

suite_name="undefined"
test_name="undefined"

assert_critical_success() {
  local status=$1
  local message=${2:-"Fatal error. Exiting."}

  # Check if the return value indicates a fatal error
  if [[ $status -ne 0 ]]; then
    count_failure
    echo "  Error: $message"
    return 1
  fi
}

assert_equal() {
  local expected=$1
  local actual=$2

  if [[ ! "$expected" == "$actual" ]]; then
    count_failure
    echo "  Expected: $expected"
    echo "  Actual:   $actual"
    return 1
  fi
}

assert_match() {
  local expected=$1
  local actual=$2

  if [[ ! "$(remove_colors "$actual")" =~ $expected ]]; then
    count_failure
    echo "  Expected: $expected"
    echo "  Actual:   $actual"
    return 1
  fi
}

assert_no_error() {
  local output

  output=$("$@" 2>&1)
  local status=$?

  if [[ $status -ne 0 ]]; then
    count_failure
    echo "  Error: $output"
    return 1
  fi
}

assert_success() {
  local status=$1
  local output=$2

  if [[ $status -ne 0 ]]; then
    count_failure
    echo "  Error: $output"
    return 1
  fi
}

before_each() {
  # Not strictly needed for this, but retained as a placeholder.
  # Remember that each test runs in its own subshell, so writes to variables are not persisted.
  test_name="undefined"
}

count_failure() {
  if ((test_has_failure == 0)); then
    test_has_failure=1
    show_failure
    echo "$suite_name | $test_name" >> "$error_pipe" &
  fi
}

describe() {
  suite_name=$1
}

describe_suite_on_first_test() {
  last_suite_name=$(cat "$last_suite_name_file")
  if [ "$suite_name" == "$last_suite_name" ]; then
    return
  fi
  echo -e "\n$suite_name"
  echo "$suite_name" > "$last_suite_name_file"
}

describe_test() {
  printf "▶︎ it $test_name "
}

it() {
  set_up_test "$1"
  describe_suite_on_first_test
  describe_test
}

on_teardown () {
  report_errors
  rm "$error_pipe"
  rm "$last_suite_name_file"
}

on_test_completion () {
  if ((test_has_failure == 0)); then
    show_success
  fi
}

remove_colors() {
  echo $1 | sed 's/\x1b\[[0-9;]*m//g'
}

remove_escapes() {
  echo "$1" | sed -E 's/\x1B\[[0-9;]*[JKmsu]//g'
}

report_errors() {
  local failed_tests
  local suite_error_count

  status=$?
  failed_tests=$(uniq "$error_pipe")
  suite_error_count=$(echo "$failed_tests" | wc -l)

  echo "-----"

  if [[ -z "$failed_tests" ]]; then
    echo "Tests: All tests passed"
    return 0
  else
    echo "Tests: $suite_error_count failed ❌ "
    echo "$failed_tests" | sed 's/^/  /'
    return 1
  fi
}

set_up_test() {
  trap on_test_completion EXIT
  test_has_failure=0
  test_name=$1
}

set_up_tests() {
  trap on_teardown EXIT
}

show_failure() {
  echo " ... FAILED ❌ "
}

show_success() {
  echo " ... passed ✅ "
}
