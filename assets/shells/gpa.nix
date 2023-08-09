{ config, options, lib, pkgs, ... }:

with lib;
let cfg = config.modules.desktop.gpa;
in {
  options.modules.desktop.gpa = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      # Graphical user interface for the GnuPG
      gpa
    ];
  };
}
