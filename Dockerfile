FROM ubuntu:24.04@sha256:440dcf6a5640b2ae5c77724e68787a906afb8ddee98bf86db94eea8528c2c076 AS base

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
