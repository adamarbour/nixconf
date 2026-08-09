{ inputs, self, ... }:
{
  flake.modules.nixos.desktop = { lib, ... }: {
    imports = [
      self.modules.nixos.wifi
    ];

    networking.networkmanager.wifi.powersave = lib.mkDefault false;
  };
}
