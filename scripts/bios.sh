#!/bin/sh


#DEVICE=/dev/sda
#sgdisk -Z ${DEVICE}

#mklabel msdos
#cat | parted ${DEVICE} << END
##mktable gpt
#mkpart primary ext2 1 2
#set 1 bios_grub on
#mkpart primary xfs 2 100%
#name 2 'NIXOS'
#print
#quit
#END


#set 1 bios_grub on
cat | parted ${DEVICE} << END
mklabel msdos
mkpart primary ext2 1 2
set 1 boot on
mkpart primary xfs 2 100%
print
quit
0;
END

#############
### MSDOS ###
#############

parted -s -a optimal /dev/sda mklabel msdos
## parted /dev/sda -- mkpart no-fs 1MB 
parted /dev/sda -- mkpart primary ext2 0 2MiB
#parted /dev/sda -- mkpart primary ext2 1 2
parted -s /dev/sda -- set 1 boot on
#parted /dev/sda -- mkpart primary xfs 2 100%
#parted /dev/sda -- name 2 'NIXOS'
#parted /dev/sda -- print
##parted /dev/sda -- mkpart primary 1MB 100%
##parted /dev/sda -- set 1 bios_grub on


###############################################
##parted /dev/sda -- mklabel msdos
###parted /dev/sda -- mkpart primary 1MB -8GB # Swap
##parted /dev/sda -- mkpart primary 1MB 100%
##parted /dev/sda -- set 1 boot on
##
##DEVICE=/dev/sda
##OPTS="defaults,noatime,nodiratime"
##
###mkfs.xfs -f -L "NIXOS" ${DEVICE}2
##mkfs.xfs -f -L "NIXOS" /dev/sda1
##mount -o ${OPTS} /dev/disk/by-label/NIXOS /mnt

################
### GPT bios ###
################

parted -s -a optimal /dev/sda mklabel gpt
#parted /dev/sda -- mklabel gpt
parted -s /dev/sda -- mkpart primary ext2 1 2
parted -s /dev/sda -- set 1 bios_grub on
parted -s /dev/sda -- mkpart primary ext4 2 100%
#parted /dev/sda -- mkpart primary xfs 2 100%
parted -s /dev/sda -- name 2 'NIXOS'
parted /dev/sda -- print

#mkfs.ext4 -O "^has_journal" /dev/sda2 -L "NIXOS" -F
#mount -t ext4 -O defaults,data=writeback,noatime,commit=60,barrier=0,discard /dev/sda3 /mnt
