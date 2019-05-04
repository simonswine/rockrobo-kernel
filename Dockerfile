FROM ubuntu:14.04

RUN apt-get update && apt-get install -y build-essential git ncurses-dev make gcc-arm-linux-gnueabihf curl

WORKDIR /usr/src

ENV KERNEL_VERSION 3.4.39

RUN mkdir -p /usr/src/linux-${KERNEL_VERSION} && \
    curl -L https://github.com/allwinner-zh/linux-3.4-sunxi/archive/9935a0f78ac85d6f302fd58c3112ab7985a8abe6.tar.gz -o master.tar.gz && \
    tar xfz master.tar.gz --strip-components 1 -C linux-${KERNEL_VERSION} && \
    rm master.tar.gz

COPY uvc_driver.c /usr/src/linux-${KERNEL_VERSION}/drivers/media/video/uvc/uvc_driver.c
COPY v4l2-dev.h /usr/src/linux-${KERNEL_VERSION}/include/media/v4l2-dev.h
#RUN find /usr/src/linux-${KERNEL_VERSION}/drivers/media/video -name '*.c' -exec sed -i -e 's/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/g' {} \;

WORKDIR /usr/src/linux-${KERNEL_VERSION}

ADD dot-config .config

ENV ARCH arm
ENV CROSS_COMPILE arm-linux-gnueabihf-

RUN make oldconfig && make prepare
RUN make -j 4 modules

# add symbol versions to make module load without error
ADD Module.symvers .

#RUN make SUBDIRS=drivers/usb/storage modules
#RUN make SUBDIRS=drivers/usb/serial modules

RUN make SUBDIRS=drivers/media
# make SUBDIRS=drivers/media/video/uvc modules KBUILD_EXTMOD=drivers/media