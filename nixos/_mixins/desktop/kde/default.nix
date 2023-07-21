#
# KDE Plasma 5 configuration
#

{ config, lib, pkgs, ... }:

{

  programs = {
    zsh.enable = true;
    dconf.enable = true;
    kdeconnect = {
      # For GSConnect
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };

  services = {
    xserver = {
      enable = true;

      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          scrollMethod = "twofinger";
        };
        disableWhileTyping = true;
      };
      # modules = [ pkgs.xf86_input_wacom ]; # Both needed for wacom tablet usage
      # wacom.enable = true;

      displayManager = {
        sddm.enable = true; # Display Manager
        defaultSession = "plasmawayland";
      };
      desktopManager.plasma5 = {
        enable = true; # Desktop Manager
        runUsingSystemd = true;
      };
    };
  };

  #hardware.pulseaudio.enable = false;

  environment = {
    plasma5.excludePackages = with pkgs.libsForQt5;
      [
        elisa
        khelpcenter
        konsole
        oxygen
      ];
    systemPackages = with pkgs.libsForQt5; [
      # Packages installed
      packagekit-qt
      bismuth
    ];

  };
}
