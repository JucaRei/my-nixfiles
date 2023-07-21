{ lib, pkgs, ... }: {

  imports = [ ./fwupd.nix ];

  ######################################
  ### Default Services for all hosts ###
  ######################################

  services = {
    xserver = {
      layout = if (builtins.isString == "nitro") then "br" else "us";
      xkbModel = lib.mkDefault "pc105";
    };

    ananicy = {
      enable = lib.mkDefault true;
      package = pkgs.ananicy-cpp;
    };

    earlyoom = {
      enable = lib.mkDefault false;
    };

    irqbalance = {
      enable = true;
    };

    dbus = {
      implementation = lib.mkDefault "broker";
    };

    resolved = {
      enable = true;
      extraConfig = ''
        # No need when using Avahi
        MulticastDNS=no
      '';
    };

    logind = {
      lidSwitch = "suspend";
      extraConfig = ''
        HandlePowerKey=suspend-then-hibernate
      '';
    };

    # For battery status reporting
    #upower = { enable = true; };

    # Only suspend on lid closed when laptop is disconnected
    #logind = {
    #  lidSwitch = "suspend-then-hibernate";
    #  lidSwitchDocked = lib.mkDefault "ignore";
    #  lidSwitchExternalPower = lib.mkDefault "lock";
    #};};
  };
}
