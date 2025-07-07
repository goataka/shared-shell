#!/bin/bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/logger/logger.sh"

# _get_script_path <relative_script_path>
_get_script_path() {
  local -r relative_script_path="${1}"

  local -r root_dir="$(dirname "${BASH_SOURCE[0]}")"
  local -r script_path="${root_dir}/${relative_script_path}"

  if [ ! -f "${script_path}" ]; then
    log_error "[IMPORT ERROR] ${script_path} does not exist"
    exit 1
  fi
  echo "${script_path}"
}

# import <relative_script_path>
import() {
  local -r relative_script_path="${1:?relative_script_path is required}"

  local -r script_path="$(_get_script_path "${relative_script_path}")"

  source "${script_path}"
}

# run <relative_script_path> [args...]
run() {
  local -r relative_script_path="${1:?relative_script_path is required}"
  shift

  local -r script_path="$(_get_script_path "${relative_script_path}")"

  bash "${script_path}" "$@"
}