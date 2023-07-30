{ pkgs, ... }:
with lib.hm.gvariant; {

    home.packages = with pkgs; ([
        kodi
        ]) ++ (with kodiPackages; [
          trakt
          youtube
    ]);
}