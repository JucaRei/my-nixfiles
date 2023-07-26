_: {
  #############################
  ### Fish as default Shell ###
  #############################

  programs = {
    command-not-found.enable = false;
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_cursor_default block blink
        set fish_cursor_insert line blink
        set fish_cursor_replace_one underscore blink
        set fish_cursor_visual block
        set -U fish_color_autosuggestion brblack
        set -U fish_color_cancel -r
        set -U fish_color_command green
        set -U fish_color_comment brblack
        set -U fish_color_cwd brgreen
        set -U fish_color_cwd_root brred
        set -U fish_color_end brmagenta
        set -U fish_color_error red
        set -U fish_color_escape brcyan
        set -U fish_color_history_current --bold
        set -U fish_color_host normal
        set -U fish_color_match --background=brblue
        set -U fish_color_normal normal
        set -U fish_color_operator cyan
        set -U fish_color_param blue
        set -U fish_color_quote yellow
        set -U fish_color_redirection magenta
        set -U fish_color_search_match bryellow '--background=brblack'
        set -U fish_color_selection white --bold '--background=brblack'
        set -U fish_color_status red
        set -U fish_color_user brwhite
        set -U fish_color_valid_path --underline
        set -U fish_pager_color_completion normal
        set -U fish_pager_color_description yellow
        set -U fish_pager_color_prefix white --bold --underline
        set -U fish_pager_color_progress brwhite '--background=cyan'
      '';
      shellAbbrs = {
        # https://github.com/NixOS/nixpkgs/issues/191128#issuecomment-1246030417
        mkhostid = "head -c4 /dev/urandom | od -A none -t x4";

        # VM testing
        nixclone =
          "git clone --depth=1 https://github.com/JucaRei/nix-configurations $HOME/Zero/nix-config";
        nix-gc = "sudo nix-collect-garbage --delete-older-than 5d";
        #rebuild-all = "sudo nix-collect-garbage --delete-older-than 14d && sudo nixos-rebuild switch --flake $HOME/Zero/nix-config && home-manager switch -b backup --flake $HOME/Zero/nix-config";
        rebuild-all = "sudo nix-collect-garbage --delete-older-than 5d && sudo nixos-rebuild boot --flake $HOME/Zero/nix-config && home-manager switch -b backup --flake $HOME/Zero/nix-config && sudo reboot";
        rebuild-home-now = "home-manager switch -b backup --flake $HOME/Zero/nix-config";
        rebuild-home-build = "home-manager build -b backup --flake $HOME/Zero/nix-config";
        rebuild-host-now = "sudo nixos-rebuild switch --flake $HOME/Zero/nix-config";
        rebuild-host-boot = "sudo nixos-rebuild boot --flake $HOME/Zero/nix-config";
        rebuild-lock = "pushd $HOME/Zero/nix-config && nix flake lock --recreate-lock-file && popd";
        rebuild-iso-console = "pushd $HOME/Zero/nix-config && nix build .#nixosConfigurations.iso-console.config.system.build.isoImage && popd";
        rebuild-iso-desktop = "pushd $HOME/Zero/nix-config && nix build .#nixosConfigurations.iso-desktop.config.system.build.isoImage && popd";
        nix-hash-sha256 = "nix-hash --flat --base32 --type sha256";
        #rebuild-home = "home-manager switch -b backup --flake $HOME/.setup";
        #rebuild-host = "sudo nixos-rebuild switch --flake $HOME/.setup";
        #rebuild-lock = "pushd $HOME/.setup && nix flake lock --recreate-lock-file && popd";
        #rebuild-iso = "pushd $HOME/.setup && nix build .#nixosConfigurations.iso.config.system.build.isoImage && popd";
      };
      shellAliases = {
        moon = "curl -s wttr.in/Moon";
        nano = "micro";
        open = "xdg-open";
        pubip = "curl -s ifconfig.me/ip";
        #pubip = "curl -s https://api.ipify.org";
        wttr = "curl -s wttr.in && curl -s v2.wttr.in";
        wttr-bas = "curl -s wttr.in/basingstoke && curl -s v2.wttr.in/basingstoke";
      };
    };
    #nano.syntaxHighlight = true;
    #nano.nanorc = ''
    #  set autoindent   # Auto indent
    #  set constantshow # Show cursor position at the bottom of the screen
    #  set fill 78      # Justify command (Ctrl+j) wraps at 78 columns
    #  set historylog   # Remember command history
    #  set multibuffer  # Allow opening multiple files (Alt+< and Alt+> to switch)
    #  set nohelp       # Remove the help bar from the bottom of the screen
    #  set nowrap       # Do not wrap text
    #  set quickblank   # Clear status messages after a single keystroke
    #  set regexp       # Enable regular expression mode for find (Ctrl+r to disable)
    #  set smarthome    # Home key jumps to first non-whitespace character
    #  set tabsize 4    # Insert 4 spaces per tab
    #  set tabstospaces # Tab key inserts spaces (Ctrl+t for verbatim mode)
    #  set numbercolor blue,black
    #  set statuscolor black,yellow
    #  set titlecolor black,magenta
    #  include "${pkgs.nano}/share/nano/extra/*.nanorc"
    #'';
  };

}
