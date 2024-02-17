#!/usr/bin/env bash

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
