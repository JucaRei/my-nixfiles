{ config, ... }: {
  hardware = {
    nvidia = {
      # Enable the nvidia settings menu
      nvidiaSettings = true;
      forceFullCompositionPipeline = true;
      powerManagement.enable = true;
    };
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_340;
  services.xserver.videoDrivers = [ "nvidia " ];

  boot.blacklistedKernelModules = [ "nouveau" ];
}
