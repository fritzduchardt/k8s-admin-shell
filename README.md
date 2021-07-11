# k8s-admin-shell
Docker image with admin tools to analyse K8s nodes

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


## Start interactive tty shell with Docker

```
docker run --rm --name k8s-admin-shell -it fritzduchardt/k8s-admin-shell:0.1.0
```

## Start running container with Docker
```
# start it
docker run -d --name k8s-admin-shell --entrypoint tail fritzduchardt/k8s-admin-shell:0.1.0 -f /dev/null

# remove it
docker rm -f k8s-admin-shell
```

## Start interactive tty shell with K8s

### Prerequisites

- kubectl

### Installation

Check out to destination of your choice, e.g.
```
cd ~/bin

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


