#!/bin/bash
set -eo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

source "$SCRIPT_DIR/lib/log.sh"
source "$SCRIPT_DIR/lib/utils.sh"

function usage() {
  cat >&2 <<EOF
Runs an interactive shell in a k8s pod with the given image and command.

Examples:
  # Start as Host shell:
  ./k8s_admin_shell.sh -p true

  # Start in a specific namespace:
  ./k8s_admin_shell.sh -n kube-system

  # Start with a specific image:
   ./k8s_admin_shell.sh -i busybox

  # Start with a specific command:
  ./k8s_admin_shell.sh -c /bin/sh

  # Start with a specific image pull secret:
  ./k8s_admin_shell.sh -s my-secret

  # Start on a specific node:
  ./k8s_admin_shell.sh -N my-node

Options:
      --help, -h
            Print usage
      --debug, -D
            Enable debug logging
      --trace, -T
            Enable trace logging
      --dry-run
            Print the command that would be run, but do not run it
      --privileged, -p
            Run the shell in privileged mode
      --namespace, -n
            Namespace to run the shell in
      --image, -i
            Image to run the shell with
      --command, -c
            Command to run in the shell
      --pullsecret, -s
            Image pull secret to use
      --node, -N
            Node to run the shell on

Usage:
      ./k8s_admin_shell.sh [OPTIONS]
EOF
  exit 2
}

main() {
  local privileged=$1
  local namespace="$2"
  local image="$3"
  local command="$4"
  local imagePullSecret="$5"
  local nodeName=$6
  local imagePullPolicy=$7
  local image_query

  # Collecting config
  if [ -z "$privileged" ]; then
    local -r mode="$(fzf::select_from_config "$SCRIPT_DIR/../config/modes.txt" "Select mode" "privileged")"
    log::debug "mode: $mode"
    if [[ "$mode" == "privileged" ]]; then
      privileged="true"
    else
      privileged="false"
    fi
  fi

  if [ -z "$namespace" ]; then
    namespace="$(k8s::select_namespace)"
    log::debug "Selected namespace: $namespace"
  fi

  if [ -z "$image" ]; then
    if [ -n "$imagePullSecret" ]; then
      image_query="$(lib::exec k8s::registry_url_from_secret "$imagePullSecret" "$namespace")"
    fi
    image="$(fzf::select_from_config "$SCRIPT_DIR/../config/utility-images.txt" "Select image" "$image_query")"
    log::debug "Selected image: $image"
  fi

  if [ -z "$command" ]; then
    command="$(fzf::select_from_config "$SCRIPT_DIR/../config/entrypoint-commands.txt" "Select command")"
    log::debug "Selected command: $command"
  fi

  # Installing helm chart
  local -r k8s_values="$(mktemp)"
  log::debug "Creating values file: $k8s_values"
  cat > "$k8s_values" <<EOF
image:
  name: $image
  pullSecret: $imagePullSecret
  pullPolicy: $imagePullPolicy
privileged: $privileged
nodeName: $nodeName
hostPID: $privileged
EOF

  log::info "Starting k8s-admin-shell in namespace: $namespace"
  # shellcheck disable=SC2064
  trap "lib::exec helm delete k8s-admin-shell -n $namespace; lib::exec kubectl delete pod k8s-admin-shell --force -n $namespace 2>/dev/null" EXIT
  lib::exec helm upgrade k8s-admin-shell "$SCRIPT_DIR/../charts/k8s-admin-shell" \
    --install \
    --wait \
    --namespace "$namespace" \
    --values "$k8s_values"

  # Exec into pod
  # shellcheck disable=SC2086
  lib::exec kubectl exec -it k8s-admin-shell -n "$namespace" -- $command
  # Remove values file on success. On error, leave in place for debugging
  lib::exec rm -f "$k8s_values"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  privileged=""
  namespace=""
  image=""
  command=""
  imagePullSecret=""
  imagePullPolicy=""
  nodeName=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
    --help | -h)
      usage
      ;;
    --debug | -D)
      # shellcheck disable=SC2034
      LOG_LEVEL="debug"
      shift 1
      ;;
    --trace | -T)
      # shellcheck disable=SC2034
      LOG_LEVEL="trace"
      shift 1
      ;;
    --dry-run)
      # shellcheck disable=SC2034
      DRY_RUN="true"
      shift 1
      ;;
    --namespace | -n)
      namespace="$2"
      shift 2
      ;;
    --privileged | -p)
      privileged="$2"
      shift 2
      ;;
    --image | -i)
      image="$2"
      shift 2
      ;;
    --command | -c)
      command="$2"
      shift 2
      ;;
    --pullsecret | -s)
      imagePullSecret="$2"
      shift 2
      ;;
    --pullpolicy)
      imagePullPolicy="$2"
      shift 2
      ;;
    --node | -N)
      nodeName="$2"
      shift 2
      ;;
    *)
      log::error "Unknown argument: $1"
      shift 1
      ;;
    esac
  done

  log::debug "Running with privileged: $privileged"
  log::debug "Running in namespace: $namespace"
  log::debug "Running with image: $image"
  log::debug "Running with command: $command"
  log::debug "Running with image pull secret: $imagePullSecret"
  log::debug "Running with image pull policy: $imagePullPolicy"
  log::debug "Running on node: $nodeName"

  main "$privileged" "$namespace" "$image" "$command" "$imagePullSecret" "$nodeName" "$imagePullPolicy"
fi
