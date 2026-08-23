{
  flake.modules.nixos.has-graphics = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
