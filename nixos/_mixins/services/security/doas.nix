_: {
  security.doas = {
    enable = false;
    extraConfig = ''
      permit nopass :wheel
    '';
    #wheelNeedsPassword = false;
  };
}
