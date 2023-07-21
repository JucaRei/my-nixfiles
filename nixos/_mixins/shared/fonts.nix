_: {
  #############
  ### Fonts ###
  #############

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override {
        fonts =
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerdfonts/shas.nix
          [ "FiraCode" "SourceCodePro" "UbuntuMono" "Iosevka" "IBMPlexMono" ];
      })
      fira
      fira-go
      joypixels
      liberation_ttf
      noto-fonts-emoji # emoji
      source-serif
      ubuntu_font_family
      work-sans
      siji # https://github.com/stark/siji
      ipafont # display jap symbols like シートベルツ in polybar
      source-code-pro
      terminus_font
      source-sans-pro
      roboto
      cozette
    ];

    # Enable a basic set of fonts providing several font styles and families and reasonable coverage of Unicode.
    enableDefaultFonts = false;

    fontconfig = {
      antialias = true;
      defaultFonts = {
        serif = [ "Source Serif" ];
        sansSerif = [ "Work Sans" "Fira Sans" "FiraGO" ];
        monospace = [ "FiraCode Nerd Font Mono" "SauceCodePro Nerd Font Mono" ];
        emoji = [ "Joypixels" "Noto Color Emoji" ];
      };
      enable = true;
      hinting = {
        autohint = false;
        enable = true;
        style = "hintslight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "light";
      };
    };
  };

}
