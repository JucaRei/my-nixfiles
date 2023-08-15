{ pkgs, lib, ... }: {
  services.journald.extraConfig = lib.mkDefault "SystemMaxUse=200M";
}
