FROM debian:bullseye

# Install dependencies
RUN apt-get -qq update && \
    apt-get install -qqy --no-install-recommends \
        ca-certificates \
        autoconf automake cmake dpkg-dev file git make patch ninja-build \
        libc-dev libc++-dev libgcc-10-dev libstdc++-10-dev  \
	qemu qemu-system \
	xorriso mtools grub-common \
        dirmngr gnupg2 lbzip2 wget xz-utils libtinfo5 libtinfo-dev zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# Version info
ENV LLVM_RELEASE 13
ENV LLVM_VERSION 13.0.0

# Copy the repo
RUN mkdir zig
COPY . zig/

# Install Clang and LLVM
RUN ./zig/install.sh

# Install zig
RUN mkdir zig/build && cd zig/build && cmake .. -GNinja -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_LINKER=lld && ninja install -v && ln -s /zig/build/bin/zig /usr/bin/zig
