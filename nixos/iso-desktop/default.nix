{ lib
, pkgs
, config
, ...
}: {
  imports = [
    ../_mixins/hardware/bluetooth
    ../_mixins/services/sound/pipewire.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_5_10;
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback nvidiaPackages.legacy_340 nvidiaPackages.stable nvidia_x11_legacy340 broadcom_sta ];
    extraModprobeConfig = lib.mkDefault "";
    initrd = {
      availableKernelModules = [ ];
      kernelModules = [ ];
      verbose = false;
    };

    kernelModules = [ "vhost_vsock" ];

    kernel.sysctl = {
      #"net.ipv4.ip_forward" = 1;
      #"net.ipv6.conf.all.forwarding" = 1;
    };
  };

  services = {
    xserver.videoDrivers = [ ];
    ananicy.enable = lib.mkForce false;
    irqbalance.enable = lib.mkForce false;
    fstrim.enable = lib.mkDefault false;
    earlyoom.enable = lib.mkForce false;
    udisks2.enable = lib.mkDefault false;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
