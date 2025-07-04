#!/bin/bash
set -eu -o pipefail

source "$(dirname "${BASH_SOURCE[0]}")/../logger/logger.sh"

find_test_scripts() {
  local -r search_dir="${1}"

  find "${search_dir}" -type f -name 'test_*.sh'
}

run_test_scripts() {
  local -r search_dir="${1}"
  local -i all_passed=0

  while IFS= read -r test_script; do
    if ! bash "${test_script}"; then
      log_debug "${test_script}: [FAIL]"
      all_passed=1
    fi
  done < <(find_test_scripts "${search_dir}")

  return $all_passed
}

main() {
  local search_dir="${1:-$(pwd)}"

  if ! run_test_scripts "${search_dir}"; then
    local -r abs_search_dir="$(cd "${search_dir}" && pwd)"
    log_error "Tests in ${abs_search_dir}: [FAIL]"
    exit 1
  fi
}

main "$@"
