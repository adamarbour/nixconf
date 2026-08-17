{
  flake.modules.nixos.hyphasis = {

    boot.initrd.luks.devices."enc" = {
      device = "/dev/disk/by-uuid/5954e8dd-a434-4d9a-8310-06da503dde03";
    };

    fileSystems."/" = {
      device = "/dev/mapper/enc";
      fsType = "btrfs";
      options = [ "noatime" "compress=zstd" ];
    };

    fileSystems."/home" = {
      device = "/dev/mapper/enc";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

    fileSystems."/nix" = {
      device = "/dev/mapper/enc";
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
