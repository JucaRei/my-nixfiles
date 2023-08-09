{ lib, modulesPath, pkgs, ... }:
{
  imports = [
    (modulesPath + "/profiles/installation-device.nix")
    (import ./disks.nix { })
    # ../_mixins/hardware/systemd-boot.nix
    ../_mixins/hardware/boot/efi.nix
    # ../_mixins/services/security/doas.nix
    ../_mixins/services/security/sudo.nix
  ];

  ####################
  ### Boot options ###
  ####################

  boot = {

    isContainer = false;

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
        "nomodeset"
        #"video=hyperv_fb:1920x1080"
        #"kvm-intel"
      ];
      checkJournalingFS = false; # for vm

      ##########################
      ### Enabled filesystem ###
      ##########################
      supportedFilesystems = [ "xfs" ]; 
      verbose = false;
    };
    kernelPackages = pkgs.linuxPackages_lqx;

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
      "vm.overcommit_memory" = "1";
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
        efiSysMountPoint = "/boot";
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

        gfxmodeEfi = lib.mkForce "auto";
        fontSize = 20;

        configurationName = lib.mkForce "NixOS HyperV test";
      };
    };
  };

  zramSwap = {
   enable = true;
   swapDevices = 5;
   memoryPercent = 125; # 20% of total memory
   algorithm = "zstd";
  };


  services.xserver = {
    modules = with pkgs; [ 
      xrdp
      xorg.xf86videofbdev
    ];
    videoDrivers = [ "hyperv_fb" ];
    layout = lib.mkForce "br";
    exportConfiguration = true;
    # virtualScreen = {
    #   x = 1920;
    #   y = 1080;
    # };
    # resolutions = [
    #   {
    #     x = 1920;
    #     y = 1080;
    #     #y = 1200
    #   }
    #   {
    #     x = 1600;
    #     y = 1200;
    #   }
    # ];
    dpi = 96;
    logFile = "/var/log/Xorg.0.log";
    #xrandrHeads = "" ;
  };

  environment.systemPackages = with pkgs; [
    linuxKernel.packages.linux_lqx.vm-tools
    powershell
    python3Full
    python.pkgs.pip
    terminus-nerdfont
  ]

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.permittedInsecurePackages = [ "openssl-1.1.1u" "python-2.7.18.6" ];
  };
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

