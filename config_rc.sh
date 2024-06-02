current_dir=$(dirname "$0")
alias {k8s_admin_shell,kas}="$current_dir/scripts/k8s_admin_shell.sh"
alias {k8s_admin_shell_default,kasd}="$current_dir/scripts/k8s_admin_shell.sh -n default -p false -i fritzduchardt/k8s-admin-shell:latest -c bash"
alias {k8s_admin_shell_default_privileged,kasdp}="$current_dir/scripts/k8s_admin_shell.sh -n default -p true -i fritzduchardt/k8s-admin-shell:latest"
