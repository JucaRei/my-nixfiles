# Example to create a bios compatible gpt partition
{ disks ? [ "/dev/sda" ], ... }:
let
  #defaultXfsOpts = [ "defaults" "relatime" "nodiratime" ];
  defaultExt4Opts = [ "defaults" "noatime" "nodiratime" "commit=60" "barrier=0 " ];
in
{
  disko.devices = {
    disk = {
      sda = {
        #device = "/dev/sda";
        device = builtins.elemAt disks 0;
        type = "disk";
        content = {
          type = "gpt";
          #type = "msdos";
          partitions = [{
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
              flags = [ "bios_grub" ];
            }
              {
                name = "NIXOS";
                start = "1M";
                end = "100%";
                content = {
                  type = "filesystem";
                  # Overwirte the existing filesystem
                  #extraArgs = [ "-f" ];
                  format = "ext4";
                  mountpoint = "/";
                  mountOptions = defaultExt4Opts;
                };
              };
          }];
        };
      };
    };
  };

  #disko.devices = {
  #  disk = {
  #    sda = {
  #      device = "/dev/sda";
  #      type = "disk";
  #      content = {
  #        type = "table";
  #        format = "msdos";
  #        partitions = [
  #          {
  #            name = "NIXOS";
  #            part-type = "primary";
  #            start = "1M";
  #            end = "100%";
  #            bootable = true;
  #            content = {
  #              type = "filesystem";
  #              format = "ext4";
  #              mountpoint = "/";
  #            };
  #          }
  #        ];
  #      };
  #    };
  #  };
  #};
}
