FROM ubuntu:latest

MAINTAINER Fritz Duchardt (fritz@duchardt.net)

RUN apt update && apt install \
    curl \
    netcat-openbsd \
    iproute2 \
    iputils-ping \
    telnet \
    vim \
    traceroute \
    dnsutils \
    sudo \
    wget \
    openssl -y

ENTRYPOINT [ "bash" ]
