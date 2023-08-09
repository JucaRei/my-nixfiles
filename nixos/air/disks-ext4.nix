{disks ? ["/dev/sda"], ...}: let
  defaultsBoot = ["defaults" "noatime" "nodiratime"];
  defaultExtOpts = ["defaults" "data=writeback" "commit=60" "barrier=0" "discard" "noatime" "nodiratime"];
in {
  disko.devices = {
    disk = {
      sda = {
        type = "disk"
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "300MiB";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = defaultsBoot;
              };
            };
            swap = {
              size = "6GiB";
              content = {
                type = "swap";
                randomEncryption = true;
                resumeDevice = true;
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                extraArgs = [ "-f" ];
                format = "ext4";
                mountpoint = "/";
                mountOptions = defaultExtOpts;
              };
            };
          };
        };
      };
    };
  };
}
