# Shell for bootstrapping flake-enabled nix and home-manager
{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "nixosbuildshell";
  nativeBuildInputs = with pkgs; [
    git
    # git-crypt
    nix-direnv
    nil
    nixFlakes
    home-manager
    neovim
    nano
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
