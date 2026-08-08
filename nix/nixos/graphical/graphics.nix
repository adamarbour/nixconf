{ inputs, self, ... }:
{
  flake.modules.nixos.graphical = {
    # hardware assumption
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
