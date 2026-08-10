{
  flake.modules.nixos.server = { lib, ... }: {
    time.timeZone = lib.mkForce "UTC";
  };
}
