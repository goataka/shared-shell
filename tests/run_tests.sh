#!/bin/bash
set -eu -o pipefail

source "$(dirname "${BASH_SOURCE[0]}")/../logger/logger.sh"

find_test_scripts() {
  local -r search_dir="${1}"

  find "${search_dir}" -type f -name 'test_*.sh'
}

run_test_scripts() {
  local -r test_scripts="${1}"
  local -i all_passed=0

  log_info "Test scripts started."

  while IFS= read -r test_script; do
    if [ -z "$test_script" ]; then
      continue
    fi
    if ! bash "$test_script"; then
      log_debug "$test_script: [FAIL]"
      all_passed=1
    fi
  done <<< "${test_scripts}"

  if ! (( all_passed == 0 )); then
    log_error "Tests scripts: [FAIL]"
  fi

  log_info "Test scripts completed."
  return $all_passed
}

main() {
  local search_dir="${1:-$(pwd)}"

  local -r abs_search_dir="$(cd "${search_dir}" && pwd)"
  log_info "Search directory: ${abs_search_dir}"

  local -r test_scripts=$(find_test_scripts "${search_dir}")
  run_test_scripts "${test_scripts}"
}

main "$@"
