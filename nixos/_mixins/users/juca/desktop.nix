{ desktop, pkgs, lib, ... }: {
  imports = [
    #../../desktop/brave.nix
    #../../desktop/chromium.nix
    #../../desktop/firefox.nix
    #../../desktop/evolution.nix
    #../../desktop/google-chrome.nix
    #../../desktop/microsoft-edge.nix
    #../../desktop/obs-studio.nix
    #../../desktop/opera.nix
    #../../desktop/tilix.nix
    #../../desktop/vivaldi.nix
  ] 
  ++ lib.optional (builtins.pathExists (../.. + "/desktop/${desktop}-apps.nix")) ../../desktop/${desktop}-apps.nix
  ++ lib.optional (builtins.isString desktop) (../.. + "/apps/browsers/firefox.nix")
  ++ lib.optional (builtins.isString desktop) (../.. + "/apps/browsers/vivaldi.nix");

  environment.systemPackages = with pkgs; [
    audio-recorder
    #authy
    #chatterino2
    #cider #Apple music 
    #gimp-with-plugins
    gnome.gnome-clocks
    gnome.dconf-editor
    gnome.gnome-sound-recorder
    #irccloud
    #inkscape
    libreoffice
    meld
    #netflix
    pick-colour-picker
    rhythmbox
    shotcut
    #slack
    #zoom-us

    # Fast moving apps use the unstable branch
    #unstable.discord
    #unstable.fluffychat
    #unstable.gitkraken
    #unstable.tdesktop
    #unstable.vscode-fhs
    #unstable.wavebox
  ];
}
