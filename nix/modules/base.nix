{ self, ... }:
{
  flake.modules.nixos.base = {
    imports = with self.modules.nixos; [
      common
      has-sops # secrets enabled by default
    ];
  };
}
