FROM ubuntu:14.04

RUN apt-get update && apt-get install -y build-essential git ncurses-dev make gcc-arm-linux-gnueabihf curl

WORKDIR /usr/src

ENV KERNEL_VERSION 3.4.39

RUN curl -sLO https://cdn.kernel.org/pub/linux/kernel/v3.x/linux-${KERNEL_VERSION}.tar.gz && \
    tar xvfz linux-${KERNEL_VERSION}.tar.gz && \
    rm linux-${KERNEL_VERSION}.tar.gz

WORKDIR /usr/src/linux-${KERNEL_VERSION}

# https://developer.arm.com/products/software/mali-drivers/android-gralloc-module#


# patch in overlayfs
RUN curl -sL https://raw.githubusercontent.com/adilinden/overlayfs-patches/master/overlayfs.v13-3.4-rc7.patch | patch -p1

ADD dot-config .config

ENV ARCH arm
ENV CROSS_COMPILE arm-linux-gnueabihf-

RUN make oldconfig
RUN make -j 4 zImage dtbs modules
