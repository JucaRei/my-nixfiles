#!/bin/sh


DEVICE=/dev/sda
sgdisk -Z ${DEVICE}

#cat | parted ${DEVICE} << END
#mktable gpt
#mkpart primary ext2 1 2
#set 1 bios_grub on
#mkpart primary xfs 2 100%
#name 2 'NIXOS'
#print
#quit
#END

parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart no-fs 1MB 2MB 
parted /dev/sda -- set 1 bios_grub on