{
  flake.modules.nixos.base = { lib, ... }: {
    services = {
      # monitor and control temperature
      thermald.enable = true;

      # enable smartd monitoring
      smartd.enable = true;

      # Not using lvm
      lvm.enable = lib.mkDefault false;
    };
  };
}
