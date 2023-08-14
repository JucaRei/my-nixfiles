_:
let
disks = [
  "/dev/vda"
];
# "subvol=@"
options = [ "rw" "noatime" "nodiratime" "ssd" "nodatacow" "compress-force=zstd:5" "space_cache=v2" "commit=120" "discard=async" ];
in
{
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          #type = "table";
          #format = "gpt";
          type = "gpt";
          partitions = [
            {
              name = "EFI";
              start = "0%";
              end = "550MiB";
              type = "EF00";
              #size = "550M";
              #bootable = true;
              #flags = [ "esp" ];
              #fs-type = "fat32";
              #part-type = "primary";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" "noatime" "nodiratime" ];
              };
            }
            {
              name = "root";
              start = "550MiB";
              end = "-6GiB";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/rootfs" = {
                    mountpoint = "/";
                    mountOptions = [ "subvol=@" "rw" "noatime" "nodiratime" "ssd" "nodatacow" "compress-force=zstd:5" "space_cache=v2" "commit=120" "discard=async" ];
                  };
                  "/home" = {
                    mountOptions = [ "subvol=@home" "rw" "noatime" "nodiratime" "ssd" "nodatacow" "compress-force=zstd:5" "space_cache=v2" "commit=120" "discard=async" ];
                    mountpoint = "/home";
                  };
                  "/.snapshots" = {
                   mountOptions = [ "subvol=@snapshots" "rw" "noatime" "nodiratime" "ssd" "nodatacow" "compress-force=zstd:5" "space_cache=v2" "commit=120" "discard=async" ];
                   mountpoint = "/.snapshots";
                  };
                  "/tmp" = {
                    mountOptions = [ "subvol=@tmp" "rw" "noatime" "nodiratime" "ssd" "nodatacow" "compress-force=zstd:5" "space_cache=v2" "commit=120" "discard=async" ];
                    mountpoint = "/tmp";
                  };
                  "/nix" = {
                    mountOptions = [ "subvol=@nix" "rw" "noatime" "nodiratime" "ssd" "nodatacow" "compress-force=zstd:5" "space_cache=v2" "commit=120" "discard=async" "noxattr" "noacl" ];
                    mountpoint = "/nix";
                  };
                  # This subvolume will be created but not mounted
                  "/swap" = { };
                };
              };
            }
            {
              name = "Swap";
              start = "-6G";
              end = "100%";
              #size = "6GiB";
              content = {
                type = "swap";
                #extraOpenArgs = ["--allow-discards"];
                randomEncryption = true;
                resumeDevice = true;
              };
            }
          ];
        };
      };
    };
    # nodev = {
    #   "/" = {
    #     fsType = "tmpfs";
    #     mountOptions = [
    #       "defaults"
    #       "mode=755"
    #     ];
    #   };
    # };
  };
}
