# Intel Skull Canyon NUC6i7KYK
{ inputs, lib, pkgs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.apple-macbook-air-4
    inputs.nixos-hardware.nixosModules.common-cpu-intel-sandy-bridge
    # (import ./disks.nix { })
    ../_mixins/hardware/systemd-boot.nix
    ../_mixins/services/bluetooth.nix
    ../_mixins/services/zerotier.nix
    ../_mixins/virt
  ];

  # disko does manage mounting of / /boot /home, but I want to mount by-partlabel
  fileSystems."/" = {
    device = "/dev/disk/by-partlabel/NIXOS";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "rw"
      "noatime"
      "nodiratime"
      "ssd"
      "nodatacow"
      "compress-force=zstd:5"
      "space_cache=v2"
      "commit=120"
      "autodefrag"
      "discard=async"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-partlabel/NIXOS";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "rw"
      "noatime"
      "nodiratime"
      "ssd"
      "nodatacow"
      "compress-force=zstd:5"
      "space_cache=v2"
      "commit=120"
      "autodefrag"
      "discard=async"
    ];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-partlabel/NIXOS";
    fsType = "btrfs";
    options = [
      "subvol=@snapshots"
      "rw"
      "noatime"
      "nodiratime"
      "ssd"
      "nodatacow"
      "compress-force=zstd:5"
      "space_cache=v2"
      "commit=120"
      "autodefrag"
      "discard=async"
    ];
  };

  fileSystems."/var/tmp" = {
    device = "/dev/disk/by-partlabel/NIXOS";
    fsType = "btrfs";
    options = [
      "subvol=@tmp"
      "rw"
      "noatime"
      "nodiratime"
      "ssd"
      "nodatacow"
      "compress-force=zstd:5"
      "space_cache=v2"
      "commit=120"
      "autodefrag"
      "discard=async"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-partlabel/NIXOS";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "rw"
      "noatime"
      "nodiratime"
      "ssd"
      "nodatacow"
      "compress-force=zstd:5"
      "space_cache=v2"
      "commit=120"
      "autodefrag"
      "discard=async"
    ];
  };

  #fileSystems."/swap" = {
  #  device = "/dev/disk/by-partlabel/NIXOS";
  #  fsType = "btrfs";
  #  options = [
  #    "subvol=@swap"
  #    #"compress=lz4"
  #    "defaults"
  #    "noatime"
  #  ]; # Note these options effect the entire BTRFS filesystem and not just this volume, with the exception of `"subvol=swap"`, the other options are repeated in my other `fileSystem` mounts
  #};

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-partlabel/EFI";
    fsType = "vfat";
    options = [ "defaults" "noatime" "nodiratime" ];
    noCheck = true;
  };

  swapDevices = [{
    device = "/dev/disk/by-partlabel/SWAP";
    ### SWAPFILE
    #device = "/swap/swapfile";
    #size = 2 GiB;
    #device = "/swap/swapfile";
    #size = (1024 * 2); # RAM size
    #size = (1024 * 16) + (1024 * 2); # RAM size + 2 GB
  }];

  boot = {
    initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "usbhid" "sd_mod" ];
    kernelModules = [ "i915" "kvm-intel" "wl" "crc32c-intel" "lz4hc" "z3fold" "lz4hc_compress" ];
    kernelParams = [
      "hid_apple.swap_opt_cmd=1" # This will switch the left Alt and Cmd key as well as the right Alt/AltGr and Cmd key.
      "i915.force_probe=0116" # Force enable my intel graphics
      #"video=efifb:off" # Disable efifb driver, which crashes Xavier AGX/NX
      #"video=efifb"
      "zswap.enabled=1"
      "zswap.compressor=lz4hc"
      "zswap.max_pool_percent=20"
      "zswap.zpool=z3fold"
      "fs.inotify.max_user_watches=524288"
      "mitigations=off"
    ];
    kernel.sysctl = {
      #"kernel.sysrq" = 1;
      #"kernel.printk" = "3 3 3 3";
      "vm.vfs_cache_pressure" = 400;
      "vm.swappiness" = 20;
      "vm.dirty_background_ratio" = 1;
      "vm.dirty_ratio" = 50;
    };
    #kernelPackages = pkgs.linuxPackages_zen;
    supportedFilesystems = [ "btrfs" ]; # f
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
  };



  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
