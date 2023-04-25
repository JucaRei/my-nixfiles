# Shell for bootstrapping flake-enabled nix and home-manager
{ pkgs ? let
    # If pkgs is not defined, instantiate nixpkgs from locked commit
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
    system = builtins.currentSystem;
    overlays = [ ]; # Explicit blank overlay to avoid interference
  in
  import nixpkgs { inherit system overlays; 
  }
, ...
}:
pkgs.mkShell {
  name = "nixosbuildshell";
  nativeBuildInputs = with pkgs; [
    git
    # git-crypt
    nix-direnv
    direnv
    nil
    nixFlakes
    home-manager
    neovim
    nano
    rnix-lsp
    nixpkgs-fmt
  ];

  shellHook = ''
    alias build="echo build"
      echo "You can apply this flake to your system with nixos-rebuild switch --flake .#"
      echo "
       ______   _           _
      |  ____| | |         | |
      | |__    | |   __ _  | | __   ___   ___
      |  __|   | |  / _\` | | |/ /  / _ \ / __|
      | |      | | | (_| | |   <  |  __/ \\__ \\
      |_|      |_|  \__,_| |_|\_\  \___| |___/
          "
      PATH=${pkgs.writeShellScriptBin "nix" ''
      ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
    ''}/bin:$PATH
  '';
}
