{ config, lib, pkgs, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia "$@"
    exit 0
  '';
in
{
  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.legacy_340;
      # Enable the nvidia settings menu
      nvidiaSettings = true;
      forceFullCompositionPipeline = true;
      #powerManagement.enable = true;

      # Modesetting is needed for most Wayland compositors
      #modesetting.enable = true;
    };
  };

  services = {
    xserver = {
      deviceSection = lib.mkDefault ''
        Option "TearFree" "true"
      '';
      config = ''
        Section "Device"
          Identifier "Nvidia Card"
          Driver "nvidia"
          VendorName "NVIDIA Corporation"
          Option "RegistryDwords" "EnableBrightnessControl=1"
        EndSection
      '';
      #videoDrivers = [ "nvidiaLegacy340" ];
    };
  };


  boot = {
    blacklistedKernelModules = [ "nouveau" "module_blacklist=i915" ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11_legacy340 ];
  };

  virtualisation.docker.enableNvidia = true;
}
