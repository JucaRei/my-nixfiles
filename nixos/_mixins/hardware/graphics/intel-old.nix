# Taken from Colemickens
# https://github.com/colemickens/nixcfg/blob/93e3d13b42e2a0a651ec3fbe26f3b98ddfdd7ab9/mixins/gfx-intel.nix
{ pkgs, config, lib, ... }: {
  config = {
    environment.systemPackages = with pkgs; [ libva-utils ];
    hardware = {
      opengl = {
        driSupport = true;
        extraPackages = with pkgs; [
          #intel-media-driver # LIBVA_DRIVER_NAME=iHD
          vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
          vaapiVdpau
          libvdpau-va-gl
        ];
        #driSupport32Bit = true;
        #extraPackages32 = with pkgs.pkgsi686Linux;
        # [
        #  intel-media-driver
        #    vaapiIntel
        #  vaapiVdpau
        #  libvdpau-va-gl
        #  libva
        # ];
      };
    };
  };
 

  # services.hardware.bolt.enable = true;
  # # Allow usb controllers via HDMI
  # services.udev.extraRules = ''KERNEL=="hidraw*", ATTRS{idVendor}=="20d6", ATTRS{idProduct}=="a711", MODE="0660", TAG+="uaccess"'';


}
