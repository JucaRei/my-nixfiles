{ config, ... }: {
  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.legacy_340;
    };
  };
  services.xserver.videoDrivers = [ "nvidia " ];

  boot.blacklistedKernelModules = [ "nouveau" ];
}
