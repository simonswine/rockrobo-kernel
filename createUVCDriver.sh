docker rm -f rockrobo-kernel || true
docker build -t rockrobo-kernel .
docker create --name rockrobo-kernel rockrobo-kernel:latest
docker cp rockrobo-kernel:/usr/src/linux-3.4.39/drivers/media/video/uvc/uvcvideo.ko .
docker cp rockrobo-kernel:/usr/src/linux-3.4.39/drivers/media/video/videobuf2-core.ko .
docker cp rockrobo-kernel:/usr/src/linux-3.4.39/drivers/media/video/videobuf2-memops.ko .
docker cp rockrobo-kernel:/usr/src/linux-3.4.39/drivers/media/video/videobuf2-vmalloc.ko .

#docker cp rockrobo-kernel:/usr/src/linux-3.4.39/drivers/media/ .


echo "put uvcvideo.ko" | sftp root@192.168.0.195:/lib/modules/3.4.39/
echo "put videobuf2-core.ko" | sftp root@192.168.0.195:/lib/modules/3.4.39/
echo "put videobuf2-memops.ko" | sftp root@192.168.0.195:/lib/modules/3.4.39/
echo "put videobuf2-vmalloc.ko" | sftp root@192.168.0.195:/lib/modules/3.4.39/
echo "put load.sh" | sftp root@192.168.0.195:/root/


