# ARM Arch Linux for QEMU

Instructions for building and running an sdcard image on Mac running colima.

## 1. Create the qemu img

```sh
qemu-img create arch-linux-arm.img 32g
```

## 2. Colima SSH

```sh
colima ssh
```

### 2.1. Format the img file

Following [these instructions]()
```sh
(echo n; echo p; echo 1; echo; echo +200M; echo t; echo c; echo n; echo p; echo 2; echo; echo; echo w;) | fdisk arch-linux-arm.img
```

If you see this message: `rereading partition table failed, kernel still uses old table: Not a tty`, restart colima.

```sh
colima restart
```

### 2.2 Mount using losetup

```sh
sudo losetup -P /dev/loop1 arch-linux-arm.img 
```

### 2.3 mkfs

```sh
sudo apt install dosfstools
sudo mkfs.vfat /dev/loop1p1
sudo mkfs.ext4 /dev/loop1p2
```

### 2.4 Mounting

```sh
mkdir /mnt/root
sudo mount /dev/loop1p2 /mnt/root/
mkdir /mnt/root/boot
sudo mount /dev/loop1p1 /mnt/root/boot
```

### 2.5 Getting ArchLinuxARM and copying to loop device

```sh
mkdir /tmp/workdir && cd /tmp/workdir
wget http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz
sudo su -
# Beware the tar bomb
tar xzvf ArchLinuxARM-aarch64-latest.tar.gz
mv * /mnt/root/
mv boot/* /mnt/root/boot
```

### 2.6 Fix fstab

```sh
echo /dev/disk/by-uuid/`sudo blkid | grep loop1p2 | awk '{print $2}' | awk -F '"' '{print $2}'` / ext4 defaults 0 0 >> /mnt/root/etc/fstab
echo /dev/disk/by-uuid/`sudo blkid | grep loop1p1 | awk '{print $3}' | awk -F '"' '{print $2}'` /boot vfat defaults 0 0 >> /mnt/root/etc/fstab
```

### 2.7 Umount

```sh
umount /mnt/root/boot
umount /mnt/root
```

Copy `/mnt/boot/Image` and `/mnt/boot/initramfs-linux.img` to this repo's directory

## 3. Launch

root:root login.

```sh
./launch.sh
pacman-key --init
pacman-key --populate archlinuxarm
```
