# k8s-admin-shell

K8s configuration & Docker image with admin tools to analyse K8s nodes.

Includes the following tools:

- curl
- ip
- ifconfig
- ping
- route
- traceroute
- dig
- nslookup
- host
- arp
- ipmaddr
- iptunnel
- nameif
- mii-tool
- vim
- wget
- openssl
- amicontained


## Start shell with K8s

### Prerequisites

- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [helm](https://helm.sh/docs/intro/install/)
- [fzf](https://github.com/junegunn/fzf)

### Installation

```bash
# check out to destination of your choice, e.g.
git clone git@github.com:fritzduchardt/k8s-admin-shell.git ~/projects/github/k8s-admin-shell

# add source config_rc.sh to your shell rc, e.g.:
source ~/projects/github/k8s-admin-shell/config_rc.sh
```

### Usage

```bash
./scripts/k8s_admin_shell.sh --help
```
