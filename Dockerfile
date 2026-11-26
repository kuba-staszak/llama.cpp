FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    clang \
    clang-format \
    clang-tidy \
    lldb \
    gdb \
    cmake \
    ninja-build \
    ccache \
    git \
    git-lfs \
    curl \
    wget \
    ca-certificates \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    pkg-config \
    libssl-dev \
    libcurl4-openssl-dev \
    libopenblas-dev \
    libomp-dev \
    valgrind \
    strace \
    sudo \
    lsof \
    procps \
    file \
    jq \
    ripgrep \
    xxd \
    less \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Prefer clang for llama.cpp development.
ENV CC=clang
ENV CXX=clang++

# Useful for repeated builds.
ENV CCACHE_DIR=/home/dev/.cache/ccache
ENV CMAKE_GENERATOR=Ninja

# Start as dev and allow password-authenticated sudo.
RUN useradd \
      --create-home \
      --shell /bin/bash \
      --groups sudo \
      dev \
    && mkdir -p /work /home/dev/.cache/ccache \
    && chown -R dev:dev /work /home/dev

USER dev
WORKDIR /work

CMD ["/bin/bash"]
