{ ... }: {
  imports = [
    ../../services/utils/smartmon.nix
  ];
  services.fstrim.enable = true;
}
