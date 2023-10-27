#!/bin/bash

qemu-system-aarch64 \
	-M virt,accel=hvf,highmem=off \
	-cpu cortex-a72 \
	-kernel Image \
	-drive "file=arch-linux-arm.img,format=raw,index=0,media=disk" \
	-append "root=/dev/vda2" \
	-initrd initramfs-linux.img \
	-nographic \
	-serial mon:stdio \
