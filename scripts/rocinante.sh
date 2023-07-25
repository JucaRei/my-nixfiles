#!/bin/sh


DEVICE=/dev/sda
sgdisk -Z ${DEVICE}

cat | parted ${DEVICE} << END
mktable gpt
mkpart primary ext2 1 2
set 1 bios_grub on
mkpart primary xfs 2 100%
print
quit
END

mkfs.xfs -f -L "NIXOS" ${device}2
opts="defaults,noatime,nodiratime"
mount -o $opts /dev/disk/by-partlabel/NIXOS /mnt

lsblk -fm
