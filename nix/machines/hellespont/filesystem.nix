{
    flake.modules.nixos.hellespont = {

        boot.initrd.luks.devices."luks-78bd7afb-3e79-4451-9e89-f99f85125947".device = "/dev/disk/by-uuid/78bd7afb-3e79-4451-9e89-f99f85125947";

        fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/2C30-5EB3";
            fsType = "vfat";
            options = [ "fmask=0077" "dmask=0077" ];
        };

        swapDevices = [ ];

        fileSystems."/" = {
            device = "/dev/mapper/luks-78bd7afb-3e79-4451-9e89-f99f85125947";
            fsType = "btrfs";
            options = [ "compress=zstd" "noatime" ];
        };

        fileSystems."/home" = {
            device = "/dev/mapper/luks-78bd7afb-3e79-4451-9e89-f99f85125947";
            fsType = "btrfs";
            options = [ "subvol=home" "compress=zstd" "noatime" ];
        };

        fileSystems."/nix" = {
            device = "/dev/mapper/luks-78bd7afb-3e79-4451-9e89-f99f85125947";
            fsType = "btrfs";
            options = [ "subvol=nix" "compress=zstd" "noatime" ];
        };

    };
}
