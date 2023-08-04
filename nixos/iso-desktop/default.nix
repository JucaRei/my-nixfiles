{ lib
, pkgs
, config
, ...
}: {
  imports = [
    ../_mixins/hardware/bluetooth
    ../_mixins/hardware/backlight/brillo.nix
    ../_mixins/services/sound/pulseaudio.nix
    ../_mixins/services/network/samba.nix
    ../_mixins/services/shared/shells.nix
    ../_mixins/services/shared/console.nix
    ../_mixins/services/peripherals/usb.nix
    ../_mixins/apps/browsers/chromium.nix
    ../_mixins/apps/terminal/tilix.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_6_1;
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback nvidiaPackages.legacy_340 nvidia_x11_legacy340 broadcom_sta ];
    extraModprobeConfig = lib.mkDefault "";
    initrd = {
      availableKernelModules = [ ];
      kernelModules = [ ];
      verbose = false;
    };

    kernelModules = [ "vhost_vsock" "wl" "nvidia" "b43" ];

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
