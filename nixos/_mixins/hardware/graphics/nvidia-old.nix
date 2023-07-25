{ config, ... }: {
  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.legacy_340;
      # Enable the nvidia settings menu
      nvidiaSettings = true;
      forceFullCompositionPipeline = true;
      powerManagement.enable = true;
    };
  };
  services.xserver.videoDrivers = [ "nvidia " ];

  boot.blacklistedKernelModules = [ "nouveau" ];
}
