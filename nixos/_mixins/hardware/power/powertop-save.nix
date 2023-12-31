{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    powertop
    acpi
    tlp
  ];

  environment.systemPackages = [config.boot.kernelPackages.x86_energy_perf_policy];

  boot = {
    kernelParams = [ "pcie_aspm.policy=powersave" ];
    extraModprobeConfig = ''
      options snd_hda_intel power_save=1
      options iwlwifi power_save=1 d0i3_disable=0 uapsd_disable=0
      options iwldvm force_cam=0
      options i915 enable_guc=2 enable_fbc=1 enable_psr=1 enable_rc6=1
    '';
    kernel.sysctl = {
      "kernel.nmi_watchdog" = 0;
      "vm.dirty_writeback_centisecs" = 6000;
      "vm.laptop_mode" = 5;
    };
  };

  services = {
    #power-profiles-daemon.enable = true;
    # Automatic CPU speed and power optimizer for Linux
    #auto-cpufreq = { enable = true; };
    # Provide Power Management Support
    upower = {
      enable = true;
      usePercentageForPolicy = true;
      percentageLow = 40;
      percentageCritical = 20;
      percentageAction = 5;
      #criticalPowerAction = "Hibernate";
      criticalPowerAction = "HybridSleep";
    };
    #cpupower-gui.enable = true;

    #power-profiles-daemon.enable = lib.mkForce false; #dont work with tlp
    tlp = {
      enable = false;
      settings = {
        AHCI_RUNTIME_PM_ON_AC = "auto";
        AHCI_RUNTIME_PM_ON_BAT = "auto";
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MAX_PERF_ON_BAT = 100;
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MIN_PERF_ON_BAT = 0;
        # Disable too aggressive power-management autosuspend for USB receiver for wireless mouse
        USB_AUTOSUSPEND = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        NMI_WATCHDOG = 0;
        PCIE_ASPM_ON_AC = "performance";
        PCIE_ASPM_ON_BAT = "powersupersave";
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        # Runtime PM causes system lockup with i350-T4
        #RUNTIME_PM_DRIVER_DENYLIST = "igb";

        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";
        SCHED_POWERSAVE_ON_AC = 0;
        SCHED_POWERSAVE_ON_BAT = 1;
        TLP_DEFAULT_MODE = "AC";
      };
    };
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="net", KERNEL=="eth*", RUN+="${pkgs.ethtool}/bin/ethtool -s %k wol d"
      ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan*", RUN+="${pkgs.iw}/bin/iw dev %k set power_save on"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="min_power"
    '';
    ## this leads to non-responsive input devices
    # ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
    # i2p.enable = pkgs.lib.mkForce false;
    # tor.enable = pkgs.lib.mkForce false;
  };

  #powerManagement.powertop.enable = true;
  # FIXME always coredumps on boot
  #systemd.services.powertop.serviceConfig = {
  #  Restart = "on-failure";
  #  RestartSec = "2s";
  #};

  #systemd.user.timers.notify-on-low-battery = {
  #  timerConfig.OnBootSec = "2m";
  #  timerConfig.OnUnitInactiveSec = "2m";
  #  timerConfig.Unit = "notify-on-low-battery.service";
  #  wantedBy = [ "timers.target" ];
  #};

  #systemd.user.services.notify-on-low-battery = {
  #  serviceConfig.PassEnvironment = "DISPLAY";
  #  script = ''
  #    export battery_capacity=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/${battery}/capacity)
  #    export battery_status=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/${battery}/status)
  #
  #    if [[ $battery_capacity -le 10 && $battery_status = "Discharging" ]]; then
  #      ${pkgs.libnotify}/bin/notify-send --urgency=critical "$battery_capacity%: See you, space cowboy..."
  #    fi
  #  '';
  #};
}
