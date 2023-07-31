# Intel Skull Canyon NUC6i7KYK
{ inputs, lib, pkgs, config, modulesPath, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.apple-macbook-air-4
    inputs.nixos-hardware.nixosModules.framework
    inputs.nixos-hardware.nixosModules.common-cpu-intel-sandy-bridge
    # (import ./disks.nix { })
    (modulesPath + "/installer/scan/not-detected.nix")
    ../_mixins/hardware/boot/efi.nix
    ../_mixins/hardware/bluetooth
    ../_mixins/hardware/backlight/acpilight.nix
    ../_mixins/hardware/cpu/intel.nix
    ../_mixins/hardware/graphics/intel-old.nix
    ../_mixins/hardware/wifi/broadcom-wifi.nix
    #../_mixins/services/zerotier.nix
    ../_mixins/services/security/sudo.nix
    ../_mixins/services/network/samba.nix
    ../_mixins/services/network/nfs.nix
    ../_mixins/virt/docker.nix
    ../_mixins/virt
  ];

  # disko does manage mounting of / /boot /home, but I want to mount by-partlabel
  ###################
  ### Hard drives ###
  ###################

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
      "compress-force=zstd:15"
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
      "compress-force=zstd:15"
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
      "compress-force=zstd:15"
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
    isContainer = false;

    # compile kernel with SE Linux support - but also support for other LSM modules
    kernelPatches = [{
      ### Add Selinux?
      name = "selinux-config";
      patch = null;
      extraConfig = ''
        ## Enable SELINUX
        CONFIG_SECURITY_SELINUX y
        CONFIG_SECURITY_SELINUX_BOOTPARAM n
        CONFIG_SECURITY_SELINUX_DISABLE n
        CONFIG_SECURITY_SELINUX_DEVELOP y
        CONFIG_SECURITY_SELINUX_AVC_STATS y
        CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE 0
        CONFIG_DEFAULT_SECURITY_SELINUX n
        CONFIG_HYPERV_TESTING n

        ### Memory
        CONFIG_HAVE_KERNEL_GZIP=y
        CONFIG_HAVE_KERNEL_BZIP2=y
        CONFIG_HAVE_KERNEL_LZMA=y
        CONFIG_HAVE_KERNEL_XZ=y
        CONFIG_HAVE_KERNEL_LZO=y
        CONFIG_HAVE_KERNEL_LZ4=y
        CONFIG_HAVE_KERNEL_ZSTD=y
        CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC=y
        CONFIG_ZSWAP_ZPOOL_DEFAULT="zsmalloc"
        CONFIG_ZBUD=y
        CONFIG_Z3FOLD=y
        CONFIG_ZSMALLOC=y
        CONFIG_ZSMALLOC_STAT=y
        CONFIG_ZSMALLOC_CHAIN_SIZE=8
        CONFIG_ZRAM_DEF_COMP_LZ4HC=y

        #
        # Compression
        #
        # CONFIG_CRYPTO_DEFLATE is not set
        CONFIG_CRYPTO_LZO=y
        # CONFIG_CRYPTO_842 is not set
        CONFIG_CRYPTO_LZ4=y
        CONFIG_CRYPTO_LZ4HC=y
        CONFIG_CRYPTO_ZSTD=y
      '';
    }];

    #plymouth = {
    #  enable = lib.mkForce true;
    #  theme = "breeze";
    #};

    loader = {
      efi = {
        #canTouchEfiVariables = lib.mkDefault true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        #gfxmodeEfi = lib.mkForce "1366x788";
        efiInstallAsRemovable = lib.mkForce true;
      };
    };
    blacklistedKernelModules = lib.mkForce [ "nvidia" "nouveau" ];
    #extraModulePackages = with config.boot.kernelPackages; [ ];
    #extraModprobeConfig = ''
    #  options i915 enable_guc=2 enable_dc=4 enable_hangcheck=0 error_capture=0 enable_dp_mst=0 fastboot=1 #parameters may differ
    #'';

    initrd = {
      #systemd.enable = true; # This is needed to show the plymouth login screen to unlock luks
      availableKernelModules =
        [ "uhci_hcd" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      verbose = false;
      compressor = "zstd";
      supportedFilesystems = [ "vfat" "btrfs" "ntfs" ];
    };

    kernelModules = [
      "applesmc"
      "i965"
      #"i915"
      "z3fold"
      #"hdapsd"
      "crc32c-intel"
      "lz4hc"
      "lz4hc_compress"
    ];
    kernelParams = [
      # "security=selinux" # tell kernel to use SE Linux
      "hid_apple.swap_opt_cmd=1" # This will switch the left Alt and Cmd key as well as the right Alt/AltGr and Cmd key.
      #"hid_apple.fnmode=2"
      #"hid_apple.swap_fn_leftctrl=1"
      "video.use_native_backlight=1"
      "acpi=force"
      "acpi_backlight=video" # "acpi_backlight=vendor"
      #"i915.force_probe=0116" # Force enable my intel graphics
      #"video=efifb:off" # Disable efifb driver, which crashes Xavier AGX/NX
      #"video=efifb"
      "zswap.enabled=1"
      "zswap.compressor=lz4hc"
      "zswap.max_pool_percent=20"
      "zswap.zpool=z3fold"
      "fs.inotify.max_user_watches=524288"
      #"intel_iommu=on"
      "net.ifnames=0"
    ];
    kernel.sysctl = {
      #"kernel.sysrq" = 1;
      #"kernel.printk" = "3 3 3 3";
      "dev.i915.perf_stream_paranoid" = 0;
      #"vm.vfs_cache_pressure" = 300;
      #"vm.swappiness" = 25;
      #"vm.dirty_background_ratio" = 1;
      #"vm.dirty_ratio" = 50;
    };
    #kernelPackages = pkgs.linuxPackages_latest;
    #kernelPackages = pkgs.linuxPackages_zen;
    kernelPackages = pkgs.linuxPackages_zen;
    #kernelPackages = pkgs.linuxPackages_xanmod_stable;
    supportedFilesystems = [ "btrfs" ]; # fat 32 and btrfs
  };
  #hardware = {
  #  acpilight.enable = true;
  #};

  #Section "Device"
  #        Identifier "card0"
  #        Driver "intel"
  #        Option "Backlight" "intel_backlight"
  #        BusID "PCI:0:2:0"
  #EndSection

  services = {
    #############
    ### Btrfs ###
    #############

    btrfs = {
      autoScrub = {
        enable = true;
        interval = "weekly";
      };
    };

    ############
    ### GVFS ###
    ############
    gvfs.enable = true;


    ################################
    ### Device specific services ###
    ################################
    mbpfan = {
      enable = true;
      aggressive = true;
      #lowTemp = 56;
      #highTemp = 62;
      #maxTemp = 70;
    };

    xserver.libinput.touchpad = {
      horizontalScrolling = false;
      naturalScrolling = false;
      tapping = true;
      tappingDragLock = false;
    };
  };

  environment.systemPackages = with pkgs; [
    xorg.xbacklight
    xorg.xrdb
    intel-gpu-tools
    inxi
    #light
    kbdlight

    cifs-utils

    # SElinux
    # policycoreutils is for load_policy, fixfiles, setfiles, setsebool, semodile, and sestatus.
    #policycoreutils
  ];

  # build systemd with SE Linux support so it loads policy at boot and supports file labelling
  #systemd.package = pkgs.systemd.override { withSelinux = true; };

  programs = {
    kbdlight.enable = true;
    #light.enable = true;
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  security.doas.enable = lib.mkDefault false;

  virtualisation.docker = { storageDriver = lib.mkForce "btrfs"; };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
