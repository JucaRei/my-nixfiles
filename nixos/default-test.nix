{ config, desktop, hostname, inputs, lib, modulesPath, outputs, pkgs, stateVersion, username, ... }: {
  imports = [
    inputs.disko.nixosModules.disko
    (modulesPath + "/installer/scan/not-detected.nix")
    ./${hostname}
    #./_mixins/services/firewall.nix
    #./_mixins/services/fwupd.nix
    #./_mixins/services/kmscon.nix
    #./_mixins/services/openssh.nix
    #./_mixins/services/smartmon.nix
    ./_mixins/shared
    ./_mixins/users/root
    ./_mixins/users/${username}
  ] ++ lib.optional (builtins.isString desktop) ./_mixins/desktop;

  # Only install the docs I use
  documentation.enable = true;
  documentation.nixos.enable = false;
  documentation.man.enable = true;
  documentation.info.enable = false;
  documentation.doc.enable = false;


  # Use passed hostname to configure basic networking
  networking = {
    #extraHosts = ''
    #  192.168.192.40  skull-zt
    #  192.168.192.59  trooper-zt
    #  192.168.192.181 zed-zt
    #  192.168.192.220 ripper-zt
    #  192.168.192.162 p1-zt
    #  192.168.192.249 p2-max-zt
    #  #192.168.192.0   brix-zt
    #  #192.168.192.0   nuc-zt
    #
    #'';
    hostName = hostname;
    useDHCP = lib.mkDefault true;
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Accept the joypixels license
      joypixels.acceptLicense = true;
    };
  };

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    optimise.automatic = true;
    package = pkgs.unstable.nix;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /nix/var/nix/profiles/per-user/${username} 0755 ${username} root"
    "d /mnt/snapshot/${username} 0755 ${username} users"
  ];

  system.activationScripts = {
    diff = {
      supportsDryActivation = true;
      text = ''
        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
      '';
    };
    fixboot.text = ''
      ln -sfn "$(readlink -f "$systemConfig")" /run/current-system
    '';
  };
  system.stateVersion = stateVersion;
}
