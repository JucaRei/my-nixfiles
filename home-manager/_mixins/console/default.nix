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
    #./fzf.nix
    ./git.nix
    ./gh.nix
    ./glow.nix
    #./gpg.nix
    ./htop.nix
    ./micro.nix
    ./neofetch.nix
    #./nixpkgs.nix
    #./powerline-go.nix
    #./neovim.nix
    ./readline.nix
    ./exa.nix
    ./starship.nix
    ./yt-dlp.nix
    ./zoxide.nix
    ./xdg.nix
    ./skim.nix
    ./command-not-found
    #./zsh.nix
  ];

  home = {
    # A Modern Unix experience
    # https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/
    packages = with pkgs; [
      asciinema # Terminal recorder
      #breezy # Terminal bzr client
      #butler # Terminal Itch.io API client
      chafa # Terminal image viewer
      #debootstrap # Terminal Debian installer
      diffr # Modern Unix `diff`
      difftastic # Modern Unix `diff`
      dua # Modern Unix `du`
      duf # Modern Unix `df`
      #du-dust # Modern Unix `du`
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
      #nixpkgs-review # Nix code review
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
      ookla-speedtest
      util-linux # for small systems

      #any-nix-shell # fish support for nix shell
      #dconf2nix # Nix code from Dconf files
      #nix-index # locate packages containing certain nixpkgs
      #nix-output-monitor # nom: monitor nix commands
    ];

    sessionVariables = {
      EDITOR = "micro";
      MANPAGER = "sh -c 'col --no-backspaces --spaces | bat --language man'";
      PAGER = "moar";
      SYSTEMD_EDITOR = "micro";
      VISUAL = "micro";

      # clean up ~
      # LESSHISTFILE = cache + "/less/history";
      # WINEPREFIX = d + "/wine";
      # XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
    };
  };
  #home-manager = {
  programs = {
    #enable = true;
    info.enable = true;
    jq.enable = true;
    nix-index.enable = true;
    #};
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
