{ inputs, self, ... }:
{
  flake.modules.nixos.graphical = {
    # locale
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
