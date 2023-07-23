{
  description = "My NixOS and Home Manager Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # You can access packages and modules from different nixpkgs revs at the
    # same time. See 'unstable-packages' overlay in 'overlays/default.nix'.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs-prev.url = "github:NixOS/nixpkgs/nixos-22.11";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    nix-formatter-pack.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-software-center.url = "github:vlinkz/nix-software-center";

    #nix-index-database.url = "github:Mic92/nix-index-database";
    #nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master"; # MacOS Package Management
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    #nur.url = "github:nix-community/NUR"; # Add "nur.nixosModules.nur" to the host modules

    #spicetify-nix.url = "github:the-argus/spicetify-nix";
    #nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

    #nixgl.url = "github:guibou/nixGL";
    #nixgl.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:NixOS/nixos-hardware/master";

    #emacs-overlay = {
    #  # Emacs Overlays
    #  url = "github:nix-community/emacs-overlay";
    #  flake = false;
    #};

    #doom-emacs = {
    #  # Nix-community Doom Emacs
    #  url = "github:nix-community/nix-doom-emacs";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  inputs.emacs-overlay.follows = "emacs-overlay";
    #};

    #hyprland = {
    #  # Official Hyprland flake
    #  url = "github:vaxerski/Hyprland"; # Add "hyprland.nixosModules.default" to the host modules
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #plasma-manager = {
    #  # KDE Plasma user settings
    #  url = "github:pjones/plasma-manager"; # Add "inputs.plasma-manager.homeManagerModules.plasma-manager" to the home-manager.users.${user}.imports
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  inputs.home-manager.follows = "nixpkgs";
    #};

    #budgie = {
    #  url = "github:FedericoSchonborn/budgie-nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };
  outputs =
    { self
    , nix-formatter-pack
    , nixpkgs
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      stateVersion = "23.05";
      libx = import ./lib { inherit inputs outputs stateVersion; };
    in
    {
      # home-manager switch -b backup --flake $HOME/Zero/nix-config
      # nix build .#homeConfigurations."juca@rocinante".activationPackage
      homeConfigurations = {
        # .iso images
        #"juca@iso-console" = libx.mkHome { hostname = "iso-console"; username = "nixos"; };
        #"juca@iso-desktop" = libx.mkHome { hostname = "iso-desktop"; username = "nixos"; desktop = "pantheon"; };
        # Workstations
        "juca@air" = libx.mkHome { hostname = "air"; username = "juca"; desktop = "pantheon"; };
        #"juca@rocinante" = libx.mkHome { hostname = "rocinante"; username = "juca"; desktop = "pantheon"; };
        #"juca@nitro" = libx.mkHome { hostname = "nitro"; username = "juca"; desktop = "pantheon"; };
        "juca@vm" = libx.mkHome { hostname = "vm"; username = "juca"; desktop = "budgie"; };
        #"juca@pi" = libx.mkHome { hostname = "pi"; username = "juca"; desktop = "pantheon"; };
        # Servers
        #"juca@vm-mini" = libx.mkHome { hostname = "vm-mini"; username = "juca"; };
        #"juca@pi-mini" = libx.mkHome { hostname = "pi-mini"; username = "juca"; };
      };
      nixosConfigurations = {
        # .iso images
        #  - nix build .#nixosConfigurations.{iso-console|iso-desktop}.config.system.build.isoImage
        #iso-console = libx.mkHost { hostname = "iso-console"; username = "nixos"; installer = nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"; };
        #iso-desktop = libx.mkHost { hostname = "iso-desktop"; username = "nixos"; installer = nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"; desktop = "pantheon"; };
        # Workstations
        #  - sudo nixos-rebuild switch --flake $HOME/Zero/nix-config
        #  - nix build .#nixosConfigurations.rocinante.config.system.build.toplevel
        air = libx.mkHost { hostname = "air"; username = "juca"; desktop = "pantheon"; };
        #rocinante = libx.mkHost { hostname = "rocinante"; username = "juca"; desktop = "pantheon"; };
        #nitro = libx.mkHost { hostname = "nitro"; username = "juca"; desktop = "pantheon"; };
        vm = libx.mkHost { hostname = "vm"; username = "juca"; desktop = "budgie"; };
        # Servers
        #pi = libx.mkHost { hostname = "pi"; username = "juca"; };
        #pi-mini = libx.mkHost { hostname = "pi-mini"; username = "juca"; };
        #vm-mini = libx.mkHost { hostname = "vm-mini"; username = "juca"; };
      };

      # Devshell for bootstrapping; acessible via 'nix develop' or 'nix-shell' (legacy)
      devShells = libx.forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      # nix fmt
      formatter = libx.forAllSystems (system:
        nix-formatter-pack.lib.mkFormatter {
          pkgs = nixpkgs.legacyPackages.${system};
          config.tools = {
            alejandra.enable = false;
            deadnix.enable = true;
            nixpkgs-fmt.enable = true;
            statix.enable = true;
          };
        }
      );

      # Custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };

      # Custom packages; acessible via 'nix build', 'nix shell', etc
      packages = libx.forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );
    };
}
