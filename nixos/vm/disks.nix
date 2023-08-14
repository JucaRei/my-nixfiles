_: let
  disks = [
    "/dev/vda"
  ];
in {
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          # type = "table";
          # format = "gpt";
          type = "gpt";
          partitions = [
            {
              name = "EFI";
              start = "0%";
              end = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
                mountOptions = ["default" "noatime" "nodiratime"];
              };
            }
            {
              name = "NIXOS";
              start = "512M";
              end = "-6G";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
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
            }
            {
              name = "SWAP";
              start = "-6G";
              end = "100%";
              content = {
                type = "swap";
                extraArgs = ["--allow-discards"]
                randomEncryption = true;
                resumeDevice = true;
              };
            }
          ];
        };
      };
    };
  };
}
