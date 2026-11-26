FROM ubuntu:26.04

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
    python3-pip \
    python3-venv \
    pkg-config \
    libssl-dev \
    libcurl4-openssl-dev \
    libopenblas-dev \
    libomp-dev \
    valgrind \
    strace \
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

# Don't work as root.
RUN useradd \
      --create-home \
      --shell /bin/bash \
      dev \
    && mkdir -p /work /home/dev/.cache/ccache \
    && chown -R dev:dev /work /home/dev

USER dev
WORKDIR /work

CMD ["/bin/bash"]
