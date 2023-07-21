{ pkgs, lib, ... }: {
  imports = [
    ../services/configs
    ../services/utils
    ../services/network/networkmanager.nix
    ../services/network/openssh.nix
    ../services/printer/cups.nix
    ../hardware/bluetooth
    ../hardware/power/powertop-save.nix
    ../hardware/harddrive/ssd.nix
    ../editors
  ];

  #######################
  ### Default Locales ###
  #######################

  i18n = {
    defaultLocale = "en_US.utf8";
    extraLocaleSettings = {
      #LC_CTYPE = lib.mkDefault "pt_BR.UTF-8"; # Fix ç in us-intl.
      LC_ADDRESS = "pt_BR.utf8";
      LC_IDENTIFICATION = "pt_BR.utf8";
      LC_MEASUREMENT = "pt_BR.utf8";
      LC_MONETARY = "pt_BR.utf8";
      LC_NAME = "pt_BR.utf8";
      LC_NUMERIC = "pt_BR.utf8";
      LC_PAPER = "pt_BR.utf8";
      LC_TELEPHONE = "pt_BR.utf8";
      LC_TIME = "pt_BR.utf8";
      #LC_COLLATE = "pt_BR.utf8";
      #LC_MESSAGES = "pt_BR.utf8";
    };
    supportedLocales = [ "en_US.UTF-8/UTF-8" "pt_BR.UTF-8/UTF-8" ];
  };

  ###################
  ### Console tty ###
  ###################

  console = {
    keyMap = if (builtins.isString == "nitro") then "br-abnt2" else "us";
    earlySetup = true;
    font = "${pkgs.tamzen}/share/consolefonts/TamzenForPowerline10x20.psf";
    colors = [
      "1b161f"
      "ff5555"
      "54c6b5"
      "d5aa2a"
      "bd93f9"
      "ff79c6"
      "8be9fd"
      "bfbfbf"

      "1b161f"
      "ff6e67"
      "5af78e"
      "ffce50"
      "caa9fa"
      "ff92d0"
      "9aedfe"
      "e6e6e6"
    ];
    packages = with pkgs; [ tamzen ];
  };

  services.getty.greetingLine = lib.mkForce "\\l";
  services.getty.helpLine = lib.mkForce ''
    Type `i' to print system information.

    .     .       .  .   . .   .   . .    +  .
      .     .  :     .    .. :. .___---------___.
           .  .   .    .  :.:. _".^ .^ ^.  '.. :"-_. .
        .  :       .  .  .:../:            . .^  :.:\.
            .   . :: +. :.:/: .   .    .        . . .:\
     .  :    .     . _ :::/:               .  ^ .  . .:\
      .. . .   . - : :.:./.                        .  .:\
      .      .     . :..|:                    .  .  ^. .:|
        .       . : : ..||        .                . . !:|
      .     . . . ::. ::\(                           . :)/
     .   .     : . : .:.|. ######              .#######::|
      :.. .  :-  : .:  ::|.#######           ..########:|
     .  .  .  ..  .  .. :\ ########          :######## :/
      .        .+ :: : -.:\ ########       . ########.:/
        .  .+   . . . . :.:\. #######       #######..:/
          :: . . . . ::.:..:.\           .   .   ..:/
       .   .   .  .. :  -::::.\.       | |     . .:/
          .  :  .  .  .-:.":.::.\             ..:/
     .      -.   . . . .: .:::.:.\.           .:/
    .   .   .  :      : ....::_:..:\   ___.  :/
       .   .  .   .:. .. .  .: :.:.:\       :/
         +   .   .   : . ::. :.:. .:.|\  .:/|
         .         +   .  .  ...:: ..|  --.:|
    .      . . .   .  .  . ... :..:.."(  ..)"
     .   .       .      :  .   .: ::/  .  .::\
  '';
}
