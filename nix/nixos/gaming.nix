{ inputs, self, ... }:
{
  flake.modules.nixos.gaming = {
    imports = [
      self.modules.nixos.hw-controllers
    ];
  };
}
