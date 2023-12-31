{ disks ? [ "/dev/sda" ], ... }:
let
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
          type = "table";
          format = "gpt";
          partitions = [{
            name = "ESP";
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
          }
            {
              name = "Swap";
              start = "550MiB";
              size = "6GiB";
              content = {
                type = "swap";
                randomEncryption = true;
                resumeDevice = true;
              };
            };
            {
              name = "root";
              start = "6GiB";
              end = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "/rootfs" = {
                    mountpoint = "/";
                    mountOptions = [ "subvol=@" options ];
                  };
                  # Subvolume name is the same as the mountpoint
                  "/home" = {
                    mountOptions = [ "subvol=@home" options ];
                    mountpoint = "/home";
                  };
                  "/.snapshots" = {
                    mountOptions = [ "subvol=@snapshots" options ];
                    mountpoint = "/.snapshots";
                  };
                  "/tmp" = {
                    mountOptions = [ "subvol=@tmp" options ];
                    mountpoint = "/tmp";
                  };
                  "/nix" = {
                    mountOptions = [ "subvol=@nix" options ];
                    mountpoint = "/nix";
                  };
                  # This subvolume will be created but not mounted
                  "/swap" = { };
                };
              };
            };]};
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
          type = "gpt";
          partitions = {
            EFI = {
              start = 0;
              end = "550MiB";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
                mountOptions = [ "default" "noatime" "nodiratime" ];
              };
            };
            root = {
              start = "550MiB";
              end = "-6GiB";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "/rootfs" = {
                    mountpoint = "/";
                    mountOptions = [ "subvol=@" "rw" "noatime" "nodiratime" "ssd" "nodatacow" "compress-force=zstd:5" "space_cache=v2" "commit=120" "discard=async" ];
                  };
                  # Subvolume name is the same as the mountpoint
                  "/home" = {
                    mountOptions = [ "subvol=@home" "rw" "noatime" "nodiratime" "ssd" "nodatacow" "compress-force=zstd:15" "space_cache=v2" "commit=120" "discard=async" ];
                    mountpoint = "/home";
                  };
                  "/.snapshots" = {
                    mountOptions = [ "subvol=@snapshots" "rw" "noatime" "nodiratime" "ssd" "nodatacow" "compress-force=zstd:15" "space_cache=v2" "commit=120" "discard=async" ];
                    mountpoint = "/.snapshots";
                  };
                  "/tmp" = {
                    mountOptions = [ "subvol=@tmp" "rw" "noatime" "nodiratime" "ssd" "nodatacow" "compress-force=zstd:5" "space_cache=v2" "commit=120" "discard=async" ];
                    mountpoint = "/tmp";
                  };
                  "/nix" = {
                    mountOptions = [ "subvol=@nix" "rw" "noatime" "nodiratime" "ssd" "nodatacow" "compress-force=zstd:15" "space_cache=v2" "commit=120" "discard=async" ];
                    mountpoint = "/nix";
                  };
                  # This subvolume will be created but not mounted
                  "/swap" = { };
                };
              };
            };
            SWAP = {
              size = "100%";
              content = {
                type = "swap";
                extraArgs = ["--allow-discards"]
                randomEncryption = true;
                resumeDevice = true;
              };
            };
          };
        };
      };
    };
  };
}
