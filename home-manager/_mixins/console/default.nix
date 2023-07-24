{ config, lib, pkgs, ... }: {

  imports = [
    ./atuin.nix
    ./dircolors.nix
    ./bat.nix
    ./broot.nix
    ./bottom.nix
    ./btop.nix
    ./direnv.nix
    ./fish.nix
    ./git.nix
    ./gh.nix
    ./glow.nix
    ./gpg.nix
    ./htop.nix
    ./micro.nix
    ./neofetch.nix
    ./nixpkgs.nix
    ./powerline-go.nix
    ./neovim.nix
    ./readline.nix
    ./variables.nix
    ./zoxide.nix
    ./xdg.nix
  ];

  home = {
    # A Modern Unix experience
    # https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/
    packages = with pkgs; [
      asciinema # Terminal recorder
      breezy # Terminal bzr client
      butler # Terminal Itch.io API client
      chafa # Terminal image viewer
      dconf2nix # Nix code from Dconf files
      debootstrap # Terminal Debian installer
      diffr # Modern Unix `diff`
      difftastic # Modern Unix `diff`
      dua # Modern Unix `du`
      duf # Modern Unix `df`
      du-dust # Modern Unix `du`
      entr # Modern Unix `watch`
      fd # Modern Unix `find`
      ffmpeg-headless # Terminal video encoder
      glow # Terminal Markdown renderer
      gping # Modern Unix `ping`
      hexyl # Modern Unix `hexedit`
      hyperfine # Terminal benchmarking
      jpegoptim # Terminal JPEG optimizer
      jiq # Modern Unix `jq`
      lazygit # Terminal Git client
      lurk # Modern Unix `strace`
      moar # Modern Unix `less`
      neofetch # Terminal system info
      nixpkgs-review # Nix code review
      nurl # Nix URL fetcher
      nyancat # Terminal rainbow spewing feline
      optipng # Terminal PNG optimizer
      procs # Modern Unix `ps`
      quilt # Terminal patch manager
      ripgrep # Modern Unix `grep`
      tldr # Modern Unix `man`
      tokei # Modern Unix `wc` for code
      wget2 # Terminal downloader
      yq-go # Terminal `jq` for YAML
    ];
  };

  programs = {
    home-manager.enable = true;
    info.enable = true;
    jq.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
