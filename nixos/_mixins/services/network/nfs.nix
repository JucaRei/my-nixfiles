{ pkgs, ... }:{
  services.rcpbind.enable = true;

  environment.systemPackages = with pkgs; [
    nfs.utils
  ];
}