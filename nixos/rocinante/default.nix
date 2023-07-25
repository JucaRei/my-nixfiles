# MacbookPro 4,1 early 2009
# nvidia 8600 gt

{ inputs, lib, pkgs, config, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    #(import ./disks.nix { })
    ../_mixins/hardware/boot/bios.nix
    ../_mixins/hardware/bluetooth
    ../_mixins/hardware/cpu/intel.nix
    ../_mixins/hardware/wifi/broadcom-wifi.nix
    ../_mixins/hardware/graphics/nvidia-old.nix
    ../_mixins/services/security/sudo.nix
    ../_mixins/virt/docker-legacy.nix
  ];

  # disko does manage mounting of / /boot /home, but I want to mount by-partlabel
  fileSystems."/" = lib.mkForce {
    device = "/dev/disk/by-label/NIXOS";
    fsType = "xfs";
    options = [ "defaults" "noatime" "nodiratime" ];
  };

  swapDevices = [{
    device = "/swap";
    size = 2048;
  }];

  boot = {
    initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "ahci" "firewire_ohci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
    kernelModules = [ "applesmc" "kvm-intel" "bcm5974" ];
    #kernelPackages = lib.mkDefault pkgs.linuxPackages_6_3;
    #kernelPackages = lib.mkDefault pkgs.linuxPackages_5_4;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_5_15;
    #kernelParams = [ "intel_idle.max_cstate=1" "hid_apple.iso_layout=0" "acpi_backlight=vendor" "acpi_mask_gpe=0x15" ];
    kernelParams = [ "intel_idle.max_cstate=1" "acpi_backlight=vendor" ];
    loader.grub = {
      gfxpayloadBios = "1920x1200";
    };
    extraModprobeConfig = ''
      options bcm5974
    '';
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    setLdLibraryPath = true;
  };

  hardware.acpilight.enable = true;

  services = {
    mbpfan = {
      enable = true;
      aggressive = true;
    };
    xserver = {
      deviceSection = lib.mkDefault ''
        Option "TearFree" "true"
      '';
      libinput = {
        enable = lib.mkForce false;
        touchpad = {
          horizontalScrolling = true;
          naturalScrolling = false;
          tapping = true;
          tappingDragLock = false;
        };
      };
      synaptics = {
        enable = lib.mkDefault true;
        twoFingerScroll = true;
        tapButtons = true;
        palmDetect = true;
        horizontalScroll = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    xorg.xbacklight
    xorg.xrdb
    #intel-gpu-tools
    inxi
  ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
