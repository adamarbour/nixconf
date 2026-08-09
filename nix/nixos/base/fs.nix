{
  flake.modules.nixos.base = { pkgs, lib, ... }: {
    services = {
      fstrim = {
        enable = true;
        interval = "weekly";
      };

      # clean btrfs devices
      btrfs.autoScrub = {
        enable = config.boot.supportedFilesystems.btrfs or false;
        interval = "weekly";
        fileSystems = [ "/" ];
      };
    };
  };
}
