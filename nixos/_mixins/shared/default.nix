{ pkgs, lib, config, ... }:
# let
#   # Break these packages out so they can be imported elsewhere as a common set
#   # of baseline packages. Useful for installations that are home-manager-only
#   # on other OSs, rather than NixOS.
#   inherit ((import ./packages.nix { inherit pkgs; })) basePackages;
# in
{
  imports = [
    ../services/configs
    ../services/utils
    ../services/network/networkmanager.nix
    ../services/network/openssh.nix
    ../services/printer/cups.nix
    ../services/sound/pipewire.nix
    ../services/scanner/sane.nix
    ../services/security/firewall.nix
    ../services/security/polkit.nix
    ../hardware/bluetooth
    #../hardware/power/powertop-save.nix
    ../hardware/harddrive/ssd.nix
    #../editors
    ./fonts.nix
    ./console.nix
    ./shells.nix
  ];

  ############################
  ### Default Boot Options ###
  ############################
  boot = {
    initrd = { 
      verbose = false; 
    };
    consoleLogLevel = 0;
    kernelModules = [ 
      "vhost_vsock"
      "kvm-intel"
      "tcp_bbr"
    ];
    kernelParams = [
      # The 'splash' arg is included by the plymouth option
      "quiet"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    kernel = {
      sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.all.forwarding" = 1;

        ### Improve networking
        # https://www.kernel.org/doc/html/latest/admin-guide/sysrq.html
        "kernel.sysrq" = 1;
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "cake";
        #"net.core.default_qdisc" = "fq";

        # Bypass hotspot restrictions for certain ISPs
        "net.ipv4.ip_default_ttl" = 65;
      };
    };
  };

  ################
  ### Defaults ###
  ################

  environment = {
    # Eject nano and perl from the system
    defaultPackages = with pkgs; lib.mkForce [
      gitMinimal
      home-manager
      micro
      rsync
    ];
    systemPackages = with pkgs; [
      agenix
      pciutils
      psmisc
      unzip
      usbutils
    ];
    variables = {
      EDITOR = "micro";
      SYSTEMD_EDITOR = "micro";
      VISUAL = "micro";
    };
  };

  #######################
  ### Default Locales ###
  #######################

  i18n = {
    defaultLocale = lib.mkForce "en_US.utf8";
    extraLocaleSettings = lib.mkDefault {
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

  ########################
  ### Default Timezone ###
  ########################

  services.xserver.layout = if (builtins.isString == "nitro") then "br" else "us";
  time.timeZone = lib.mkDefault "America/Sao_Paulo";
  #location = {
  #  latitude = -23.539380;
  #  longitude = -46.652530;
  #};

}
