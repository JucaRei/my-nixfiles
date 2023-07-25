# Example to create a bios compatible gpt partition
{ disks ? [ "/dev/sda" ], ... }:
let
  #defaultXfsOpts = [ "defaults" "relatime" "nodiratime" ];
  defaultExt4Opts = [ "defaults" "noatime" "nodiratime" "commit=60" "barrier=0 " ];
in
{
  disko.devices = {
    disk = {
      vdb = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
              flags = [ "bios_grub" ];
            };
            root = {
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
