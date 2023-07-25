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
    ../_mixins/virt
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
    kernelModules = [ "kvm-intel" ];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_6_3;
    kernelParams = [ "intel_idle.max_cstate=1" ];
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.acpilight.enable = true;

  services = {
    mbpfan = {
      enable = true;
      aggressive = true;
    };
    xserver.libinput.touchpad = {
      horizontalScrolling = true;
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
  ];

  services.xserver.videoDrivers = [ "nvidia " ];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
