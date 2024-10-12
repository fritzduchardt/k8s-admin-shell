FROM  ubuntu:latest AS base

LABEL org.opencontainers.image.authors="fritz@duchardt.net"

RUN apt-get update && apt-get -y --no-install-recommends install \
    ca-certificates \
    curl \
    netcat-openbsd \
    iproute2 \
    iputils-ping \
    telnet \
    vim \
    nmap \
    traceroute \
    dnsutils \
    sudo \
    wget \
    openssl -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "bash" ]
