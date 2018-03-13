FROM ubuntu:14.04

RUN apt-get update && apt-get install -y build-essential git ncurses-dev make gcc-arm-linux-gnueabihf curl

WORKDIR /usr/src

ENV KERNEL_VERSION 3.4.39

RUN mkdir -p /usr/src/linux-${KERNEL_VERSION} && \
    curl -L https://github.com/allwinner-zh/linux-3.4-sunxi/archive/9935a0f78ac85d6f302fd58c3112ab7985a8abe6.tar.gz -o master.tar.gz && \
    tar xfz master.tar.gz --strip-components 1 -C linux-${KERNEL_VERSION} && \
    rm master.tar.gz

WORKDIR /usr/src/linux-${KERNEL_VERSION}

ADD dot-config .config

ENV ARCH arm
ENV CROSS_COMPILE arm-linux-gnueabihf-

RUN make oldconfig && make prepare
RUN make -j 4 modules

# add symbol versions to make module load without error
ADD Module.symvers .

# realtek driver wifi usb
RUN mkdir -p /usr/src/rtl8812au && \
    curl -LO https://github.com/diederikdehaas/rtl8812AU/archive/driver-4.3.20.tar.gz && \
    tar xfz driver-4.3.20.tar.gz --strip-components 1 -C /usr/src/rtl8812au && \
    rm driver-4.3.20.tar.gz

RUN cd /usr/src/rtl8812au && make KSRC=/usr/src/linux-${KERNEL_VERSION}
