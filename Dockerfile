# syntax=docker/dockerfile:1
# MAINTAINER "Srikanth Gopalakrishnan <srikanth@psync.dev>"

FROM alpine:latest

# Install the dependencies
RUN apk add --no-cache \
    ca-certificates \
    unzip \
    wget \
    zip \
    zlib-dev \
    bash

RUN mkdir -p /pb/pb_data

# Download the latest PocketBase and install it for AMD64
RUN latest_version=$(wget -qO- https://api.github.com/repos/pocketbase/pocketbase/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\\1/') && \
    wget https://github.com/pocketbase/pocketbase/releases/download/${latest_version}/pocketbase_${latest_version}_linux_amd64.zip -O /tmp/pocketbase.zip && \
    unzip /tmp/pocketbase.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/pocketbase

# Download the static build of Litestream directly into the path & make it executable.
ADD https://github.com/benbjohnson/litestream/releases/download/v0.3.13/litestream-v0.3.13-linux-amd64.tar.gz /tmp/litestream.tar.gz
RUN tar -C /usr/local/bin -xzf /tmp/litestream.tar.gz

# Notify Docker that the container wants to expose a port.
EXPOSE 8090
EXPOSE 9090

# Copy Litestream configuration file & startup script.
COPY etc/litestream.yml /etc/litestream.yml
COPY scripts/run.sh /scripts/run.sh

RUN chmod +x /scripts/run.sh
RUN chmod +x /usr/local/bin/litestream

# Start PocketBase
CMD [ "/scripts/run.sh" ]
