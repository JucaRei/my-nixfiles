{ pkgs, config, lib, ... }: {
  networking = {
    firewall = {
      allowedTCPPorts = [ 22 ];
      allowPing = true;
    };
    networkmanager = {
      enable = true;
      wifi = {
        backend = lib.mkDefault "iwd";
        #macAddress = "random";
        #scanRandMacAddress = true;
      };
      ethernet = {
        #macAddress = "random";
      };
      plugins = with pkgs; [
        networkmanager-openvpn
        networkmanager-openconnect
      ];
      unmanaged = [
        "interface-name:veth*"
      ];
    };
    extraHosts = ''
      192.168.1.50  nitro
      192.168.1.35  nitro
      192.168.1.230 air
      192.168.1.200 DietPi
      192.168.1.76  rocinante
      192.168.1.45  rocinante
    '';
  };

  # Make it use predictable interface names starting with eth0
  boot.kernelParams = [ "net.ifnames=0" ];

  # Workaround https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;
}
