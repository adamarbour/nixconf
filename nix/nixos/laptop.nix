{ inputs, self, ... }:
{
  flake.modules.nixos.laptop = {
    imports = [
      self.modules.nixos.graphical
    ];
  };
}
