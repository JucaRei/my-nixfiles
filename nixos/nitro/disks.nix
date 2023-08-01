{ ... }:
#nvme0n1p5
let
  defaultXfsOpts = [ "defaults" "relatime" "nodiratime" ];
in
{
  disko.devices = {
    disk = {
      nvme0n1 = {
        device = "nvme0n1p5";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              name = "ESP";
              priority = 1;
              start = "0%";
              end = "550MiB";
              bootable = true;
              flags = [ "esp" ];
              fs-type = "fat32";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = 
              name = "root";
              start = "550MiB";
              end = "100%";
              content = {
                type = "filesystem";
                # Overwirte the existing filesystem
                extraArgs = [ "-f" ];
                format = "xfs";
                mountpoint = "/";
                mountOptions = defaultXfsOpts;
            };
          };
        };
      };
    };
  };
};
}
