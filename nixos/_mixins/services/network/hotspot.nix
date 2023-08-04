{
  config,
  lib,
  pkgs,
  ...
}: {
  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "eth0";
      WIFI_IFACE = "wlan0";
      SSID = "NixOS";
      PASSPHRASE = "12345678";
    };
  };
}
