#!/bin/bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/logger/logger.sh"

# import <relative_script_path>
import() {
  local -r relative_script_path="${1:?relative_script_path is required}"

  local -r script_root_dir="$(dirname "${BASH_SOURCE[0]}")"
  local -r script_path="${script_root_dir}/${relative_script_path}"

  if [ ! -f "${script_path}" ]; then
    log_error "[IMPORT ERROR] ${script_path} does not exist"
    return 1
  fi

  source "${script_path}"
}
