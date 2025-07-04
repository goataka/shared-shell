#!/bin/bash
set -eu -o pipefail

source "$(dirname "${BASH_SOURCE[0]}")/../import.sh"
import "tests/test_helper.sh"
import "logger/logger.sh"

set_log_level_test() (
  set_log_level "DEBUG"
  
  assert_equals "DEBUG" "${LOG_LEVEL}" "set_log_level sets LOG_LEVEL"
)

get_log_level_priority_test() (
  local -a cases=(
    "0,DEBUG"
    "1,INFO"
    "2,WARN"
    "3,ERROR"
    "99,UNKNOWN"
  )
  execute_parameterized_test "get_log_level_priority_parameterized_test" "${cases[@]}"
)

get_log_level_priority_parameterized_test() (
  local -r expected="${1}"
  local -r level="${2}"
  assert_equals "${expected}" "$(get_log_level_priority "${level}")"
)

log_debug_test() (
  log_debug "debug message"
)

log_info_test() (
  log_info "info message"
)

log_warn_test() (
  log_warn "warn message"
)

log_error_test() (
  log_error "error message"
)

main() {
  set_log_level_test
  get_log_level_priority_test
  log_debug_test
  log_info_test
  log_warn_test
  log_error_test
}

main "$@"
