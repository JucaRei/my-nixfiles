{ config, pkgs, lib, ... }:

{
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      dns proxy = no
      log file = /var/log/samba/%m.log
      max log size = 1000
      client min protocol = NT1
      security = user
      #use sendfile = yes
      #max protocol = smb2
      #hosts allow = 10.77  192.168.1 127.
      hosts allow = 192.168.1 127.
      guest account = nobody
      map to guest = bad user
      ntlm auth = true
      signing_required = no
    '';
    #shares = {
    #  public = {
    #    path = "/data";
    #    browseable = "yes";
    #    "read only" = "no";
    #    "guest ok" = "yes";
    #    "create mask" = "0644";
    #    "directory mask" = "0755";
    #    "force user" = "cadey";
    #    "force group" = "cadey";
    #  };
    #};
  };
}