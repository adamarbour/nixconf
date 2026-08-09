{
  flake.modules.nixos.hw-controllers = { pkgs, ...}: {
    hardware = {
      uinput.enable = true;
      steam-hardware.enable = true;
      xpadneo.enable = true;
    };
    services.udev.packages = [ pkgs.steam-devices-udev-rules pkgs.game-devices-udev-rules ];
  };
}
