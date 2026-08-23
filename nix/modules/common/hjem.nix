{ self, ... }:
{
  flake.modules.nixos.common = { lib, ... }: {
    imports = with self.modules.nixos; [
      hjem
    ];

    hjem.clobberByDefault = lib.mkDefault true;
  };
}
