# Shell for bootstrapping flake-enabled nix and home-manager
# Enter it through 'nix develop' or (legacy) 'nix-shell'

{ pkgs ? (import ./nixpkgs.nix) { } }: {
  default = pkgs.mkShell {
    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = nix-command flakes repl-flake";
    nativeBuildInputs = with pkgs; [ nix home-manager git duf nixpkgs-fmt nix-bash-completions nix-du alejandra speedtest-cli ];
    shellHook = ''
      echo "
       ______   _           _
      |  ____| | |         | |
      | |__    | |   __ _  | | __   ___   ___
      |  __|   | |  / _\` | | |/ /  / _ \ / __|
      | |      | | | (_| | |   <  |  __/ \\__ \\
      |_|      |_|  \__,_| |_|\_\  \___| |___/
          "
    '';
  };
}

# echo $HOME/.nix-profile/bin/fish | sudo tee -a /etc/shells
# chsh -s $HOME/.nix-profile/bin/fish