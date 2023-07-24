{ config, desktop, lib, outputs, pkgs, stateVersion, username, inputs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  # Only import desktop configuration if the host is desktop enabled
  # Only import user specific configuration if they have bespoke settings
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ./_mixins/shared
  ]
  ++ lib.optional (builtins.isString desktop) ./_mixins/desktop
  ++ lib.optional (builtins.isPath (./. + "/_mixins/users/${username}")) ./_mixins/users/${username};

  home = {
    activation.report-changes = config.lib.dag.entryAnywhere ''
      ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
    '';
    homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
    sessionPath = [ "$HOME/.local/bin" ];
    inherit stateVersion;
    inherit username;
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
      # Allow unsupported packages to be built
      allowUnsupportedSystem = true;
      # Disable broken package
      allowBroken = false;
      # Disable if you don't want unfree packages
      allowUnfree = true;
      ### Allow old broken electron
      permittedInsecurePackages = lib.singleton "electron-12.2.3";
      # Accept the joypixels license
      joypixels.acceptLicense = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    checkConfig = true;
    #checkAllErrors = true;

    # 🍑 smooth rebuilds
    # Reduce disk usage
    #daemonIOSchedClass = "idle";
    # Leave nix builds as a background task
    #daemonCPUSchedPolicy = "idle";
    #daemonIOSchedPriority = 2; # 7 max

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    optimise = {
      automatic = true;
      dates = [ "00:00" "05:00" "12:00" "21:00" ];
    };
    package = lib.mkDefault pkgs.unstable.nix;
    settings = {
      #sandbox = true;
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;

      # https://nixos.org/manual/nix/unstable/command-ref/conf-file.html
      keep-going = false;

      # Allow to run nix
      allowed-users = [ "${username}" "nixbld" "wheel" ];
    };

    extraOptions = ''
      keep-outputs          = true
      keep-derivations      = false

      # Free up to 1GiB whenever there is less than 100MiB left.
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
