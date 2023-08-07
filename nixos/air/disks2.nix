_:
let
  # "subvol=@"
  options = [ "rw" "noatime" "nodiratime" "ssd" "nodatacow" "compress-force=zstd:5" "space_cache=v2" "commit=120" "autodefrag" "discard=async" ];
in
{
  disko.devices = {
    disk = {
      sda = {
      type = "disk";
      device = "/dev/disk/by-id/ata-APPLE_SSD_TS064C_61UA30RXK6HK";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
priority = 1;
name = "ESP";
start = 0;
end = "512MiB";
type = "EF00";
content = {
type = "filesystem";
format = "vfat";
mountpoint = "/boot";
};
};

};
};
};
};
  };
}