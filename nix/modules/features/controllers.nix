{ self, ... }:
{
  flake.modules.nixos.has-controllers = {
    imports = with self.modules.nixos; [
      hw-controllers
    ];
  };
}
