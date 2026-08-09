{ inputs, self, ... }:
{
  flake.modules.nixos.laptop = { lib, ... }: {
    imports = [
      self.modules.nixos.wifi
    ];

    networking.networkmanager.wifi.powersave = lib.mkDefault true;
  };
}
