# k8s-admin-shell
K8s configuration & Docker image with admin tools to analyse K8s nodes

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


## Start shell with K8s

### Prerequisites

- [kubectl](https://kubernetes.io/docs/tasks/tools/)

### Installation

Check out to destination of your choice, e.g.
```
# e.g. install to your home bin folder
cd ~/bin
git clone git@github.com:fritzduchardt/k8s-admin-shell.git
chmod +x k8s_admin_shell.sh

# e.g. amend PATH for zsh
echo 'export PATH=$PATH:$HOME/bin/k8s-admin-shell' >> ~/.zshrc
source ~/.zshrc
```

### Start shell

The shell script will take care of creating the Pod, opening the shell and removing the Pod after the shell was exited.

The K8s yamls are stored in the `k8s` folder.

To start the shell in an **ordinary Pod**, e.g. for analysis of the Pod network:

```
./k8s_admin_shell.sh
```

To start the shell in a **privileged Pod** within the Linux namespaces of the worker nodes:

**Caution:** This shell will mount the file system of the K8s worker node it is deployed on. Also, it has **full admin access rights and Kernel capabilities**. It can modify everything!
```
./k8s_admin_shell.sh true
```

## Start shell with Docker

### Interactive tty shell
```
docker run --rm --name k8s-admin-shell -it fritzduchardt/k8s-admin-shell:0.1.0
```

### Running container
```
# start it
docker run -d --name k8s-admin-shell --entrypoint tail fritzduchardt/k8s-admin-shell:0.1.0 -f /dev/null

# remove it
docker rm -f k8s-admin-shell
```


