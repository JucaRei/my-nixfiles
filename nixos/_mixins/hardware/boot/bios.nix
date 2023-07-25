{ lib, ... }: {
  boot = {
    initrd = {
      # SSH on initramfs.
      network = {
        enable = true;
        ssh.enable = true;
      };
    };
    tmp.cleanOnBoot = true;
    loader = {
      efi = {
        canTouchEfiVariables = false;
      };
      grub = {
        enable = true;
        version = 2;
        efiSupport = false;
        device = lib.mkDefault "/dev/sda"; # MBR/BIOS

        backgroundColor = "#21202D";
        configurationLimit = 6;

        extraConfig = ''
          set menu_color_normal=light-blue/black
          set menu_color_highlight=black/light-blue
        '';
        splashMode = lib.mkDefault "normal";
        #splashImage = lib.mkDefault null;
      };
    };
  };
}
