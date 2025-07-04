#!/bin/bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/../logger/logger.sh"

# _get_caller_func_name: Returns the first function name in the call stack outside test_helper.sh
_get_caller_func_name() {
  local i
  for ((i=1; i<${#FUNCNAME[@]}; i++)); do
    if [[ "${BASH_SOURCE[$i]}" != "${BASH_SOURCE[0]}" ]]; then
      printf '%s' "${FUNCNAME[$i]}"
      return
    fi
  done
  printf 'unknown'
}

# _log_assert <level> <message>
_log_assert() {
  local -r level="${1:?level is required}"
  local -r message="${2:?message is required}"
  local user_func
  user_func="$(_get_caller_func_name)"

  log "${level}" "${user_func}: ${message}"
}

# fail <message>
fail() {
  local -r message="${1:?message is required}"
  _log_assert error "[FAIL] ${message}"
  return 1
}

# assert_equals <expected> <actual>
assert_equals() {
  local -r expected="${1:?expected is required}"
  local -r actual="${2:?actual is required}"

  if [ "${expected}" = "${actual}" ]; then
    _log_assert debug "[PASS] assert_equals: '${expected}' == '${actual}'"
  else
    _log_assert error "[FAIL] assert_equals: expected '${expected}', got '${actual}'"
    return 1
  fi
}

# assert_contains <container> <content>
assert_contains() {
  local -r container="${1:?container is required}"
  local -r content="${2:?content is required}"

  if [[ "${container}" == *"${content}"* ]]; then
    _log_assert debug "[PASS] assert_contains: '${container}' contains '${content}'"
  else
    _log_assert error "[FAIL] assert_contains: '${container}' does not contain '${content}'"
    return 1
  fi
}

# assert_not_contains <container> <content>
assert_not_contains() {
  local -r container="${1:?container is required}"
  local -r content="${2:?content is required}"

  if [[ "${container}" != *"${content}"* ]]; then
    _log_assert debug "[PASS] assert_not_contains: '${container}' does not contain '${content}'"
  else
    _log_assert error "[FAIL] assert_not_contains: '${container}' contains '${content}'"
    return 1
  fi
}

# assert_not_equals <not_expected> <actual>
assert_not_equals() {
  local -r not_expected="${1:?not_expected is required}"
  local -r actual="${2:?actual is required}"

  if [ "${not_expected}" != "${actual}" ]; then
    _log_assert debug "[PASS] assert_not_equals: '${not_expected}' != '${actual}'"
  else
    _log_assert error "[FAIL] assert_not_equals: did not expect '${not_expected}', but got it"
    return 1
  fi
}

# assert_true <condition> <message>
assert_true() {
  local -r condition="${1}"
  local -r message="${2}"

  if eval "${condition}"; then
    _log_assert debug "[PASS] ${message}"
  else
    _log_assert error "[FAIL] ${message}: condition '${condition}' is not true"
    return 1
  fi
}

# assert_false <condition> <message>
assert_false() {
  local -r condition="${1}"
  local -r message="${2}"

  if ! eval "${condition}"; then
    _log_assert debug "[PASS] ${message}"
  else
    _log_assert error "[FAIL] ${message}: condition '${condition}' is not false"
    return 1
  fi
}

# assert_empty <value> <message>
assert_empty() {
  local -r value="${1}"
  local -r message="${2}"

  if [ -z "${value}" ]; then
    _log_assert debug "[PASS] ${message}"
  else
    _log_assert error "[FAIL] ${message}: value is not empty ('${value}')"
    return 1
  fi
}

# assert_not_empty <value> <message>
assert_not_empty() {
  local -r value="${1}"
  local -r message="${2}"

  if [ -n "${value}" ]; then
    _log_assert debug "[PASS] ${message}"
  else
    _log_assert error "[FAIL] ${message}: value is empty"
    return 1
  fi
}

# assert_exists <file_path>
assert_exists() {
  local -r file_path="${1:?file_path is required}"

  if [ -e "${file_path}" ]; then
    _log_assert debug "[PASS] assert_exists: '${file_path}' exists"
  else
    _log_assert error "[FAIL] assert_exists: '${file_path}' does not exist"
    return 1
  fi
}

# assert_not_exists <file_path>
assert_not_exists() {
  local -r file_path="${1:?file_path is required}"

  if [ ! -e "${file_path}" ]; then
    _log_assert debug "[PASS] assert_not_exists: '${file_path}' does not exist"
  else
    _log_assert error "[FAIL] assert_not_exists: '${file_path}' exists"
    return 1
  fi
}

# execute_parameterized_test <func_name> <parameter1> <parameter2> ...
execute_parameterized_test() {
  local -r func_name="${1:?func_name is required}"
  shift
  local parameters=("$@")

  local all_passed=0
  local results=()
  for parameter in "${parameters[@]}"; do
    IFS=',' read -r -a params <<< "${parameter}"
    if "${func_name}" "${params[@]}"; then
      results+=("case: ${params[*]} [PASS]")
    else
      results+=("case: ${params[*]} [FAIL]")
      all_passed=1
    fi
  done

  for result in "${results[@]}"; do
    log_debug "  ${result}"
  done

  return ${all_passed}
}

# run_tests <test1> <test2> ...
run_tests() {
  local -r tests=("$@")

  local all_passed=0
  local test_results=()
  for test in "${tests[@]}"; do
    if "${test}"; then
      test_results+=("${test} [PASS]")
    else
      test_results+=("${test} [FAIL]")
      all_passed=1
    fi
  done

  local -r script_name="$(basename "$0")"
  if [ $all_passed -eq 0 ]; then
    log_info "${script_name} [PASS]"
  else
    log_error "${script_name} [FAIL]"
  fi

  for test_result in "${test_results[@]}"; do
    if [[ "${test_result}" == *"[FAIL]"* ]]; then
      log_error "  ${test_result}"
    else
      log_info "  ${test_result}"
    fi
  done

  return $all_passed
}


# run_debug_tests <test1> <test2> ...
run_debug_tests() (
  set_log_level "DEBUG"
  run_tests "$@"
)