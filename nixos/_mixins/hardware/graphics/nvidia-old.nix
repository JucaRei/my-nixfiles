{ config, ... }: {
  hardware = {
    nvidia = {
      # Enable the nvidia settings menu
      nvidiaSettings = true;
      forceFullCompositionPipeline = true;
      #powerManagement.enable = true;
    };
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_340;


  boot = {
    blacklistedKernelModules = [ "nouveau" ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11_legacy340 ];
  };
}
