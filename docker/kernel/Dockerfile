FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    bc \
    bison \
    build-essential \
    ca-certificates \
    ccache \
    cpio \
    dosfstools \
    file \
    flex \
    gcc-powerpc-linux-gnu \
    git \
    kmod \
    libelf-dev \
    libssl-dev \
    make \
    mtools \
    rsync \
    u-boot-tools \
    wget \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
