{
  flake.modules.nixos.hw-controllers = { pkgs, ... }: {
    hardware = {
      uinput.enable = true;
      steam-hardware.enable = true;
      xpadneo.enable = true;
    };

    services.udev.packages = with pkgs; [
      steam-devices-udev-rules
      game-devices-udev-rules
    ];
  };
}
