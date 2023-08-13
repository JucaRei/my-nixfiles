{ pkgs, ... }: {
  imports = [
    #./qt-style.nix
    #../services/networkmanager.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      #
      cargo
      cava
      compsize
      curl
      dconf
      gcc
      home-manager
      htop
      lua
      # nodejs  
      mangohud    
      tree-sitter
      unzip
      vim
      wget
      wl-clipboard
      zip
    ];
  };

  # Enable some programs to provide a complete desktop
  programs = {
    #nm-applet.enable = true;
    system-config-printer.enable = true;
    dconf.enable = true;
    hyprland.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        xfconf
        thunar-volman
      ];
    };
  };

  # Enable services to round out the desktop
  services = {
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs = {
      enable = true;
      package = lib.mkForce pkgs.gnome3.gvfs;
    };
    system-config-printer.enable = true;
    xserver = {
      enable = true;
      displayManager = {
        gdm.enable = true;
      };
    };

    desktopManager = {
      mate.enable = true;
    };
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      pkgs.xdg-desktop-portal-hyprland
    ];
  };
  security.pam.services.swaylock = {
    #Swaylock fix for wrong password
    text = ''
      auth include login
    '';
  };

  hardware = {
    opengl = true;
    driSupport = true;
    driSupport32Bit = true;
  };
};
