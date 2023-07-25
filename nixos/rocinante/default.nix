# Gigabyte GB-BXCEH-2955 (Celeron 2955U: Haswell)

{ inputs, lib, pkgs, config, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    (import ./disks.nix { })
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
    device = "/dev/disk/by-partlabel/root";
    fsType = "xfs";
    options = [ "defaults" "relatime" "nodiratime" ];
  };

  fileSystems."/boot/efi" = lib.mkForce {
    device = "/dev/disk/by-partlabel/bios";
    fsType = "vfat";
  };

  fileSystems."/home" = lib.mkForce {
    device = "/dev/disk/by-partlabel/home";
    fsType = "xfs";
    options = [ "defaults" "relatime" "nodiratime" ];
  };

  swapDevices = [{
    device = "/swap";
    size = 2048;
  }];

  boot = {
    initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "ahci" "firewire_ohci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
    kernelModules = [ "kvm-intel" ];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_6_3;
  };

  # Use passed hostname to configure basic networking
  networking = {
    defaultGateway = "192.168.2.1";
    interfaces.enp3s0.ipv4.addresses = [{
      address = "192.168.2.10";
      prefixLength = 24;
    }];
    nameservers = [ "192.168.2.1" ];
    useDHCP = lib.mkForce false;
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
