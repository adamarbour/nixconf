{
  flake.modules.nixos.hyphasis = {

    boot.initrd.luks.devices."luks-5954e8dd-a434-4d9a-8310-06da503dde03".device = "/dev/disk/by-uuid/5954e8dd-a434-4d9a-8310-06da503dde03";

    fileSystems."/" = {
      device = "/dev/mapper/luks-5954e8dd-a434-4d9a-8310-06da503dde03";
      fsType = "btrfs";
      options = [ "noatime" "compress=zstd" ];
    };

    fileSystems."/home" = {
      device = "/dev/mapper/luks-5954e8dd-a434-4d9a-8310-06da503dde03";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

    fileSystems."/nix" = {
      device = "/dev/mapper/luks-5954e8dd-a434-4d9a-8310-06da503dde03";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/AABB-D69D";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" "noatime" ];
    };

  };
}
