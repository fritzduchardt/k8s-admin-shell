#!/usr/bin/env bash

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
  current_namespace="$(lib::exec k8s::current_namespace)"
  namespace="$(lib::exec kubectl get ns -oname | sed "s#namespace/##" | fzf --header "Select namespace" --query "$current_namespace")"
  log::debug "Selected namespace: $namespace"
}

k8s::current_namespace() {
  lib::exec kubectl config view --minify --output 'jsonpath={..namespace}'
}

k8s::resource_exists() {
  local resource="$1"
  local name="$2"
  local namespace="$3"
  lib::exec kubectl get "$resource" "$name" -n "$namespace" 2>/dev/null
  return "$?"
}

k8s::registry_url_from_secret() {
  local secret_name="$1"
  lib::exec kubectl get secret "$secret_name" -o go-template='{{ index .data ".dockerconfigjson" | base64decode }}' | jq -re '.auths | keys[0]'
}
