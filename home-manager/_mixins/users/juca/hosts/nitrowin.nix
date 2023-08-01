{ lib, pkgs, ... }:
with lib.hm.gvariant; {
  imports = [
    #../../../services/mpris-proxy.nix
    #../../../services/syncthing.nix
  ];
  services.kbfs.enable = lib.mkForce false;
  home.packages = with pkgs; [
    ookla-speedtest
    util-linux # for small systems
    openssh
  ];
}
