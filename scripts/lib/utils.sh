#!/usr/bin/env bash

# Execute any binary
lib::exec() {
    local command="$1"
    shift
    if [[ -z "$DRY_RUN" ]] || [[ "$DRY_RUN" != "true" ]]; then
        log::trace "$command ${*}"
        "$command" "${@}"
    else
        log::info "DRY-RUN: $command ${*}"
    fi
}
