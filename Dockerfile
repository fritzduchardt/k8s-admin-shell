FROM ubuntu:latest

MAINTAINER Fritz Duchardt (fritz@duchardt.net)

RUN apt update && \
    apt install curl -y && \
    apt install net-tools -y && \
    apt install iputils-ping -y && \
    apt install traceroute -y && \
    apt install dnsutils -y && \
    apt install sudo -y

# keep it running
ENTRYPOINT bash
CMD "tail -f /dev/null"

