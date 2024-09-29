FROM --platform=$BUILDPLATFORM ubuntu:latest

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

ENV AMICONTAINED_VERSION=v0.4.9
RUN curl -L -o /usr/bin/amicontained https://github.com/genuinetools/amicontained/releases/download/${AMICONTAINED_VERSION}/amicontained-linux-amd64 && \
  chmod +x /usr/bin/amicontained

ENTRYPOINT [ "bash" ]
