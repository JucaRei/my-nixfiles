{ config, ... }: {
  hardware = {
    nvidia = {
      # Enable the nvidia settings menu
      nvidiaSettings = true;
      forceFullCompositionPipeline = true;
      powerManagement.enable = true;

      # Modesetting is needed for most Wayland compositors
      modesetting.enable = true;
    };
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_340;


  boot = {
    blacklistedKernelModules = [ "nouveau" "module_blacklist=i915" ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11_legacy340 ];
  };
}
