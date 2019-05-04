insmod /lib/modules/3.4.39/videobuf2-core.ko
insmod /lib/modules/3.4.39/videobuf2-memops.ko
insmod /lib/modules/3.4.39/videobuf2-vmalloc.ko
rmmod /lib/modules/3.4.39/uvcvideo.ko
insmod /lib/modules/3.4.39/uvcvideo.ko

dmesg