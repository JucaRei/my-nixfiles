{ lib, pkgs, ... }:
with lib.hm.gvariant; {
  imports = [
    #../../../apps/vorta.nix
    #../../../services/keybase.nix
    #../../../services/maestral.nix
    ../../../services/mpris-proxy.nix
    ../../../apps/media/kodi.nix
    #../../services/syncthing.nix
  ];
  #dconf.settings = {
  #  "org/gnome/desktop/background" = {
  #    picture-options = "zoom";
  #    picture-uri = "file:///home/juca/Pictures/Determinate/DeterminateColorway-1280x720.png";
  #  };
  #};S
  services.kbfs.enable = lib.mkForce true;
}
