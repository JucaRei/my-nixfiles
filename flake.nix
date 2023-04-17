{
  description = "Nix and Nixos configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11"; # primary nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # for packages on the edge

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    home-manager = {
      # User Package Management
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # use versions from nixpkgs
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master"; # MacOS Package Management
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      # NUR Packages
      url = "github:nix-community/NUR"; # Add "nur.nixosModules.nur" to the host modules
    };

    nixgl = {
      # OpenGL
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      # Emacs Overlays
      url = "github:nix-community/emacs-overlay";
      flake = false;
    };

    doom-emacs = {
      # Nix-community Doom Emacs
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.emacs-overlay.follows = "emacs-overlay";
    };

    hyprland = {
      # Official Hyprland flake
      url = "github:vaxerski/Hyprland"; # Add "hyprland.nixosModules.default" to the host modules
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      # KDE Plasma user settings
      url = "github:pjones/plasma-manager"; # Add "inputs.plasma-manager.homeManagerModules.plasma-manager" to the home-manager.users.${user}.imports
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
  }: {
    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;
  };
}
