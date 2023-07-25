#!/bin/sh
export drive="/dev/sda"

#        mkpart no-fs 0 1024KiB \

sgdisk -Z $drive
parted -s -a optimal $drive \
       mklabel gpt \
       mkpart no-fs 0 1MiB \
       align-check optimal 1 \
       set 1 bios_grub on \
       print


parted --script $drive -- \
        mklabel gpt \
        mkpart no-fs 0 1MiB \
        set 1 bios_grub on \
        align-check optimal 1 \
        print

mkfs.xfs $drive -f -L "NIXOS"

opts="defaults,noatime,nodiratime"
mount -o $opts $drive /mnt