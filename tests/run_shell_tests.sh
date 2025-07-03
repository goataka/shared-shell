#!/bin/bash
set -eu -o pipefail

find_test_scripts() {
  local -r test_dir="${1}"
  
  find "${test_dir}" -type f -name 'test_*.sh'
}

run_test_script() {
  local -r test_script="${1}"

  local -r log_file="/tmp/test_log_$$.log"
  rm -f "${log_file}"

  echo "Running ${test_script}..."

  if ! bash "${test_script}" 2>&1 | tee "${log_file}"; then
    echo "[ERROR] ${test_script} failed."
    return 1
  fi

  if grep -q '\[FAIL\]' "${log_file}"; then
    echo "[ERROR] ${test_script} reported test failure."
    return 1
  fi

  rm -f "${log_file}"
  echo "" 
  return 0
}

main() {
  local -r script_dir="$(dirname "${BASH_SOURCE[0]}")"
  local -r test_dir="${script_dir}"
  local -i error_count=0

  while IFS= read -r test_script; do
    if ! run_test_script "${test_script}"; then
      error_count=$((error_count+1))
    fi
  done < <(find_test_scripts "${test_dir}")

  if [ $error_count -ne 0 ]; then
    echo "Some tests failed ($error_count)." >&2
    exit 1
  fi
}

main "$@"
