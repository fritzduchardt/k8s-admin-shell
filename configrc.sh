#!/usr/bin/env bash

script_dir="$(dirname -- "${BASH_SOURCE[0]:-${0}}")/scripts"

lib::exec_k8s_tool() {
  local dir="$1" script="$2"
  shift 2
  (cd "$dir" && ./"$script" "$@")
}

alias {k8s_admin_shell,kas,debug}="lib::exec_k8s_tool $script_dir k8s_admin_shell.sh"
alias {k8s_admin_shell_default,kasd}="lib::exec_k8s_tool $script_dir k8s_admin_shell.sh -n default -p false -i fritzduchardt/k8s-admin-shell:latest -c bash"
alias {k8s_admin_shell_default_privileged,kasdp}="lib::exec_k8s_tool $script_dir && k8s_admin_shell.sh -n default -p true -i fritzduchardt/k8s-admin-shell:latest"
