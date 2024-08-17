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
  local actual=$1
  local expected=$2

  if [[ ! "$expected" == "$actual" ]]; then
    count_failure
    echo "  Expected: $expected"
    echo "  Actual:   $actual"
    return 1
  fi
}

# Check whether the file contains the expected content
assert_file_contains() {
  local file_path=$1
  local expected_content=$2

  actual_content=$(cat "$file_path")
  if ! grep -q -F "$expected_content" <<< "$actual_content"; then
    count_failure
    echo "  Expected file to contain: $expected_content"
    echo "  Actual file content: $actual_content"
    return 1
  fi
  return 0
}

assert_match() {
  local actual=$1
  local pattern=$2
  local no_color_actual

  no_color_actual=$(remove_colors "$actual")

  if [[ ! "$no_color_actual" =~ $pattern ]]; then
    count_failure
    echo "  Pattern: $pattern"
    echo "  Actual:   $no_color_actual"
    return 1
  fi
}

# True if the pattern is found in the output exactly once.
assert_matches_line() {
  local lines="$1"
  local pattern="$2"
  local matching_lines_count

  matching_lines_count=$(echo "$lines" | grep -Ec "$pattern")

  if [[ ! $matching_lines_count -eq 1 ]]; then
    count_failure
    echo "  Pattern: $pattern"
    echo "  Matching lines:   $matching_lines_count"
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

generate_timestamp() {
  date +"%Y-%m-%d-%H%M%S"
}

it() {
  set_up_test "$1"
  describe_suite_on_first_test
  describe_test
}

on_teardown () {
  report_errors
  local status=$?
  rm "$error_pipe"
  rm "$last_suite_name_file"
  exit $status
}

on_test_completion () {
  if ((test_has_failure == 0)); then
    show_success
  fi
}

remove_colors() {
  echo -e "$1" | sed $'s/\x1b\[[0-9;]*m//g'
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
