#!/usr/bin/env bash

KUBECTL_BIN="${KUBECTL_BIN:-kubectl}"

# Execute any binary
lib::exec() {
  local command="$1"
  shift
  if [[ -z "$DRY_RUN" ]] || [[ "$DRY_RUN" != "true" ]]; then
    log::trace "$command ${*}"
    if ! "$command" "${@}"; then
      log::error "Failed to execute $command ${*}"
      return 1
    fi
  else
    log::info "DRY-RUN: $command ${*}"
  fi
}

k8s::select_namespace() {
  current_namespace="$(k8s::current_namespace)"
  log::debug "Current namespace: $current_namespace"
  lib::exec "$KUBECTL_BIN" get ns -oname | sed "s#namespace/##" | fzf --header "Select namespace" --query "$current_namespace"
}

k8s::current_namespace() {
  lib::exec "$KUBECTL_BIN" config view --minify --output 'jsonpath={..namespace}'
}

k8s::resource_exists() {
  local resource="$1"
  local name="$2"
  local namespace="$3"
  lib::exec "$KUBECTL_BIN" get "$resource" "$name" -n "$namespace" 2>/dev/null
  return "$?"
}

k8s::registry_url_from_secret() {
  local secret_name="$1"
  local ns="$2"
  lib::exec "$KUBECTL_BIN" get secret "$secret_name" -n "$ns" -o go-template='{{ index .data ".dockerconfigjson" | base64decode }}' | jq -re '.auths | keys[0]'
}
