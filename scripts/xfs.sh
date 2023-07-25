#!/bin/sh

DEVICE=/dev/sda
opts="defaults,noatime,nodiratime"

#mkfs.xfs -f -L "NIXOS" ${DEVICE}2
mkfs.xfs -f -L "NIXOS" ${DEVICE}1
mount -o $opts /dev/disk/by-partlabel/NIXOS /mnt