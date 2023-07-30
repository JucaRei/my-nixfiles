{ lib, hostname, ... }:
let
  # Firewall configuration variable for syncthing
  syncthing = {
    hosts = [ "nitro" "rocinante" "air" "vm" "DietPi" ];
    tcpPorts = [ 22000 8384 ];
    udpPorts = [ 22000 21027 ];
  };
in
{
  networking = {
    firewall = {
      # if packets are still dropped, they will show up in dmesg
      #logReversePathDrops = true;
      enable = true;
      allowedTCPPorts =
        [ ]
        ++ lib.optionals (builtins.elem hostname syncthing.hosts)
          syncthing.tcpPorts;
      allowedUDPPorts =
        [ ]
        ++ lib.optionals (builtins.elem hostname syncthing.hosts)
          syncthing.udpPorts;
      extraCommands = ''
        iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns
      '';
      #Bluetooth
      autoLoadConntrackHelpers = true;
    };
  };
}
