#!/usr/bin/env bash

# https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container/

set -e
set -o pipefail

if ! which qemu-arm-static > /dev/null; then
    sudo apt install qemu-user-static
fi

cp $(which qemu-arm-static) .
wget -c http://downloads.raspberrypi.org/raspbian_lite/archive/2019-06-24-07:07/boot.tar.xz
wget -c http://downloads.raspberrypi.org/raspbian_lite/archive/2019-06-24-07:07/root.tar.xz

if [ ! -d /sys/fs/cgroup/systemd ]; then
	sudo mkdir -p /sys/fs/cgroup/systemd
	sudo mount -t cgroup cgroup -o none,name=systemd /sys/fs/cgroup/systemd
fi

docker build -t raspbian-init-ssh .
docker run -d --restart unless-stopped \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    --tmpfs /run \
    --tmpfs /run/lock \
    --tmpfs /tmp \
    --cap-add SYS_ADMIN \
    "$@" \
    raspbian-init-ssh

