{
  flake.diskoConfigurations.hyphasis = let
    device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5P2NL0WC03960J";
  in {
    disko.devices = {
      disk.main = {
        inherit device;

        type = "disk";
        content = {
          type = "gpt";
          partitions = {
             boot = {
              size = "1M";
              type = "EF02";
            };
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "enc";
                settings = {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  mountOptions = [ "compress=zstd" "noatime" ];
                  postCreateHook = ''
                    MNTPOINT=$(mktemp -d)
                    mount "/dev/mapper/enc" "$MNTPOINT" -o subvol=/
                    trap 'umount $MNTPOINT; rm -rf $MNTPOINT' EXIT
                    btrfs subvolume snapshot -r $MNTPOINT/rootfs $MNTPOINT/rootfs-blank
                  '';

                  subvolumes = {
                    "/rootfs" = {
                      mountpoint = "/";
                    };
                    "/home" = {
                      mountpoint = "/home";
                    };
                    "/nix" = {
                      mountOptions = [ "compress-force=zstd:3" ];
                      mountpoint = "/nix";
                    };
                    "/persist" = {
                      mountOptions = [ "lazytime" ];
                      mountpoint = "/persist";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
