_: {
  # https://nixos.wiki/wiki/Steam
  fonts.fontconfig.cache32Bit = true;
  hardware = {
    steam-hardware.enable = true;
    #remotePlay.openFirewall = true;
    opengl.driSupport32Bit = true;
  };
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    # On-demand system optimization for gaming
    gamemode.enable = true;
  };
  services = {
    jack.alsa.support32Bit = true;
    pipewire.alsa.support32Bit = true;

    # Nintendo Pro Controller / Joycon support
    #joycond.enable = true;
  };
}
