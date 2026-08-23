{ self, ... }:
{
  flake.modules.nixos.common = {
    imports = with self.modules.nixos; [
      topology
    ];
  };
}
