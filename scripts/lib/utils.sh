#!/usr/bin/env bash
# shellcheck disable=SC2181

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

function fzf::select_from_config() {
  local config_file="${1}"
  local header="${2}"
  local query="${3}"
  local entry
  entry="$(lib::exec fzf --print-query --header "$header" --query "$query" <"$config_file" | lib::exec tail -n1)"
  if [[ $? -ne 0 ]]; then
    log::debug "No entry found in: $config_file. Going with user input: $entry"
  fi
  lib::exec echo "$entry" | tr -d '\n'
}

k8s::select_namespace() {
  local -r current_namespace="$(k8s::current_namespace)"
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
