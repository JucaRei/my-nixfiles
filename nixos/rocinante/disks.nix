{ disks ? [ "/dev/sda" ], ... }:
let
  #defaultXfsOpts = [ "defaults" "relatime" "nodiratime" ];
  defaultExt4Opts = [ "defaults" "noatime" "nodiratime" "commit=60" "barrier=0 " ];
in
{
  #disko.devices = {
  #
  #type = "disk";
  #content = {
  #  type = "table";
  #  format = "gpt";
  #  partitions = [{
  #    name = "boot/efi";
  #    start = "0%";
  #    end = "1M";
  #    flags = [ "bios_grub" ];
  #  }
  #    {
  #      name = "ESP";
  #      start = "1M";
  #      end = "550MiB";
  #      bootable = true;
  #      flags = [ "esp" ];
  #      fs-type = "fat32";
  #      content = {
  #        type = "filesystem";
  #        format = "vfat";
  #        mountpoint = "/boot";
  #      };
  #    }
  #    {
  #      name = "root";
  #      start = "550MiB";
  #      end = "100%";
  #      content = {
  #        type = "filesystem";
  #        # Overwirte the existing filesystem
  #        extraArgs = [ "-f" ];
  #        format = "xfs";
  #        mountpoint = "/";
  #        mountOptions = defaultXfsOpts;
  #      };
  #    }];
  #};
  #};
  disko.devices = {
    disk = {
      sda = {
        device = "/dev/sda";
        #device = builtins.elemAt disks 0;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
              flags = [ "bios_grub" ];
            } {
              #NIXOS = {
              name = "NIXOS";
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                # Overwirte the existing filesystem
                extraArgs = [ "-f" ];
                mountpoint = "/";
                mountOptions = defaultExt4Opts;
              };
            };
          };
        };
      };
    };
  };
}
