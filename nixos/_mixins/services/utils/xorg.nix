_: {
  services = {
    xserver = {
      enable = true;
      exportConfiguration = true;
      libinput.enable = true;
      libinput.touchpad = {
        horizontalScrolling = true;
        naturalScrolling = true;
        tapping = true;
        tappingDragLock = false;
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      clinfo
      libva-utils
      vdpauinfo
      intel-gpu-tools
    ];

    variables = {
    # Firefox fixes
    MOZ_X11_EGL = "1";
    MOZ_USE_XINPUT2 = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";

    # Webkit2gtk fixes
    WEBKIT_DISABLE_COMPOSITING_MODE = "1";
  };
  };
}