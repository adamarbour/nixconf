{
  flake.diskoConfigurations.hellespont = let
    diskId = "nvme-Samsung_SSD_990_EVO_Plus_4TB_S7U8NJ0Y107348F";
  in {
    disko.devices = {
      disk.main = {
        type = "disk";
        device = "/dev/disk/by-id/${diskId}";

        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
            };
            esp = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            rootfs = {
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
                  mountOptions = [ "defaults" "compress=zstd" "noatime" ];
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
                    "/nix" = {
                      mountpoint = "/nix";
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [ "lazytime" ];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [ "lazytime" ];
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
