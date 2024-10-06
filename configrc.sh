#!/usr/bin/env bash

script_dir="$(dirname "$0")/scripts"

alias {k8s_admin_shell,kas}="(cd $script_dir && ./k8s_admin_shell.sh)"
alias {k8s_admin_shell_default,kasd}="(cd $script_dir && ./k8s_admin_shell.sh -n default -p false -i fritzduchardt/k8s-admin-shell:latest -c bash"
alias {k8s_admin_shell_default_privileged,kasdp}="cd $script_dir && ./k8s_admin_shell.sh -n default -p true -i fritzduchardt/k8s-admin-shell:latest"
