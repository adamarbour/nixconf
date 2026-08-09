{ inputs, self, ... }:
{
  flake.modules.nixos.desktop = {
    imports = [
      # modules
      self.modules.nixos.graphical
    ];
  };
}
