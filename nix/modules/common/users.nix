{
  flake.modules.nixos.common = { lib, ... }: {
    users.mutableUsers = lib.mkDefault false;
  };
}
