docker rm -f rockrobo-kernel || true
docker build -t rockrobo-kernel .
docker create --name rockrobo-kernel rockrobo-kernel:latest
docker cp rockrobo-kernel:/usr/src/linux-3.4.39/drivers/media/video/uvc/uvcvideo.ko .
UVC=uvcvideo.ko

echo "put $UVC" | sftp root@192.168.0.195:/lib/modules/3.4.39/


