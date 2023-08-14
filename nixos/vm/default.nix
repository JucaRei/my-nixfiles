{ lib, modulesPath, pkgs, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (import ./disks.nix { })
    #../_mixins/hardware/systemd-boot.nix
    ../_mixins/hardware/boot/efi.nix
    ../_mixins/services/security/doas.nix
    ../_mixins/services/network/samba.nix
    ../_mixins/virt/docker.nix
  ];

  ####################
  ### Boot options ###
  ####################

  boot = {

    isContainer = false;

    # Force kernel log in tty1, otherwise it will override greetd
    kernelParams = [ "console=tty1" ];

    # compile kernel with SE Linux support - but also support for other LSM modules
    # kernelPatches = [{
    #   ### Add Selinux?
    #   name = "selinux-config";
    #   patch = null;
    #   extraConfig = ''
    #     ## Enable SELINUX
    #     CONFIG_SECURITY_SELINUX y
    #     CONFIG_SECURITY_SELINUX_BOOTPARAM n
    #     CONFIG_SECURITY_SELINUX_DISABLE n
    #     CONFIG_SECURITY_SELINUX_DEVELOP y
    #     CONFIG_SECURITY_SELINUX_AVC_STATS y
    #     CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE 0
    #     CONFIG_DEFAULT_SECURITY_SELINUX n
    #     CONFIG_HYPERV_TESTING n

    #     ### Memory
    #     CONFIG_HAVE_KERNEL_GZIP=y
    #     CONFIG_HAVE_KERNEL_BZIP2=y
    #     CONFIG_HAVE_KERNEL_LZMA=y
    #     CONFIG_HAVE_KERNEL_XZ=y
    #     CONFIG_HAVE_KERNEL_LZO=y
    #     CONFIG_HAVE_KERNEL_LZ4=y
    #     CONFIG_HAVE_KERNEL_ZSTD=y
    #     CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC=y
    #     CONFIG_ZSWAP_ZPOOL_DEFAULT="zsmalloc"
    #     CONFIG_ZBUD=y
    #     CONFIG_Z3FOLD=y
    #     CONFIG_ZSMALLOC=y
    #     CONFIG_ZSMALLOC_STAT=y
    #     CONFIG_ZSMALLOC_CHAIN_SIZE=8
    #     CONFIG_ZRAM_DEF_COMP_LZ4HC=y

    #     #
    #     # Compression
    #     #
    #     # CONFIG_CRYPTO_DEFLATE is not set
    #     CONFIG_CRYPTO_LZO=y
    #     # CONFIG_CRYPTO_842 is not set
    #     CONFIG_CRYPTO_LZ4=y
    #     CONFIG_CRYPTO_LZ4HC=y
    #     CONFIG_CRYPTO_ZSTD=y
    #   '';
    # }];

    #kernelParams = [ "resume_offset=140544" ];
    #resumeDevice = "/dev/disk/by-label/NIXOS";

    initrd = {
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "sr_mod"
        "virtio_blk"
      ];

      ### kernel modules to be loaded in the second stage, that are needed to mount the root file system ###
      kernelModules = [
        "zswap.compressor=z3fold"
        "z3fold"
        "crc32c-intel"
        "zswap.zpool=lz4hc"
        "lz4hc_compress"
        #"kvm-intel"
        #"v4l2loopback" # Virtual Camera
        #"snd-aloop" # Virtual Microphone, built-in
      ];
      checkJournalingFS = false; # for vm

      ##########################
      ### Enabled filesystem ###
      ##########################
      # supportedFilesystems = [ "vfat" "zfs" ];
      supportedFilesystems = [ "btrfs" ]; # fat 32 and btrfs
      compressor = "zstd";
      compressorArgs = [ "-19" "-T0" ];
      verbose = false;
    };
    #kernelPackages = pkgs.linuxPackages_latest;
    #kernelPackages = pkgs.linuxPackages_6_3;
    kernelPackages = pkgs.linuxPackages_lqx;

    # Allow compilation of packages ARM/ARM64 architectures via QEMU
    # e.g. nix-build -A <pkg> --argstr system aarch64-linux
    # https://nixos.wiki/wiki/NixOS_on_ARM#Compiling_through_QEMU
    #binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" ];

    # Temporary workaround until mwprocapture 4328 patch is merged
    # - https://github.com/NixOS/nixpkgs/pull/221209
    # kernelPackages = pkgs.linuxPackages_5_15;

    ###################
    ### Sysctl.conf ###
    ###################
    kernel.sysctl = {
      #"kernel.sysrq" = 1;
      #"kernel.printk" = "3 3 3 3";
      "vm.vfs_cache_pressure" = 500;
      "vm.swappiness" = 20;
      "vm.dirty_background_ratio" = 1;
      "vm.dirty_ratio" = 50;
    };

    ################
    ### Plymouth ###
    ################
    plymouth = {
      theme = "breeze";
      enable = true;
    };

    loader = {
      ######################
      # IF using UEFI boot #
      ######################
      efi = {
        canTouchEfiVariables = lib.mkForce false;
        efiSysMountPoint = "/boot/efi";
      };
      timeout = 5;

      ##########################
      ###### GRUB CONFIG #######
      ##########################
      grub = {
        #######################
        ### For legacy boot ###
        #######################

        #   enable = true;
        #   version = 2;
        #   device = "/dev/sda";                    # Name of hard drive (can also be vda)
        #   gfxmodeBios = "1920x1200,auto";
        #   zfsSupport = true                       # enable for zfs
        # };
        # timeout = 5;                              # Grub auto select timeout

        #####################
        ### FOR UEFI BOOT ###
        #####################

        # splashMode = "stretch";
        # theme = "";                               # set theme

        ## For encrypted boot
        # enableCryptodisk = true;  #

        ## If tpm is activated
        # trustedBoot.systemHasTPM = "YES_TPM_is_activated"
        # trustedBoot.enable = true;

        ## If using zfs filesystem
        # zfsSupport = true;                        # enable zfs
        # copyKernels = true;                       # https://nixos.wiki/wiki/NixOS_on_ZFS

        gfxmodeEfi = lib.mkForce "1920x1080,auto";
        fontSize = 20;

        configurationName = lib.mkForce "NixOS VM test";
      };
    };
  };

  #zramSwap = {
  #  enable = true;
  #  swapDevices = 3;
  #  memoryPercent = 20; # 20% of total memory
  #  algorithm = "zstd";
  #};

  ########################
  ### Mount Filesystem ###
  ########################

  # TODO: Replace this with disko
  # fileSystems."/" = {
  #   #device = "/dev/disk/by-label/NIXOS";
  #   device = "/dev/disk/by-label/root";
  #   fsType = "btrfs";
  #   options = [
  #     "subvol=@"
  #     "rw"
  #     "noatime"
  #     "nodiratime"
  #     "ssd"
  #     "nodatacow"
  #     "compress-force=zstd:5"
  #     "space_cache=v2"
  #     "commit=120"
  #     "autodefrag"
  #     "discard=async"
  #   ];
  # };

  # fileSystems."/home" = {
  #   device = "/dev/disk/by-label/NIXOS";
  #   fsType = "btrfs";
  #   options = [
  #     "subvol=@home"
  #     "rw"
  #     "noatime"
  #     "nodiratime"
  #     "ssd"
  #     "nodatacow"
  #     "compress-force=zstd:5"
  #     "space_cache=v2"
  #     "commit=120"
  #     "autodefrag"
  #     "discard=async"
  #   ];
  # };

  # fileSystems."/.snapshots" = {
  #   device = "/dev/disk/by-label/NIXOS";
  #   fsType = "btrfs";
  #   options = [
  #     "subvol=@snapshots"
  #     "rw"
  #     "noatime"
  #     "nodiratime"
  #     "ssd"
  #     "nodatacow"
  #     "compress-force=zstd:5"
  #     "space_cache=v2"
  #     "commit=120"
  #     "autodefrag"
  #     "discard=async"
  #   ];
  # };

  # fileSystems."/var/tmp" = {
  #   device = "/dev/disk/by-label/NIXOS";
  #   fsType = "btrfs";
  #   options = [
  #     "subvol=@tmp"
  #     "rw"
  #     "noatime"
  #     "nodiratime"
  #     "ssd"
  #     "nodatacow"
  #     "compress-force=zstd:5"
  #     "space_cache=v2"
  #     "commit=120"
  #     "autodefrag"
  #     "discard=async"
  #   ];
  # };

  # fileSystems."/nix" = {
  #   device = "/dev/disk/by-label/NIXOS";
  #   fsType = "btrfs";
  #   options = [
  #     "subvol=@nix"
  #     "rw"
  #     "noatime"
  #     "nodiratime"
  #     "ssd"
  #     "nodatacow"
  #     "compress-force=zstd:5"
  #     "space_cache=v2"
  #     "commit=120"
  #     "autodefrag"
  #     "discard=async"
  #   ];
  # };

  # #fileSystems."/swap" = {
  # #  device = "/dev/disk/by-label/NIXOS";
  # #  fsType = "btrfs";
  # #  options = [
  # #    "subvol=@swap"
  # #    #"compress=lz4"
  # #    "defaults"
  # #    "noatime"
  # #  ]; # Note these options effect the entire BTRFS filesystem and not just this volume, with the exception of `"subvol=swap"`, the other options are repeated in my other `fileSystem` mounts
  # #};

  # fileSystems."/boot/efi" = {
  #   device = "/dev/disk/by-label/EFI";
  #   fsType = "vfat";
  #   options = [ "defaults" "noatime" "nodiratime" ];
  #   noCheck = true;
  # };

  # swapDevices = [
  #   {
  #     device = "/dev/disk/by-label/SWAP";
  #     ### SWAPFILE
  #     #device = "/swap/swapfile";
  #     #size = 2 GiB;
  #     #device = "/swap/swapfile";
  #     #size = (1024 * 2); # RAM size
  #     #size = (1024 * 16) + (1024 * 2); # RAM size + 2 GB
  #   }
  # ];

  # ### Swapfile
  # #systemd.services = {
  # #  create-swapfile = {
  # #    serviceConfig.Type = "oneshot";
  # #    wantedBy = [ "swap-swapfile.swap" ];
  # #    script = ''
  # #      ${pkgs.coreutils}/bin/truncate -s 0 /swap/swapfile
  # #      ${pkgs.e2fsprogs}/bin/chattr +C /swap/swapfile
  # #      ${pkgs.btrfs-progs}/bin/btrfs property set /swap/swapfile compression none
  # #    '';
  # #  };
  # #};

  services.xserver = {
    layout = lib.mkForce "br";
    exportConfiguration = true;
    virtualScreen = {
      x = 1920;
      y = 1080;
    };
    resolutions = [
      {
        x = 1920;
        y = 1080;
        #y = 1200
      }
      {
        x = 1600;
        y = 1200;
      }
    ];
    dpi = 96;
    logFile = "/var/log/Xorg.0.log";
    #xrandrHeads = "" ;
  };

  services = {
    gvfs.enable = true;
  };

  ### Load z3fold and lz4

  systemd.services.zswap = {
    description = "Enable ZSwap, set to LZ4 and Z3FOLD";
    enable = true;
    wantedBy = [ "basic.target" ];
    path = [ pkgs.bash ];
    serviceConfig = {
      ExecStart = ''${pkgs.bash}/bin/bash -c 'cd /sys/module/zswap/parameters&& \
      echo 1 > enabled&& \
      echo 20 > max_pool_percent&& \
      echo lz4hc > compressor&& \
      echo z3fold > zpool'
      '';
      Type = "simple";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

#mwProCapture.enable = true;
##############
### Nvidia ###
##############
#nvidia = {
#  prime = {
#    #amdgpuBusId = "PCI:3:0:0";
#    #nvidiaBusId = "PCI:4:0:0";
#    sync.enable = true; # Enable NVIDIA Optimus support using the NVIDIA proprietary driver via PRIME. GPU will be always on and used for all rendering
# Make the Radeon RX6800 default. The NVIDIA T600 is on for CUDA/NVENC
#    reverseSync.enable = true;
#    offload = {
#      ## Enable render offload support using the NVIDIA proprietary driver via PRIME.
#      enableOffloadCmd = true; ## Adds a nvidia-offload convenience script to environment.systemPackages for offloading programs to an nvidia device
#      enable = true;
#    };
#  };
#  powerManagement = {
#    enable = true;
#    finegrained = true;
#  };
#  modesetting.enable = true; # Enabling this fixes screen tearing when using Optimus via PRIME
#  package = config.boot.kernelPackages.nvidiaPackages.stable; # nvidiaPackages.legacy_340
#  nvidiaSettings = false;
#};
######################
### OpenGL drivers ###
######################
# opengl = {
#   enable = true;
#   driSupport = true;
#   driSupport32Bit = true;
#   extraPackages = with pkgs; [intel-media-driver intel-ocl vaapiIntel];
# };
#openrazer = {
#  enable = true;
#  devicesOffOnScreensaver = false;
#  keyStatistics = true;
#  mouseBatteryNotifier = true;
#  syncEffectsEnabled = true;
#  users = ["${username}"];
#};
#xone.enable = true;
# };
###############################
### High-resolution display ###
###############################
#video.hidpi.enable = lib.mkDefault true;
###########
### CPU ###
###########
#cpu = {
#  intel = {
#    updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
#    # updateMicrocode = true;
#  };
#};
# virtualisation.virtualbox.guest.enable = true;     #currently disabled because package is broken

