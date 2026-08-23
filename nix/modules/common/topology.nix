{ self, ... }:
{
  flake.modules.nixos.common = { lib, ... }: {
    imports = with self.modules.nixos; [
      topology
    ];
  };
}
