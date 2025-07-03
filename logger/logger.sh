#!/bin/bash

set -euo pipefail

# set_log_level <LEVEL>
set_log_level() {
    local -r level="${1}"
    export LOG_LEVEL="${level}"
}

# get_log_level_priority <LEVEL>
get_log_level_priority() {
    local -r level="${1}"

    declare -A level_map=(
        [DEBUG]=0
        [INFO]=1
        [WARN]=2
        [ERROR]=3
    )

    if [[ -n "${level_map[${level}]+_}" ]]; then
        echo "${level_map[${level}]}"
    else
        echo 99
    fi
}

# _log <LEVEL> <message>
_log() {
    local -r level="${1}"
    local -r message="${2}"

    local -r level_priority="$(get_log_level_priority "${level}")"
    local -r current_priority="$(get_log_level_priority "${LOG_LEVEL:-INFO}")"

    if [ "${level_priority}" -lt "${current_priority}" ]; then
        return
    fi
    
    local -r timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

    if [ "${level}" = "ERROR" ]; then
        echo "${timestamp} [${level}] ${message}" >&2
    else
        echo "${timestamp} [${level}] ${message}" >&1
    fi
}

# log_debug <message>
log_debug() {
    local -r message="${1}"
    _log "DEBUG" "${message}"
}

# log_info <message>
log_info() {
    local -r message="${1}"
    _log "INFO" "${message}"
}

# log_warn <message>
log_warn() {
    local -r message="${1}"
    _log "WARN" "${message}"
}

# log_error <message>
log_error() {
    local -r message="${1}"
    _log "ERROR" "${message}"
}
