{ pkgs, ... }: {
  imports = [
    #../services/flatpak.nix
    #../services/sane.nix
    ../apps/terminal/tilix.nix
  ];

  environment.systemPackages = with pkgs; [
    celluloid
    jdk17
    nodejs_20
    tree-sitter
    gnome.gucharmap
    gnome-firmware
    gthumb
    usbimager
  ];

  # Enable some programs to provide a complete desktop
  programs = {
    gnome-disks.enable = true;
    seahorse.enable = true;
  };
}
