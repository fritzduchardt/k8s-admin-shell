FROM ubuntu:24.04@sha256:b59d21599a2b151e23eea5f6602f4af4d7d31c4e236d22bf0b62b86d2e386b8f AS base

LABEL org.opencontainers.image.authors="fritz@duchardt.net"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    dnsutils \
    iproute2 \
    iputils-ping \
    netcat-openbsd \
    nmap \
    openssl \
    sudo \
    telnet \
    traceroute \
    vim \
    wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT [ "bash" ]
