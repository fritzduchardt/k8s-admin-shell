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

k8s::current_namespace() {
  lib::exec kubectl config view --minify --output 'jsonpath={..namespace}'
}

k8s::registry_url() {
  local secret_name="$1"
  lib::exec kubectl get secret "$secret_name" -o go-template='{{ index .data ".dockerconfigjson" | base64decode }}' | jq -re '.auths | keys[0]'
}
