{ lib, ... }:
with lib.hm.gvariant; {
  imports = [
    #../../../services/mpris-proxy.nix
    #../../../services/syncthing.nix
  ];
  services.kbfs.enable = lib.mkForce false;
  targets.genericLinux.enable = true;

  # # nixgl
  # nixgl.auto.nixGLDefault
  # nixgl.auto.nixGLNvidia
  # nixgl.auto.nixGLNvidiaBumblebee
  # nixgl.nixGLIntel

  # home = {
    # sessionVariable = {
      # QT_XCB_GL_INTEGRATION = "none"; # kde-connect
    # };
  # };

  # services = {
  #   kdeconnect = {
  #     enable = true;
  #     indicator = true;
  #   };
  # };
}
