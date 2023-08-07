{ pkgs, lib, ... }:

let # env vars required for finegrained
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-GO
    export __GLX_VENDOR_LIBRARY_NAME=nvidia::
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';

  intelBusId = "PCI:0:2:0";
  nvidiaBusId = "PCI:1:0:0";
in
{
  # install shell script defined above
  environment.systemPackages = [ 
    nvidia-offload 
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
  ];

  # enable secondary monitors at boot time
  specialisation = {
    external-display.configuration = {
      system.nixos.tags = [ "external-display" ];
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce false;
        powerManagement = {
          enable = lib.mkForce false;
          finegrained = lib.mkForce false;
        };
      };
    };
  };

  hardware.nvidia = {
    package = pkgs.linuxKernel.packages.linux_zen.nvidia_x11; # zen kernel
    modesetting.enable = true;
    nvidiaPersistenced = true;
    prime = {
      offload.enable = true;

      # Bus ID of the Intel GPU
      # Find it using lspci, either under 3D or VGA
      inherit intelBusId;

      # Bus ID of the Nvidia GPU
      # Find it using lspci, either under 3D or VGA
      inherit nvidiaBusId;
    };

    powerManagement = {
      # enable systemd-based graphical suspend to prevent black screen on resume
      enable = true;
      # power down GPU when no applications are running that require nvidia
      finegrained = true;
    };
  };

  boot = {
    blacklistedKernelModules = lib.mkForce [ "nouveau" ];
    kernelParams = [
      "clearcpuid=514" # Fixes certain wine games crash on launch
      "nvidia"
      "nvidia_modeset"
      "nvidia-uvm"
      "nvidia_drm"
    ];
    kernel.sysctl = { "vm.max_map_count" = 2147483642; };
  };

  services.xserver.videoDrivers = ["nvidia"];
}